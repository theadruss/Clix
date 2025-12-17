import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  FirebaseClient._();

  static FirebaseAuth get auth => FirebaseAuth.instance;

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
}

// Usage:
// final user = FirebaseClient.auth.currentUser;
// final col = FirebaseClient.firestore.collection('events');
