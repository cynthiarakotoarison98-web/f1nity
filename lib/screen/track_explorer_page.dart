import 'package:flutter/material.dart';
import 'package:formule_one/data/circuit_details.dart';
import 'package:formule_one/screen/circuit_detail_view.dart';

class TrackExplorerPage extends StatelessWidget {
  const TrackExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("NOMBRE DE CIRCUITS DETECTES : ${allTracks.length}");

    return Scaffold(
      backgroundColor: const Color(0xFF101319),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: allTracks.length,
        itemBuilder: (context, index) {
          // Chaque page est indépendante, tu peux scroll le contenu interne si nécessaire
         
            return CircuitDetailView(track: allTracks[index]);
        },
      ),
    );
  }
}