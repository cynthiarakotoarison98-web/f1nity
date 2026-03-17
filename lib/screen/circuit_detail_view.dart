import 'package:flutter/material.dart';
import 'package:formule_one/models/track.dart';

class CircuitDetailView extends StatelessWidget {
  final Track track;

  const CircuitDetailView({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101319),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [

              Image.asset(
                track.trackImagePath,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              Text(
                track.location.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 6,
                ),
              ),

              Text(
                track.country.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  letterSpacing: 3,
                ),
              ),

              const Divider(color: Colors.white10, height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _info("LONGUEUR", track.length),
                  _info("TOURS", track.laps.toString()),
                  _info("DISTANCE", track.raceDistance),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _info("VIRAGES", track.corners.toString()),
                  _info("DRS", track.drsZones.toString()),
                  _info("TOP SPEED", "${track.topSpeed} km/h"),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                track.circuitType.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white38,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "RECORD",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track.lapRecord,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${track.lapRecordHolder} (${track.lapRecordYear})",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),        
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Le ${track.circuitName} est célèbre pour ses ${track.corners} virages "
                  "et sa longueur de ${track.length}. Les pilotes doivent maîtriser "
                  "la vitesse et la précision pour réaliser un tour optimal.",
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}