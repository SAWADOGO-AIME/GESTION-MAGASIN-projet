import 'package:ecep/services/api_service.dart';


class ApiEndpoints {
  // URL de base de l'API
  static const String baseUrl = 'http://localhost:8000/api_accounts';

  // Endpoints pour l'inscription des utilisateurs
  static const String userRegister = '$baseUrl/users/'; // Inscription d'un utilisateur générique
  static const String studentRegister = '$baseUrl/students/'; // Inscription d'un étudiant
  static const String lecturerRegister = '$baseUrl/lecturers/'; // Inscription d'un enseignant
  static const String parentRegister = '$baseUrl/parents/'; // Inscription d'un parent


  // Endpoint pour la connexion
  static const String login = '$baseUrl/login/'; // Connexion
  static const String logout = '$baseUrl/logout/';

  // Endpoint pour valider un nom d'utilisateur
  static const String validateUsername = '$baseUrl/validate-username/'; // Validation du nom d'utilisateur

  // Endpoints pour la gestion des sessions utilisateur
  static const String userSessions = '$baseUrl/user-sessions/'; // Liste et création des sessions utilisateur
  static const String userSessionDetail = '$baseUrl/user-sessions/{id}/'; // Détail, mise à jour et suppression d'une session

  // Endpoints pour les logs des étudiants
  static const String studentLogs = '$baseUrl/student-logs/'; // Liste et création des logs des étudiants
  static const String studentLogDetail = '$baseUrl/student-logs/{id}/'; // Détail, mise à jour et suppression d'un log

  // Endpoints pour la récupération de mot de passe
  static const String forgotPassword = '$baseUrl/forgot-password/'; // Demande de réinitialisation de mot de passe
  static const String resetPassword = '$baseUrl/reset-password/'; // Réinitialisation du mot de passe


  //get user id
  //String? userId= await ApiService.getUserId();
  // Endpoints pour la gestion du profil utilisateur
  static const String profile = '$baseUrl/profile/';
  static const String changePassword = '$baseUrl/change-password/'; // Changer le mot de passe
}