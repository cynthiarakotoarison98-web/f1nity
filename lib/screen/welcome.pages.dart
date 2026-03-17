import 'package:flutter/material.dart';
import 'page_connexion.dart'; // 👈 IMPORTER ICI

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔴 IMAGE BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/welcome.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// ⚫ Dégradé noir en bas
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                  stops: const [0.4, 0.7, 1],
                ),
              ),
            ),
          ),

          /// 📝 Contenu texte
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Text(
                  "Welcome to F1nity",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Passionné par la course auto? Tas mis les gaz au bon endroit. Ici on carbure à l’adrénaline, on freine jamais. Rendez-vous au prochain virage en te connectant.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => page_connexion(),
                      ),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Tu as déjà un compte? ",
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: "Se connecter",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}