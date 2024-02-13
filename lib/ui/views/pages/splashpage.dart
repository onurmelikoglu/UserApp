import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:userapp/ui/views/auth/loginpage.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset("assets/animations/splash_animation.json"),
        backgroundColor: Colors.white,
        nextScreen: const LoginPage(),
        splashIconSize: 300,
        duration: 3800,
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.rightToLeftWithFade,
        animationDuration: const Duration(milliseconds: 700),
    );
  }
}
