import 'dart:async';
import 'package:flutter/material.dart';
import 'package:PixelCraft/main.dart';

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
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 13, 50),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 250, child: Image.asset('assets/images/logo2.png')),
              const Text(
                "PixelCraft",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Poppins", fontSize: 44),
              )
            ],
          ),
        ));
  }
}
