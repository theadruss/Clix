import 'package:flutter/foundation.dart';
import '../../core/utils/mock_data_service.dart';
import '../../core/services/firebase_client.dart';

class ClubProvider with ChangeNotifier {
  List<Map<String, dynamic>> _clubs = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get clubs => _clubs;
  bool get isLoading => _isLoading;

  Future<void> loadClubs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseClient.firestore.collection('clubs').get();
      _clubs = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data() as Map);
        data['id'] = doc.id;
        return data;
      }).toList();
      print('✅ Loaded ${_clubs.length} clubs from Firestore');
    } catch (e) {
      print('❌ Error loading clubs from Firestore: $e');
      print('📦 Falling back to mock data');
      await Future.delayed(const Duration(seconds: 1));
      _clubs = MockDataService.getClubsForUser();
    }

    _isLoading = false;
    notifyListeners();
  }

  void refreshClubs() {
    loadClubs();
  }
}