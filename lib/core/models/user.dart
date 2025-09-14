// ignore: unused_import
import '../helpers/constant.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String password; // plain only for login; store has later
  final String role; // 'admin | 'cashier' (Check constraint)

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        password: map['password'],
        role: map['role'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };
}
