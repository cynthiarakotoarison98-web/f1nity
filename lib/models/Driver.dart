import 'package:flutter/material.dart';

class Driver {
  final String firstName;
  final String lastName;
  final String team;
  final String carImage;    // Image de fond de la carte
  final String driverImage; // Portrait pour la liste
  final String detailImage; // Grande image pour le détail
  final String teamLogo;
  final String flag;        // Emoji ou chemin d'image
  final String biography;   // Texte descriptif
  final String wins;        // Nombre de victoires
  final String gps;         // Nombre de GP
  final String podiums;     // Nombre de podiums
  final Color accentColor;

  Driver({
    required this.firstName,
    required this.lastName,
    required this.team,
    required this.carImage,
    required this.driverImage,
    required this.detailImage,
    required this.teamLogo,
    required this.flag,
    required this.biography,
    required this.wins,
    required this.gps,
    required this.podiums,
    required this.accentColor,
  });
}