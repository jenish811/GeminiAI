import 'package:flutter/material.dart';
import 'package:flutter_gemini/connectivity_service/connectivity_controller.dart';
import 'package:flutter_gemini/src/controller/dark_mode.dart';
import 'package:flutter_gemini/src/features/splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = ThemeService();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeService.theme,
      home: const SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(ConnectivityController());
      }),

    );
  }
}
