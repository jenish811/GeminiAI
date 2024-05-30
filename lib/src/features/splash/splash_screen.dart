import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/src/features/chat/screens/chat_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool isCompleteLoad = false;

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _slideController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  void _startAnimations() {
    _slideController.forward();
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    preDataLoad();
  }

  preDataLoad() async {
    Timer(const Duration(seconds: 4), () => Get.offAll(() => const ChatScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/gemini.png",
                    ),
                    Text(
                      "Talk With AI....",
                      style: GoogleFonts.quicksand(fontSize: 12.0, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
