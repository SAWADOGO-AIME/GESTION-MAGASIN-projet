import 'package:ecep/models/user.dart';
import 'package:ecep/models/student.dart';

class Parent {
  final User user;
  final Student student;
  final String relationship;

  Parent({

    required this.user,
    required this.student,
    required this.relationship,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
    user: User.fromJson(json['user']),
    student: Student.fromJson(json['student']),
    relationship: json['relationship'],
  );

  Map<String, dynamic> toRegistrationJson() => {
    'relationship': relationship,
  };
}