import 'package:flutter/foundation.dart';
import '../../core/utils/mock_data_service.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _events = MockDataService.getEventsForUser();

    _isLoading = false;
    notifyListeners();
  }

  void refreshEvents() {
    _events = MockDataService.getEventsForUser();
    notifyListeners();
  }
}