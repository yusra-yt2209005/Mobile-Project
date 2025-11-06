import 'package:floor/floor.dart';
import 'package:kalimati/features/dashboard/domain/entities/user.dart';

@dao
abstract class UserDao {
  // Get user by credentials (for login)
  //@Query('SELECT * FROM users WHERE email = :email AND password = :password')
  //Future<User?> getUserByCredentials(String email, String password);

  // Get user by ID
  //@Query('SELECT * FROM users WHERE id = :userId')
  //Future<User?> getUserById(String userId);

  // Get user by email
  //@Query('SELECT * FROM users WHERE email = :email')
  //Future<User?> getUserByEmail(String email);

  // Get all teachers
  @Query('SELECT * FROM users WHERE role = "Teacher"')
  Future<List<User>> getAllTeachers();

  // Get all students
  @Query('SELECT * FROM users WHERE role = "Student"')
  Future<List<User>> getAllStudents();

  // Insert user
  //@insert
  Future<void> insertUser(User user);

  // Update user
  @update
  Future<void> updateUser(User user);

  // Delete user
  @delete
  Future<void> deleteUser(User user);
}
