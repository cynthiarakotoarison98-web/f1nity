import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formule_one/screen/ProfilScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:formule_one/config/session_manager.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = await SessionManager.getCurrentEmail();

    // ✅ Si pas connecté => avatar default
    if (currentEmail == null || currentEmail.isEmpty) {
      if (!mounted) return;
      setState(() => _imageFile = null);
      return;
    }

    // ✅ Charger l'image liée à cet utilisateur
    final path = prefs.getString('profile_image_$currentEmail');

    if (!mounted) return;
    setState(() {
      _imageFile = (path != null && path.isNotEmpty) ? File(path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFE92C2F),
      elevation: 0,
      centerTitle: false,
      title: Text(
        widget.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        IconButton(
          icon: CircleAvatar(
            radius: 16,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!)
                : const AssetImage("assets/images/default_avatar.png")
                    as ImageProvider,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ).then((_) {
              // ✅ Recharge l'image après retour
              _loadImage();
            });
          },
        ),
      ],
    );
  }
}