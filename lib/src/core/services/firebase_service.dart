import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth getters
  static FirebaseAuth get auth => _auth;
  static FirebaseFirestore get firestore => _firestore;

  // User stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  static User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  // User Collection Reference
  static CollectionReference get usersCollection => _firestore.collection('users');

  // Get user document
  static Future<DocumentSnapshot> getUserDocument(String userId) {
    return usersCollection.doc(userId).get();
  }

  // Create or update user document
  static Future<void> createOrUpdateUser(UserModel userModel) async {
    await usersCollection.doc(userModel.id).set(
      userModel.toJson(),
      SetOptions(merge: true),
    );
  }

  // Get user by ID
  static Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await getUserDocument(userId);
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Get current user model
  static Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;
    return getUserById(user.uid);
  }
}

