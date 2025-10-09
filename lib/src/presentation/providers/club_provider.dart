import 'package:flutter/foundation.dart';
import '../../core/utils/mock_data_service.dart';

class ClubProvider with ChangeNotifier {
  List<Map<String, dynamic>> _clubs = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get clubs => _clubs;
  bool get isLoading => _isLoading;

  Future<void> loadClubs() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _clubs = MockDataService.getClubsForUser();

    _isLoading = false;
    notifyListeners();
  }

  void refreshClubs() {
    _clubs = MockDataService.getClubsForUser();
    notifyListeners();
  }
}