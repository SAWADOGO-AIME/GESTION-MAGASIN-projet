class User {
  final int? id; // ID de l'utilisateur (optionnel, car il est généré par Django)
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? password; // Optionnel, utilisé uniquement pour l'inscription
  final String? gender;
  final String? phone;
  final String? address;
  final bool isLecturer;
  final bool isStudent;
  final String? profilePictureUrl; // Optionnel

  User({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password, // Optionnel
    this.gender,
    this.phone,
    this.address,
    required this.isLecturer,
    required this.isStudent,
    this.profilePictureUrl,
  });

  // Factory pour créer un User à partir d'un JSON (utile pour les réponses de l'API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      isLecturer: json['is_lecturer'] ?? false,
      isStudent: json['is_student'] ?? false,
      profilePictureUrl: json['profile_picture'],
    );
  }

  // Méthode pour convertir un User en JSON (utile pour l'inscription)
  Map<String, dynamic> toRegistrationJson() {
    return {
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password, // Mot de passe requis pour l'inscription
      'gender': gender,
      'phone': phone,
      'address': address,
      'is_lecturer': isLecturer,
      'is_student': isStudent,
    };
  }

  // Méthode pour convertir un User en JSON (général, sans mot de passe)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // Inclure l'ID uniquement s'il existe
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'gender': gender,
      'phone': phone,
      'address': address,
      'is_lecturer': isLecturer,
      'is_student': isStudent,
      'profile_picture_url': profilePictureUrl,
    };
  }
}