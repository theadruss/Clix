import 'package:flutter/foundation.dart';
import '../../data/models/user/user_model.dart';
import '../../core/utils/mock_data_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (password.length < 6) {
      _error = 'Password must be at least 6 characters';
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Mock login - replace with actual API call
    if (email.contains('admin')) {
      _user = UserModel(
        id: '1',
        email: email,
        name: 'Dr. Principal Admin',
        role: 'admin',
        createdAt: DateTime.now(),
      );
      _initializeAdminData();
    } else if (email.contains('advisor') || email.contains('club')) {
      // FIX: Added 'club' email check for club login
      _user = UserModel(
        id: '2',
        email: email,
        name: 'Prof. Club Advisor',
        role: 'advisor', // This ensures ClubDashboard loads
        createdAt: DateTime.now(),
      );
      _initializeClubAdvisorData(); // Call the initialization method
    } else {
      _user = UserModel(
        id: '5',
        email: email,
        name: 'Student User',
        role: 'student',
        createdAt: DateTime.now(),
      );
      _initializeStudentData();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password, String name, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.now(),
    );

    // Initialize data based on role
    if (role == 'advisor') {
      _initializeClubAdvisorData();
    } else {
      _initializeStudentData();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _initializeClubAdvisorData() {
    // Advisor manages Computer Society and Cultural Committee
    MockDataService.clubs[0]['isMember'] = true;
    MockDataService.clubs[0]['userRole'] = 'advisor';
    
    MockDataService.clubs[1]['isMember'] = true;
    MockDataService.clubs[1]['userRole'] = 'advisor';
  }

  void _initializeStudentData() {
    // Regular student - member of Computer Society
    MockDataService.clubs[0]['isMember'] = true;
    MockDataService.clubs[0]['userRole'] = 'member';
    MockDataService.events[1]['isRegistered'] = true;
  }

  void _initializeAdminData() {
    // Admin can see all data - no specific initialization needed
  }

  Future<void> logout() async {
    _user = null;
    _error = null;
    
    // Reset mock data to initial state
    _resetMockData();
    
    notifyListeners();
  }

  void _resetMockData() {
    // Reset clubs to initial state
    MockDataService.clubs[0]['isMember'] = true;
    MockDataService.clubs[0]['userRole'] = 'member';
    
    MockDataService.clubs[1]['isMember'] = false;
    MockDataService.clubs[1]['userRole'] = null;
    
    MockDataService.clubs[2]['isMember'] = true;
    MockDataService.clubs[2]['userRole'] = 'coordinator';
    
    // Reset events to initial state
    MockDataService.events[0]['isRegistered'] = false;
    MockDataService.events[1]['isRegistered'] = false;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}