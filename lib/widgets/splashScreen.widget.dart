import 'package:flutter/material.dart';
import 'dart:async';
import 'package:formule_one/screen/welcome.pages.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // Vitesse de descente
    );

    _revealAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart),
    );

    // --- LA CLÉ EST ICI ---
    // On attend que Flutter soit bien stable à l'écran avant de lancer le rideau
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controller.forward();
      }
    });

    // Navigation après la fin de l'animation
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomePage(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Le fond qui sera révélé
      body: Stack(
        children: [
          // 1. Contenu qui attend d'être découvert
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/splash.png', width: 250),
                const SizedBox(height: 10),
                const Text(
                  "F1nity",
                  style: TextStyle(fontFamily: 'F1Font', fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),

          // 2. Le rideau rouge animé
          AnimatedBuilder(
            animation: _revealAnimation,
            builder: (context, child) {
              return Align(
                alignment: Alignment.bottomCenter, // S'écrase vers le bas
                heightFactor: _revealAnimation.value,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0xFFE92C2F), // Ton rouge F1
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}