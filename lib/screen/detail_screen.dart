import 'package:flutter/material.dart';
import '../models/driver.dart';

class DetailScreen extends StatelessWidget {
  final Driver driver;

  const DetailScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // On utilise la couleur accentColor du pilote pour l'AppBar
      appBar: AppBar(
        backgroundColor: driver.accentColor, 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER AVEC STACK ---
            Stack(
              clipBehavior: Clip.none, 
              children: [
                // Bloc de couleur dynamique
                Container(
                  height: 180,
                  width: double.infinity,
                  color: driver.accentColor, 
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.firstName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            driver.lastName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      // Drapeau dynamique
                      Text(driver.flag, style: const TextStyle(fontSize: 50)),
                    ],
                  ),
                ),
                // Image du Pilote (Positionnée dynamiquement)
                Positioned(
                  right: 0, // Changé en 'right' pour ne pas cacher les stats à gauche
                  top: 100, 
                  child: Image.asset(
                    driver.detailImage, // Utilise la nouvelle image de détail
                    height: 450, 
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            // --- STATISTIQUES DYNAMIQUES ---
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 40),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildStatItem(driver.wins, "Victoires"),
                      const SizedBox(height: 30),
                      _buildStatItem(driver.gps, "Grands Prix"),
                      const SizedBox(height: 30),
                      _buildStatItem(driver.podiums, "Podiums"),
                    ],
                  ),
                ],
              ),
            ),

            // --- BIOGRAPHIE DYNAMIQUE ---
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Biographie",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    driver.biography, // Texte de bio dynamique
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}