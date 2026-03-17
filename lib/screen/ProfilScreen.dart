import 'dart:io';
import 'package:flutter/material.dart';
import 'package:formule_one/screen/page_connexion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:formule_one/config/session_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String _username = "";
  bool _notifications = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await SessionManager.getUser();
    final currentEmail = await SessionManager.getCurrentEmail();

    // Avatar par utilisateur : profile_image_<email>
    File? loadedImage;
    if (currentEmail != null && currentEmail.isNotEmpty) {
      final imagePath = prefs.getString('profile_image_$currentEmail');
      if (imagePath != null && imagePath.isNotEmpty) {
        loadedImage = File(imagePath);
      }
    }

    if (!mounted) return;
    setState(() {
      _imageFile = loadedImage; // null => default avatar
      _username = user['username'] ?? "Utilisateur";
      _usernameController.text = _username;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final prefs = await SharedPreferences.getInstance();
    final currentEmail = await SessionManager.getCurrentEmail();

    if (currentEmail == null || currentEmail.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez vous connecter pour changer l'avatar"),
        ),
      );
      return;
    }

    await prefs.setString('profile_image_$currentEmail', pickedFile.path);

    if (!mounted) return;
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _changeUsername() async {
    final newName = _usernameController.text.trim();
    if (newName.isEmpty) return;

    await SessionManager.updateUser({'username': newName});

    if (!mounted) return;
    setState(() {
      _username = newName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nom d'utilisateur mis à jour")),
    );
  }

  Future<void> _changePassword() async {
    final user = await SessionManager.getUser();
    final email = user['email'];

    if (email == null || email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucun email trouvé. Reconnecte-toi.")),
      );
      return;
    }

    final savedPassword = user['password'] ?? "";

    if (_oldPasswordController.text.trim() != savedPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe actuel incorrect')),
      );
      return;
    }

    final newPass = _newPasswordController.text.trim();
    if (newPass.isEmpty) return;

    // ✅ garde username/email, change uniquement password
    await SessionManager.saveUser(
      username: _username,
      email: email,
      password: newPass,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mot de passe changé avec succès')),
    );

    _oldPasswordController.clear();
    _newPasswordController.clear();
  }

  Future<void> _logout() async {
    try {
      // 🔥 Déconnecte Google (important)
      await GoogleSignIn().signOut();
    } catch (_) {}

    // 🔐 Déconnecte la session locale
    await SessionManager.logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page_connexion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE92C2F),
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                _username,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Changer le nom d’utilisateur"),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: _changeUsername,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE92C2F),
                ),
                child: const Text(
                  "Mettre à jour le nom",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Changer de mot de passe"),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Mot de passe actuel",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Nouveau mot de passe",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE92C2F),
                ),
                child: const Text(
                  "Changer le mot de passe",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.notifications_none),
                  const SizedBox(width: 10),
                  const Text("Notification"),
                  const Spacer(),
                  Switch(
                    value: _notifications,
                    onChanged: (val) => setState(() => _notifications = val),
                    activeColor: const Color(0xFFE92C2F),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              TextButton.icon(
                onPressed: _logout,
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Color(0xFFE92C2F),
                ),

                label: const Text(
                  "Déconnexion",
                  style: TextStyle(color: Color(0xFFE92C2F)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
