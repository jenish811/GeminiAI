import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ApiController extends GetxController {
  RxBool loading = false.obs;
  Rx<TextEditingController> textController = TextEditingController().obs;
  Rx<FocusNode> textFieldFocus = FocusNode().obs;
  final ScrollController scrollController = ScrollController();

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }
  RxList<Part> parts = <Part>[].obs;
  RxList<Content> history = <Content>[].obs;
  late final GenerativeModel model;
  late final ChatSession chat;

  Future<void> sendChatMessage(String message, int historyIndex) async {
    loading.value = true;
    textController.value.clear();
    textFieldFocus.value.unfocus();
    _scrollDown();
    try {
      var response = chat.sendMessageStream(
        Content.text(message),
      );
      await for (var item in response) {
        var text = item.text;
        if (text == null) {
          _showError('No response from API.',Get.context);
          loading.value = false;

          return;
        } else {
          loading.value = false;
          parts.add(TextPart(text));
          if ((history.length - 1) == historyIndex) {
            history.removeAt(historyIndex);
          }
          history.insert(historyIndex, Content('model', parts));
        }
      }
    } catch (e) {
      _showError(e.toString(),Get.context);
      loading.value = false;

    }finally{
      loading.value = false;

    }
  }
  void _showError(String message,context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
