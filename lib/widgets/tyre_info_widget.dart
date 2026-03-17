import 'package:flutter/material.dart';

class TyreInfoWidget extends StatelessWidget {
  final String compound;
  final String label;
  final Color color;
  final String imageName; // Le nom du fichier ex: "hard.png"

  const TyreInfoWidget({
    super.key, 
    required this.compound, 
    required this.label, 
    required this.color,
    required this.imageName,
  });

 // Dans TyreInfoWidget
@override
Widget build(BuildContext context) {
  return Expanded( // <--- Ajoute Expanded ici pour que chaque pneu prenne 1/3 de la place
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(compound, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 5),
        Image.asset(
          'assets/images/pneu/$imageName',
          width: 60, // Réduis un peu la taille pour être sûr que ça tienne
          height: 60,
          fit: BoxFit.contain,
          // Ajoute ce bloc pour éviter que l'app crash si l'image manque
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.help_outline, color: Colors.white24),
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    ),
  );
  }
}