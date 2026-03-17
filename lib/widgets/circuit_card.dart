import 'package:flutter/material.dart';
import '../models/race.dart';

class CircuitCard extends StatelessWidget {
  final Race race;

  const CircuitCard({super.key, required this.race});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 7, 5, 5), // Ton code hexa 101319
      ),
      child: Column(
        children: [
          // Boussole Nord en haut à droite
          const Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                Icon(Icons.navigation_outlined, color: Colors.white, size: 30),
                Text("N", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Image du Tracé
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Image.asset(
              race.trackImagePath,
              height: 350,
              fit: BoxFit.contain,
               // Assure que le tracé est blanc
            ),
          ),
          
          // Nom du Circuit (Style Poster)
          Text(
            race.location.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w400,
              letterSpacing: 8,
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Ligne de séparation fine et pays
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 1, width: 30, color: Colors.white54),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  race.country.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 4),
                ),
              ),
              Container(height: 1, width: 30, color: Colors.white54),
            ],
          ),
          
          const SizedBox(height: 15),

          // Date et Heure
          Text(
            "${race.date}  |  ${race.time}",
            style: const TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 2),
          ),
          
          const SizedBox(height: 15),
          
          // Coordonnées Géographiques
          Text(
            race.coordinates,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}