import 'package:flutter/foundation.dart';
import '../../core/utils/mock_data_service.dart';
import '../../data/models/event/event_proposal_model.dart';
import '../../core/services/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;
  List<EventProposalModel> _pendingProposals = [];

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;
  List<EventProposalModel> get pendingProposals => _pendingProposals;

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

  /// Load pending proposals for a given club id (mocked)
  Future<void> loadPendingProposalsForClub(String clubId) async {
    _isLoading = true;
    notifyListeners();

    // Try Firestore first; fall back to mock data if something goes wrong
    try {
      final query = await FirebaseClient.firestore
          .collection('proposals')
          .where('clubId', isEqualTo: clubId)
          .where('status', isEqualTo: 'pending_review')
          .get();

      _pendingProposals = query.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data() as Map);
        data['id'] = doc.id;
        return EventProposalModel.fromMap(data);
      }).toList();
    } catch (e) {
      // Firestore not configured or offline — use mock
      await Future.delayed(const Duration(milliseconds: 500));
      final raw = MockDataService.getPendingApprovalsForAdvisor(clubId);
      _pendingProposals = raw.map((m) => EventProposalModel.fromMap(m)).toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  List<EventProposalModel> getPendingProposalsForClub(String clubId) {
    return _pendingProposals.where((p) => p.clubId == clubId && p.status == 'pending_review').toList();
  }

  void approveProposal(String id) {
    final idx = _pendingProposals.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _pendingProposals[idx].status = 'advisor_approved';
      notifyListeners();

      // Try to persist status to Firestore if a document exists
      try {
        FirebaseClient.firestore.collection('proposals').doc(id).update({
          'status': 'advisor_approved',
          'approvedAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {}
    }
  }

  void rejectProposal(String id, String reason) {
    final idx = _pendingProposals.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _pendingProposals[idx].status = 'rejected';
      notifyListeners();

      try {
        FirebaseClient.firestore.collection('proposals').doc(id).update({
          'status': 'rejected',
          'rejectionReason': reason,
          'rejectedAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {}
    }
  }
}