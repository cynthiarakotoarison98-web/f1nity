import 'package:flutter/material.dart';
import 'package:formule_one/screen/HomePage.pages.dart';
import 'package:formule_one/screen/calendar_screen.dart';
import 'package:formule_one/screen/home_screen.dart';
import 'package:formule_one/screen/race_intelligent.dart';
import 'package:formule_one/screen/track_explorer_page.dart';
import 'package:formule_one/widgets/custom_bottom_bar.dart';

class FormulaOneApp extends StatefulWidget {
  const FormulaOneApp({super.key});

  @override
  State<FormulaOneApp> createState() => _FormulaOneAppState();
}

class _FormulaOneAppState extends State<FormulaOneApp> {
  int _currentIndex = 0;

  // Liste des titres pour l'AppBar
  final List<String> _titles = ["Accueil", "Les Pilotes", "Calendrier", "Les Circuits", "En Direct"];
  
  final List<Widget> _pages = [
    
    Center(child: HomePage(),),
    const Center(child: HomeScreen()),
    const Center(child: CalendarScreen()),
    const TrackExplorerPage(),
    const RaceIntelligenceMelbournePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      extendBody: true,
      // On appelle l'AppBar réutilisable ici
      appBar: CustomAppBar(title: _titles[_currentIndex]), 
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.sports_motorsports, 1),
            _buildNavItem(Icons.date_range, 2),
            _buildNavItem(Icons.sports_score, 3),
            _buildNavItem(Icons.adjust, 4),
          ],
        ),
      ),
    );
  }

  // TON CODE DE NAVIGATION (Non changé)
  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: SizedBox(
        width: 60,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              bottom: isSelected ? 45 : 20,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFE92C2F) : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [BoxShadow(color: Colors.red.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[700],
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}