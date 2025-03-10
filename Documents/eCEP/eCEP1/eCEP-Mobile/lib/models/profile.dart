class User {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? ville;
  final String? numeroDeTelephone;
  final bool isStudent;

  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    this.ville,
    this.numeroDeTelephone,
    required this.isStudent,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      ville: json['ville'],
      numeroDeTelephone: json['numero_de_telephone'],
      isStudent: json['is_student'] ?? false,
    );
  }
}