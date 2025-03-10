import 'dart:async';
import 'dart:convert';
import 'package:ecep/models/student.dart';
import 'package:ecep/models/user.dart';
import 'package:ecep/services/api_auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
class ApiService {

  // Méthode pour s'inscrire
  static Future<bool> registerLecturer(User user) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/lecturers/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toRegistrationJson()),
      );

      if (response.statusCode == 201) {
        return true; // Création réussie
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Échec de la création');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  //register student
  static Future<bool> registerStudent(User user) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/students/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toRegistrationJson()),
      );

      if (response.statusCode == 201) {
        return true; // Création réussie
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Échec de la création');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

///
  // Méthode pour se connecter
  // Méthode pour se connecter
// Dans ApiService
  static Future<String?> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userId = getUserIdToken(token);

        if (userId != null) {
          await saveAuthData(
              token,
              int.parse(userId),
              data['is_student'] ?? false
          );
        }

        return token;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Échec de la connexion');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    } on TimeoutException catch (e) {
      throw Exception('La connexion a expiré');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  static Future<void> saveUserRole(bool isStudent, bool isLecturer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_student', isStudent);
    await prefs.setBool('is_lecturer', isLecturer);
  }

// Sauvegarder les données après login
  static Future<void> saveAuthData(String token, int userId, bool isStudent) async {
    final prefs = await SharedPreferences.getInstance();

    // Sauvegarde vérifiée
    await prefs.setString('auth_token', token);
    print('Token sauvegardé: ${prefs.getString('auth_token')?.substring(0, 15)}...'); // Debug

    await prefs.setInt('user_id', userId);
    print('ID sauvegardé: ${prefs.getInt('user_id')}'); // Debug

    await prefs.setBool('is_student', isStudent);
  }
  ///

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    // Vérification combinée
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');

    if (token == null || userId == null) return false;

    // Vérification supplémentaire du token
    try {
      final isValid = !JwtDecoder.isExpired(token);
      print('Token valide: $isValid');
      return isValid;
    } catch (e) {
      print('Erreur vérification JWT: $e');
      return false;
    }
  }

  static Future<int?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }
  ///
  static Future <String?>getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }


  static bool isValidJWT(String token) {
    final parts = token.split('.');
    return parts.length == 3; // Un JWT valide a toujours 3 parties
  }

  static String? getUserIdToken(String token) {
    try {
      if (!isValidJWT(token)) {
        print('JWT invalide');
        return null;
      }

      final jwt = JwtDecoder.decode(token);

      // Vérification des clés possibles
      final userId = jwt['user_id'] ?? jwt['sub'] ?? jwt['id'];

      if (userId == null) {
        print('Structure JWT incorrecte: ${jwt.toString()}');
        return null;
      }

      return userId.toString();
    } catch (e) {
      print('Erreur décodage JWT: ${e.toString()}');
      return null;
    }
  }
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Récupération depuis le stockage local
    final storedId = prefs.getInt('user_id');
    if (storedId != null) {
      print('ID trouvé dans SharedPreferences: $storedId');
      return storedId.toString();
    }

    // 2. Fallback sur le JWT
    final token = prefs.getString('auth_token');
    if (token != null) {
      print('Tentative d\'extraction depuis JWT...');
      final userId = getUserIdToken(token);
      if (userId != null) {
        await prefs.setInt('user_id', int.parse(userId)); // Mise en cache
        return userId;
      }
    }

    return null;
  }

  //static String baseUrl= 'http://192.168.11.105:8000/api_accounts/profile/'; // Profil utilisateur

  static Future<User?> getUserData(String userId) async {
    try {
      final token = await getToken(); // Ajout de await
      if (token == null) throw Exception('Token non disponible');

      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/profile/$userId/'), // URL corrigée
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        await _clearAuthData();
        throw Exception('Session expirée');
      }
      return null;
    } catch (e) {
      print('Erreur API: $e');
      throw Exception('Impossible de charger le profil');
    }
  }






  static Future<bool> logoutUser(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/logout/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token', // Ajoutez le token dans l'en-tête
        },
      );

      if (response.statusCode == 200) {
        return true; // Déconnexion réussie
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Échec de la déconnexion');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  // Sauvegarder le token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }


// Réinitialisation du mot de passe
  static Future<bool> resetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/forgot-password/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Échec de la réinitialisation');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }
  // Récupérer les informations de l'utilisateur
  static Future<User> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('${ApiEndpoints.baseUrl}/users/$userId/'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }


  //get auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

 //get
////// PROFILE GESTION //////

// Méthode pour récupérer le profil utilisateur
  /*static Future<Map<String, dynamic>> fetchUserProfile(int userId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Token non disponible');

      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}/profile/$userId/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur API: $e');
    }
  }*/
/*
// Méthode pour mettre à jour le profil utilisateur
  static Future<void> updateUserProfile(int userId, Map<String, dynamic> updatedData) async {
    try {
      final token = await _getAuthToken();
      if (token == null) throw Exception('Utilisateur non authentifié');

      final response = await http.put(
        Uri.parse(ApiEndpoints.userProfile(userId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Données invalides');
      } else if (response.statusCode == 401) {
        await _clearAuthData();
        throw Exception('Session expirée');
      } else {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      throw Exception('Erreur réseau: ${e.message}');
    } on FormatException {
      throw Exception('Format de données incorrect');
    } catch (e) {
      throw Exception('Erreur de mise à jour: ${e.toString()}');
    }
  }
*/

// Méthode privée pour nettoyer l'authentification
  static Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
  }


}