import 'package:flutter/material.dart';
import 'package:formule_one/screen/detail_screen.dart';
import '../models/driver.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(driver: driver)),
        );
      },
      child: Container(
        height: 160,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Voiture en arrière-plan
              Positioned.fill(
                child: Opacity(
                  opacity:
                      0.6, // Ajuste la valeur ici (0.0 à 1.0) pour plus ou moins de transparence
                  child: Image.asset(
                    driver.carImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Image.asset(driver.driverImage, height: 160),
              ),
              // Logo et Team (Haut Gauche)
              Positioned(
                top: 15,
                left: 15,
                child: Row(
                  children: [
                    Image.asset(driver.teamLogo, height: 18),
                    const SizedBox(width: 8),
                    Text(
                      driver.team,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              // Nom du pilote (Bas Gauche)
              Positioned(
                bottom: 15,
                left: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.firstName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      driver.lastName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
