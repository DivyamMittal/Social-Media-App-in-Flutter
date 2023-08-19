import 'dart:async';

import 'package:firebase_sample/Screens/AuthScreen/login_page.dart';
import 'package:firebase_sample/Screens/UI/navigation_controller.dart';
import 'package:firebase_sample/firebase/apis.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (APIs().auth.currentUser != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const NavigationScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          child: Icon(
            Icons.alternate_email_rounded,
            size: 150,
          ),
        ),
      ),
    );
  }
}
