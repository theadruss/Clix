import 'package:campus_connect/src/domain/repositories/auth_repository.dart';
import 'package:campus_connect/src/data/datasources/remote/auth_api.dart';
import 'package:campus_connect/src/domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi authApi;

  AuthRepositoryImpl({required this.authApi});

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final userModel = await authApi.login(email, password);
      return UserEntity.fromModel(userModel.toJson());
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserEntity> register(Map<String, dynamic> userData) async {
    try {
      final userModel = await authApi.register(userData);
      return UserEntity.fromModel(userModel.toJson());
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await authApi.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await authApi.isLoggedIn();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final userModel = await authApi.getCurrentUser();
    return UserEntity.fromModel(userModel.toJson());
  }

  @override
  Future<void> forgotPassword(String email) async {
    await authApi.forgotPassword(email);
  }
}