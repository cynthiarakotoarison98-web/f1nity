import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _kLoggedIn = 'is_logged_in';
  static const _kCurrentEmail = 'current_email';

  static const _kUsername = 'username';
  static const _kEmail = 'email';
  static const _kPassword = 'password';
  static const _kProvider = 'provider'; // "email" | "google"

  static const String googleOnlyPassword = 'google_login';

  static Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, true);
    await prefs.setString(_kCurrentEmail, email.trim());
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedIn, false);
    await prefs.remove(_kCurrentEmail);
  }

  static Future<String?> getCurrentEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCurrentEmail);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedIn) ?? false;
  }

  /// Enregistrer un compte email/mdp (ou définir mdp sur un compte Google)
  static Future<void> saveUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsername, username);
    await prefs.setString(_kEmail, email.trim());
    await prefs.setString(_kPassword, password);
    await prefs.setString(_kProvider, 'email');
  }

  /// ✅ Google login: ne pas écraser un vrai mot de passe déjà existant
  static Future<void> upsertGoogleUser({
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final existingEmail = prefs.getString(_kEmail);
    final existingPassword = prefs.getString(_kPassword);

    final sameEmail = (existingEmail ?? '').trim().toLowerCase() ==
        email.trim().toLowerCase();

    // Si le même email a déjà un vrai mdp, on le garde
    if (sameEmail &&
        existingPassword != null &&
        existingPassword.isNotEmpty &&
        existingPassword != googleOnlyPassword) {
      await prefs.setString(_kUsername, username);
      await prefs.setString(_kEmail, email.trim());
      // ⚠️ garde le password existant
      await prefs.setString(_kProvider, 'google');
      return;
    }

    // Sinon -> compte Google-only
    await prefs.setString(_kUsername, username);
    await prefs.setString(_kEmail, email.trim());
    await prefs.setString(_kPassword, googleOnlyPassword);
    await prefs.setString(_kProvider, 'google');
  }

  static Future<Map<String, dynamic>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_kUsername),
      'email': prefs.getString(_kEmail),
      'password': prefs.getString(_kPassword),
      'provider': prefs.getString(_kProvider),
      'is_logged_in': prefs.getBool(_kLoggedIn) ?? false,
      'current_email': prefs.getString(_kCurrentEmail),
    };
  }

  static Future<void> updateUser(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data.containsKey('username')) {
      await prefs.setString(_kUsername, (data['username'] ?? '').toString());
    }
  }

  static Future<bool> isGoogleOnlyAccount() async {
    final user = await getUser();
    final pwd = (user['password'] ?? '').toString();
    return pwd == googleOnlyPassword;
  }
}