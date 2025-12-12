import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';

class EventApprovalPage extends StatefulWidget {
  const EventApprovalPage({super.key});

  @override
  State<EventApprovalPage> createState() => _EventApprovalPageState();
}

class _EventApprovalPageState extends State<EventApprovalPage> {
  String _filter = 'all'; // all, pending, approved, rejected

  @override
  Widget build(BuildContext context) {
    final approvals = _getFilteredApprovals();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Event Approvals', style: AppTextStyles.headlineSmall),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterTab(label: 'All', filter: 'all', currentFilter: _filter, onTap: () => setState(() => _filter = 'all')),
                const SizedBox(width: 8),
                _FilterTab(label: 'Pending', filter: 'pending', currentFilter: _filter, onTap: () => setState(() => _filter = 'pending')),
                const SizedBox(width: 8),
                _FilterTab(label: 'Approved', filter: 'approved', currentFilter: _filter, onTap: () => setState(() => _filter = 'approved')),
                const SizedBox(width: 8),
                _FilterTab(label: 'Rejected', filter: 'rejected', currentFilter: _filter, onTap: () => setState(() => _filter = 'rejected')),
              ],
            ),
          ),
          
          // Approvals List
          Expanded(
            child: approvals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 64, color: AppColors.mediumGray),
                        const SizedBox(height: 16),
                        Text(
                          'No approvals found',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: approvals.length,
                    itemBuilder: (context, index) {
                      return _ApprovalCard(
                        approval: approvals[index],
                        onApprove: () => _handleApproval(approvals[index], true),
                        onReject: () => _handleApproval(approvals[index], false),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredApprovals() {
    if (_filter == 'all') {
      return MockDataService.pendingApprovals;
    }
    return MockDataService.pendingApprovals.where((approval) {
      final status = approval['status'] ?? 'pending';
      return status.contains(_filter);
    }).toList();
  }

  Future<void> _handleApproval(Map<String, dynamic> approval, bool isApproved) async {
    // Check for venue conflicts if approving
    if (isApproved) {
      final hasConflict = await _checkVenueConflict(approval);
      if (hasConflict) {
        if (mounted) {
          _showConflictDialog(approval);
        }
        return;
      }
    }

    // Update approval status
    setState(() {
      approval['status'] = isApproved ? 'approved' : 'rejected';
      approval['reviewedBy'] = 'Admin';
      approval['reviewedDate'] = DateTime.now().toIso8601String();
    });

    // If approved, add to events list
    if (isApproved) {
      final event = {
        'id': approval['id'],
        'title': approval['title'],
        'club': approval['club'],
        'date': _formatDate(approval['date']),
        'time': '${approval['startTime']} - ${approval['endTime']}',
        'venue': approval['venue'],
        'description': approval['description'] ?? '',
        'interestedCount': 0,
        'imageUrl': 'https://picsum.photos/400/200?random=${approval['id']}',
        'status': 'approved',
        'category': approval['category'] ?? 'Other',
        'isRegistered': false,
        'needsVolunteers': approval['needsVolunteers'] ?? false,
        'volunteerRoles': approval['volunteerRoles'] ?? [],
      };
      MockDataService.events.insert(0, event);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isApproved ? 'Event approved successfully!' : 'Event rejected'),
          backgroundColor: isApproved ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<bool> _checkVenueConflict(Map<String, dynamic> approval) async {
    // Simulate venue conflict check
    try {
      final eventVenue = approval['venue'] as String?;
      if (eventVenue == null || eventVenue.isEmpty) return false;
      
      final eventDate = DateTime.parse(approval['date'] ?? '');
    
    // Check if any existing approved event has same venue and overlapping time
    final conflictingEvents = MockDataService.events.where((event) {
      if (event['status'] != 'approved') return false;
      if (event['venue'] != eventVenue) return false;
      
      // Simple date check - in real app, would check time overlap
      try {
        final existingDate = _parseDate(event['date']);
        return existingDate.year == eventDate.year &&
               existingDate.month == eventDate.month &&
               existingDate.day == eventDate.day;
      } catch (e) {
        return false;
      }
    }).toList();

      return conflictingEvents.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  DateTime _parseDate(dynamic date) {
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        // Try parsing formatted date
        final parts = date.split('/');
        if (parts.length == 3) {
          return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        }
      }
    }
    return DateTime.now();
  }

  String _formatDate(dynamic date) {
    if (date is String) {
      try {
        final dt = DateTime.parse(date);
        return '${dt.day}/${dt.month}/${dt.year}';
      } catch (e) {
        return date.toString();
      }
    }
    return date.toString();
  }

  void _showConflictDialog(Map<String, dynamic> approval) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text('Venue Conflict Detected', style: AppTextStyles.headlineSmall),
        content: Text(
          'Another event is already scheduled at ${approval['venue']} on the same date. Please choose a different venue or date.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.accentYellow)),
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final String filter;
  final String currentFilter;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.filter,
    required this.currentFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = currentFilter == filter;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentYellow : AppColors.darkGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.darkGray : AppColors.mediumGray,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final Map<String, dynamic> approval;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApprovalCard({
    required this.approval,
    required this.onApprove,
    required this.onReject,
  });

  String _formatDate(dynamic date) {
    if (date is String) {
      try {
        final dt = DateTime.parse(date);
        return '${dt.day}/${dt.month}/${dt.year}';
      } catch (e) {
        return date.toString();
      }
    }
    return date.toString();
  }

  @override
  Widget build(BuildContext context) {
    final status = approval['status'] ?? 'pending';
    final isPending = status == 'pending' || status == 'pending_coordinator' || status == 'pending_advisor';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPending ? Colors.orange.withAlpha((0.3 * 255).toInt()) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  approval['title'] ?? 'Untitled Event',
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
              ),
              _StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),
          
          _InfoRow(icon: Icons.group_rounded, label: 'Club', value: approval['club'] ?? 'Unknown'),
          _InfoRow(icon: Icons.person_rounded, label: 'Submitted by', value: approval['submittedBy'] ?? 'Unknown'),
          _InfoRow(icon: Icons.calendar_today_rounded, label: 'Date', value: _formatDate(approval['date'])),
          if (approval['startTime'] != null && approval['endTime'] != null)
            _InfoRow(
              icon: Icons.access_time_rounded,
              label: 'Time',
              value: '${approval['startTime']} - ${approval['endTime']}',
            ),
          _InfoRow(icon: Icons.location_on_rounded, label: 'Venue', value: approval['venue'] ?? 'TBD'),
          if (approval['capacity'] != null)
            _InfoRow(icon: Icons.people_rounded, label: 'Capacity', value: approval['capacity'].toString()),
          if (approval['budget'] != null && approval['budget'] > 0)
            _InfoRow(icon: Icons.attach_money_rounded, label: 'Budget', value: '\$${approval['budget']}'),
          
          if (approval['description'] != null) ...[
            const SizedBox(height: 12),
            Text(
              approval['description'],
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: AppColors.pureWhite,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGray),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.pureWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case 'approved':
        backgroundColor = Colors.green;
        textColor = AppColors.pureWhite;
        statusText = 'Approved';
        break;
      case 'rejected':
        backgroundColor = Colors.red;
        textColor = AppColors.pureWhite;
        statusText = 'Rejected';
        break;
      case 'pending_advisor':
        backgroundColor = Colors.orange;
        textColor = AppColors.pureWhite;
        statusText = 'Pending Advisor';
        break;
      case 'pending_coordinator':
        backgroundColor = Colors.blue;
        textColor = AppColors.pureWhite;
        statusText = 'Pending Coordinator';
        break;
      default:
        backgroundColor = Colors.orange;
        textColor = AppColors.pureWhite;
        statusText = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


