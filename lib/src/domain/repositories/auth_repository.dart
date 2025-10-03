import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(Map<String, dynamic> userData);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserEntity> getCurrentUser();
  Future<void> forgotPassword(String email);
}