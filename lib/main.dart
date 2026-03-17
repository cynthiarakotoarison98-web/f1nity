import 'package:flutter/material.dart';
import 'package:formule_one/screen/formula_one_app.pages.dart';
import 'package:formule_one/widgets/splashScreen.widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'F1nity',
      
      // La page qui s'affiche au lancement
      initialRoute: '/',
      
      // Définition de tes routes
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const FormulaOneApp(),
      },
    );
  }
}