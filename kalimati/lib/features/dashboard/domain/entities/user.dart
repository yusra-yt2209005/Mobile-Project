import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey()
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String photoUrl;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.photoUrl,
    required this.role,
  });

  String get fullName => '$firstName $lastName';

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['email'] as String, // Use email as ID
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      photoUrl: json['photoUrl'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'photoURL' : photoUrl,
      'role': role,
    };
  }

  // User copyWith({
  //   String? id,
  //   String? firstName,
  //   String? lastName,
  //   String? email,
  //   String? password,
  //   String? photoURL,
  //   String? role,
  // }) {
  //   return User(
  //     id: id ?? this.id,
  //     firstName: firstName ?? this.firstName,
  //     lastName: lastName ?? this.lastName,
  //     email: email ?? this.email,
  //     password: password ?? this.password,
  //     photoUrl: photoUrl ?? this.photoUrl,
  //     role: role ?? this.role,
  //   );
  // }
}