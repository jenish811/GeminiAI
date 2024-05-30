import 'package:flutter/material.dart';
import 'package:flutter_gemini/src/constants/api_key.dart';
import 'package:flutter_gemini/src/constants/colors.dart';
import 'package:flutter_gemini/src/controller/api_controller.dart';
import 'package:flutter_gemini/src/controller/dark_mode.dart';
import 'package:flutter_gemini/src/features/chat/components/message_tile.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiController apiController = Get.put(ApiController());

  @override
  void initState() {
    super.initState();
    apiController.model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: OpenAi.apiKey,
    );
    apiController.chat = apiController.model.startChat();
  }

  final ThemeService _themeService = ThemeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gemini AI'),
          actions: [
            IconButton(
              icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                _themeService.switchTheme();
              },
            ),
          ],
        ),
        body: Obx(
          () => Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 90),
                itemCount: apiController.history.reversed.length,
                controller: apiController.scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  var content = apiController.history.reversed.toList()[index];
                  var text = content.parts.whereType<TextPart>().map<String>((e) => e.text).join('');
                  return MessageTile(
                    sendByMe: content.role == 'user',
                    message: text,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15,
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: TextField(
                            cursorColor: MyColors.primaryColor,
                            controller: apiController.textController.value,
                            autofocus: true,
                            focusNode: apiController.textFieldFocus.value,
                            decoration: InputDecoration(
                                hintText: 'Ask me anything...',
                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                filled: true,
                                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (apiController.textController.value.text.isNotEmpty) {
                            apiController.history.add(Content('user', [TextPart(apiController.textController.value.text)]));
                            apiController.sendChatMessage(apiController.textController.value.text, apiController.history.length);
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(offset: const Offset(1, 1), blurRadius: 3, spreadRadius: 3, color: Colors.black.withOpacity(0.05))]),
                          child: apiController.loading.value
                              ? const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
