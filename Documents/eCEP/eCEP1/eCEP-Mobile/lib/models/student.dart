import 'package:ecep/models/user.dart';

class Student {
  final User user;
  final int programId; // Program ID doit toujours être 1

  Student({
    required this.user,
    required this.programId,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      user: User.fromJson(json['user']),
      programId: json['program_id'],
    );
  }

  Map<String, dynamic> toRegistrationJson() {
    return {
      'user': user.toRegistrationJson(),
      'program_id': programId, // Toujours 1
    };
  }
}