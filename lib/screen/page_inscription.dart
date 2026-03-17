import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formule_one/config/session_manager.dart';
import 'package:formule_one/screen/formula_one_app.pages.dart';
import 'package:google_sign_in/google_sign_in.dart';

class page_inscription extends StatelessWidget {
  page_inscription({super.key});

  static const Color _primaryRed = Color(0xFFE53935);
  static const Color _fieldFill = Color(0xFFF2F2F2);
  static const Color _hint = Color(0xFF9E9E9E);
  static const Color _lightText = Color(0xFFBDBDBD);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 28),

              SizedBox(
                height: 300,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Image.asset(
                        'assets/images/f1_line.jpg',
                        width: width * 0.95,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      child: Text(
                        'FORMULA 1',
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2,
                          color: _lightText.withOpacity(0.65),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              _AuthField(
                controller: _usernameController,
                hint: "Nom d'utilisateur",
                prefix: const Icon(Icons.person_outline, color: Colors.black54),
                fill: _fieldFill,
                hintColor: _hint,
              ),
              const SizedBox(height: 14),

              _AuthField(
                controller: _emailController,
                hint: 'Email',
                prefix: const Icon(Icons.email_outlined, color: Colors.black54),
                fill: _fieldFill,
                hintColor: _hint,
              ),
              const SizedBox(height: 14),

              _AuthField(
                controller: _passwordController,
                hint: 'Mot de passe',
                prefix: const Icon(
                  Icons.vpn_key_outlined,
                  color: Colors.black54,
                ),
                fill: _fieldFill,
                hintColor: _hint,
                obscureText: true,
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    final username = _usernameController.text.trim();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (username.isEmpty || email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Veuillez remplir tous les champs"),
                        ),
                      );
                      return;
                    }

                    if (!_isValidEmail(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email invalide")),
                      );
                      return;
                    }

                    if (password.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mot de passe trop court (min 6)"),
                        ),
                      );
                      return;
                    }

                    // Optionnel : éviter d'écraser un compte existant (ton app stocke 1 seul compte)
                    final existing = await SessionManager.getUser();
                    if (existing['email'] != null &&
                        existing['email'] == email) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Ce compte existe déjà, connecte-toi."),
                        ),
                      );
                      return;
                    }

                    // ✅ Sauvegarde utilisateur
                    await SessionManager.saveUser(
                      username: username,
                      email: email,
                      password: password,
                    );

                    // ✅ IMPORTANT : définir current_email + is_logged_in
                    await SessionManager.login(email);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Compte créé avec succès")),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const FormulaOneApp()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  const Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'ou continuer avec',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  const Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 14),

              _SocialButton(
                icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                label: 'Continuer avec Google',
                onPressed: () async {
                  try {
                    final googleSignIn = GoogleSignIn();

                    try {
                      await googleSignIn.disconnect(); // révoque l'accès
                    } catch (_) {}
                    await googleSignIn.signOut(); // nettoie la session locale

                    final account = await googleSignIn.signIn();
                    if (account == null) return;

                    await SessionManager.saveUser(
                      username: account.displayName ?? 'Utilisateur Google',
                      email: account.email,
                      password: 'google_login',
                    );

                    await SessionManager.login(account.email);

                    if (!context.mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const FormulaOneApp()),
                      (route) => false,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur de connexion Google: $e")),
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              _SocialButton(
                icon: const FaIcon(FontAwesomeIcons.apple, size: 20),
                label: 'Continuer avec Apple',
                onPressed: () {},
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String hint;
  final Widget prefix;
  final Color fill;
  final Color hintColor;
  final bool obscureText;
  final TextEditingController? controller;

  const _AuthField({
    this.controller,
    required this.hint,
    required this.prefix,
    required this.fill,
    required this.hintColor,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: prefix,
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.black.withOpacity(0.35)),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
