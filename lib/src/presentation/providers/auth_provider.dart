import 'package:flutter/foundation.dart';
import '../../data/models/user/user_model.dart';
import '../../core/utils/mock_data_service.dart';
import '../../core/services/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    // Try Firebase Auth first
    try {
      final cred = await FirebaseClient.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user?.uid;
      if (uid != null) {
        // fetch user document
        final doc = await FirebaseClient.firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data is Map<String, dynamic>) {
            _user = UserModel(
              id: uid,
              email: data['email'] ?? email,
              name: data['name'] ?? data['displayName'] ?? email,
              role: data['role'] ?? 'student',
              createdAt: data['createdAt'] is Timestamp
                  ? (data['createdAt'] as Timestamp).toDate()
                  : DateTime.now(),
            );
          } else {
            // User doc missing, create minimal model
            _user = UserModel(
              id: uid,
              email: email,
              name: email.split('@').first,
              role: 'student',
              createdAt: DateTime.now(),
            );
          }
        } else {
          // If user doc missing, create a minimal model
          _user = UserModel(
            id: uid,
            email: email,
            name: email.split('@').first,
            role: 'student',
            createdAt: DateTime.now(),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      // Fallback to mock behaviour
      await Future.delayed(const Duration(seconds: 1));

      if (password.length < 6) {
        _error = 'Password must be at least 6 characters';
        _isLoading = false;
        notifyListeners();
        return;
      }

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
        _user = UserModel(
          id: '2',
          email: email,
          name: 'Prof. Club Advisor',
          role: 'advisor',
          createdAt: DateTime.now(),
        );
        _initializeClubAdvisorData();
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
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password, String name, String role) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final cred = await FirebaseClient.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user?.uid;
      if (uid != null) {
        final data = {
          'email': email,
          'name': name,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await FirebaseClient.firestore.collection('users').doc(uid).set(data);

        _user = UserModel(
          id: uid,
          email: email,
          name: name,
          role: role,
          createdAt: DateTime.now(),
        );
      }
    } on FirebaseAuthException catch (e) {
      _error = e.message;
    } catch (e) {
      // Fallback to mock
      await Future.delayed(const Duration(seconds: 2));

      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      if (role == 'advisor') {
        _initializeClubAdvisorData();
      } else {
        _initializeStudentData();
      }
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