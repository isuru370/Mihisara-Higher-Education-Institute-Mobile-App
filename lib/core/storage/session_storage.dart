import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/user_model.dart';

class SessionStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _emailKey = 'remember_email';

  /// Save token + user + email
  static Future<void> saveAuth({
    required String token,
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));

    // Save email for next login
    await prefs.setString(_emailKey, user.email);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get logged user
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_userKey);
    if (raw == null) return null;

    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Get remembered email
  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  /// Remove only login session
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_emailKey);
  }

  /// Remove remembered email manually (optional)
  static Future<void> clearSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }
}
