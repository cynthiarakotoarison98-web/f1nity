import 'package:flutter/material.dart';
import '../data/calendar_data.dart';
import '../widgets/circuit_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder( // Utilisation de PageView pour défiler circuit par circuit
        scrollDirection: Axis.vertical,
        itemCount: calendar2026.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: CircuitCard(race: calendar2026[index]),
          );
        },
      ),
    );
  }
}