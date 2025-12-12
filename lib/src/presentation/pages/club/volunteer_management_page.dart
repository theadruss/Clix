import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class VolunteerManagementPage extends StatefulWidget {
  const VolunteerManagementPage({super.key});

  @override
  State<VolunteerManagementPage> createState() => _VolunteerManagementPageState();
}

class _VolunteerManagementPageState extends State<VolunteerManagementPage> {
  String _selectedTab = 'opportunities'; // opportunities, applications, assigned

  // Mock volunteer opportunities
  final List<Map<String, dynamic>> _volunteerOpportunities = [
    {
      'id': 'v1',
      'eventTitle': 'Tech Symposium 2024',
      'eventId': '1',
      'neededRoles': ['Registration Desk', 'Technical Support', 'Stage Manager'],
      'volunteersNeeded': 8,
      'currentVolunteers': 3,
      'eventDate': 'Oct 15, 2024',
      'eventTime': '2:00 PM - 5:00 PM',
    },
    {
      'id': 'v2',
      'eventTitle': 'Cultural Fest Auditions',
      'eventId': '2',
      'neededRoles': ['Stage Management', 'Crowd Control'],
      'volunteersNeeded': 5,
      'currentVolunteers': 2,
      'eventDate': 'Oct 18, 2024',
      'eventTime': '4:00 PM - 7:00 PM',
    },
  ];

  // Mock applications
  final List<Map<String, dynamic>> _applications = [
    {
      'id': 'a1',
      'volunteerName': 'John Doe',
      'volunteerEmail': 'john@campus.edu',
      'eventTitle': 'Tech Symposium 2024',
      'role': 'Registration Desk',
      'status': 'pending',
      'appliedDate': '2024-10-12',
    },
    {
      'id': 'a2',
      'volunteerName': 'Jane Smith',
      'volunteerEmail': 'jane@campus.edu',
      'eventTitle': 'Tech Symposium 2024',
      'role': 'Technical Support',
      'status': 'approved',
      'appliedDate': '2024-10-11',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Volunteer Management', style: AppTextStyles.headlineSmall),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _TabButton(
                  label: 'Opportunities',
                  isActive: _selectedTab == 'opportunities',
                  onTap: () => setState(() => _selectedTab = 'opportunities'),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Applications',
                  isActive: _selectedTab == 'applications',
                  onTap: () => setState(() => _selectedTab = 'applications'),
                ),
                const SizedBox(width: 8),
                _TabButton(
                  label: 'Assigned',
                  isActive: _selectedTab == 'assigned',
                  onTap: () => setState(() => _selectedTab = 'assigned'),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _selectedTab == 'opportunities'
                ? _buildOpportunitiesTab()
                : _selectedTab == 'applications'
                    ? _buildApplicationsTab()
                    : _buildAssignedTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunitiesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _volunteerOpportunities.length,
      itemBuilder: (context, index) {
        final opportunity = _volunteerOpportunities[index];
        return _VolunteerOpportunityCard(
          opportunity: opportunity,
          onManage: () {
            // Navigate to manage volunteers for this event
            _showManageVolunteersDialog(opportunity);
          },
        );
      },
    );
  }

  Widget _buildApplicationsTab() {
    final pendingApps = _applications.where((app) => app['status'] == 'pending').toList();
    final approvedApps = _applications.where((app) => app['status'] == 'approved').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (pendingApps.isNotEmpty) ...[
          Text('Pending Applications', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...pendingApps.map((app) => _ApplicationCard(
            application: app,
            onApprove: () => _handleApplication(app, true),
            onReject: () => _handleApplication(app, false),
          )),
          const SizedBox(height: 24),
        ],
        if (approvedApps.isNotEmpty) ...[
          Text('Approved Applications', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...approvedApps.map((app) => _ApplicationCard(
            application: app,
            onApprove: null,
            onReject: null,
          )),
        ],
      ],
    );
  }

  Widget _buildAssignedTab() {
    final assigned = _applications.where((app) => app['status'] == 'approved').toList();
    
    return assigned.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volunteer_activism_rounded, size: 64, color: AppColors.mediumGray),
                const SizedBox(height: 16),
                Text(
                  'No volunteers assigned yet',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assigned.length,
            itemBuilder: (context, index) {
              return _AssignedVolunteerCard(application: assigned[index]);
            },
          );
  }

  void _handleApplication(Map<String, dynamic> application, bool isApproved) {
    setState(() {
      application['status'] = isApproved ? 'approved' : 'rejected';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isApproved ? 'Application approved!' : 'Application rejected'),
        backgroundColor: isApproved ? Colors.green : Colors.red,
      ),
    );
  }

  void _showManageVolunteersDialog(Map<String, dynamic> opportunity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text('Manage Volunteers', style: AppTextStyles.headlineSmall),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity['eventTitle'],
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Text(
                'Needed Roles:',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...opportunity['neededRoles'].map<Widget>((role) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.accentYellow),
                    const SizedBox(width: 8),
                    Text(role, style: AppTextStyles.bodyMedium),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              Text(
                'Volunteers: ${opportunity['currentVolunteers']}/${opportunity['volunteersNeeded']}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.accentYellow)),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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

class _VolunteerOpportunityCard extends StatelessWidget {
  final Map<String, dynamic> opportunity;
  final VoidCallback onManage;

  const _VolunteerOpportunityCard({
    required this.opportunity,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final progress = opportunity['currentVolunteers'] / opportunity['volunteersNeeded'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opportunity['eventTitle'],
            style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '${opportunity['eventDate']} • ${opportunity['eventTime']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 12),
          Text(
            'Needed Roles: ${opportunity['neededRoles'].join(', ')}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Volunteers: ${opportunity['currentVolunteers']}/${opportunity['volunteersNeeded']}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.primaryBlack,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentYellow),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onManage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Text('View Applications'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onManage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: AppColors.darkGray,
                  ),
                  child: const Text('Manage'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _ApplicationCard({
    required this.application,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = application['status'] == 'pending';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
        border: isPending ? Border.all(color: Colors.orange.withAlpha((0.3 * 255).toInt())) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application['volunteerName'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      application['volunteerEmail'],
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                    ),
                  ],
                ),
              ),
              if (isPending)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Pending',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.orange),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Approved',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.green),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Event: ${application['eventTitle']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
          ),
          Text(
            'Role: ${application['role']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          if (isPending && onApprove != null && onReject != null) ...[
            const SizedBox(height: 12),
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

class _AssignedVolunteerCard extends StatelessWidget {
  final Map<String, dynamic> application;

  const _AssignedVolunteerCard({required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.person_rounded, color: AppColors.darkGray),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application['volunteerName'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  application['role'],
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                ),
                Text(
                  application['eventTitle'],
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: Colors.green),
        ],
      ),
    );
  }
}


