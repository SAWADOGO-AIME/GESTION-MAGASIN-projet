import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  static Future<void> saveAuthData(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setInt('user_id', userId);
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }

  //get auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}