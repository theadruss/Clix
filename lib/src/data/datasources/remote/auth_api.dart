import '../../models/user/user_model.dart';

class AuthApi {
  // Simulate API calls with delay
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Mock validation
    if (email == 'admin@campus.edu' && password == 'password') {
      return UserModel(
        id: '1',
        email: email,
        name: 'Admin User',
        role: 'admin',
        collegeId: 'CAMPUS001',
        createdAt: DateTime.now(),
        isEmailVerified: true,
      );
    } else if (email == 'student@campus.edu' && password == 'password') {
      return UserModel(
        id: '2',
        email: email,
        name: 'Student User',
        role: 'student',
        collegeId: 'STU001',
        createdAt: DateTime.now(),
        isEmailVerified: true,
      );
    } else if (email == 'club@campus.edu' && password == 'password') {
      return UserModel(
        id: '3',
        email: email,
        name: 'Club Coordinator',
        role: 'club_coordinator',
        collegeId: 'CLUB001',
        createdAt: DateTime.now(),
        isEmailVerified: true,
      );
    } else if (email == 'advisor@campus.edu' && password == 'password') {
      return UserModel(
        id: '4',
        email: email,
        name: 'Dr. Club Advisor',
        role: 'advisor',
        collegeId: 'FACULTY001',
        createdAt: DateTime.now(),
        isEmailVerified: true,
      );
    } else if (email == 'external@org.com' && password == 'password') {
      return UserModel(
        id: '5',
        email: email,
        name: 'External Organization',
        role: 'external',
        phoneNumber: '+1-800-123-4567',
        createdAt: DateTime.now(),
        isEmailVerified: true,
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<UserModel> register(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(seconds: 2));
    
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: userData['email'],
      name: userData['name'],
      role: 'student', // Default role
      collegeId: userData['collegeId'],
      createdAt: DateTime.now(),
      isEmailVerified: false,
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> isLoggedIn() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return false; // Change based on actual auth state
  }

  Future<UserModel> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception('No user logged in');
  }

  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate password reset email sent
  }
}