import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class StorageService {
  static const String _userKey = 'user_profile';
  static const String _currentUserEmailKey = 'current_user_email';

  // In a real app we'd hash passwords or use secure storage.
  // This is a simple mock auth + storage mechanism.
  static const String _authPrefix = 'auth_';

  static Future<bool> createAccount(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('$_authPrefix$email')) {
      return false; // Account already exists
    }
    await prefs.setString('$_authPrefix$email', password);
    await login(email, password);
    return true;
  }

  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString('$_authPrefix$email');
    if (storedPassword == password) {
      await prefs.setString(_currentUserEmailKey, email);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserEmailKey);
  }

  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserEmailKey);
  }

  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    // Save under the user's specific key
    await prefs.setString('${_userKey}_${profile.email}', jsonString);
  }

  static Future<UserProfile?> getUserProfile(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${_userKey}_$email');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    }
    return null;
  }
}
