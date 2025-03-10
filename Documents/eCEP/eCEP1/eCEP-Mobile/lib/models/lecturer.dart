import 'package:ecep/models/user.dart';

class Lecturer {
  final int id;
  final User user;


  Lecturer({
    required this.id,
    required this.user,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) => Lecturer(
    id: json['id'],
    user: User.fromJson(json['user']),
  );

  Map<String, dynamic> toRegistrationJson() => {
  };
}