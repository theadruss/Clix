import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class VolunteerManagementPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const VolunteerManagementPage({super.key, required this.event});

  @override
  State<VolunteerManagementPage> createState() => _VolunteerManagementPageState();
}

class _VolunteerManagementPageState extends State<VolunteerManagementPage> {
  int _selectedTab = 0; // 0: Applications, 1: Assigned Volunteers

  // Mock data
  final List<Map<String, dynamic>> _pendingApplications = [
    {
      'id': '1',
      'studentName': 'John Doe',
      'studentId': 'STU001',
      'email': 'john.doe@campus.edu',
      'appliedRole': 'Registration Desk',
      'appliedDate': 'Oct 10, 2024',
      'skills': ['Communication', 'Organization'],
      'previousExperience': 'Volunteered at Tech Fest 2023',
    },
    {
      'id': '2',
      'studentName': 'Sarah Wilson',
      'studentId': 'STU002',
      'email': 'sarah.wilson@campus.edu',
      'appliedRole': 'Technical Support',
      'appliedDate': 'Oct 11, 2024',
      'skills': ['Technical Support', 'Problem Solving'],
      'previousExperience': 'Computer Lab Assistant',
    },
    {
      'id': '3',
      'studentName': 'Mike Chen',
      'studentId': 'STU003',
      'email': 'mike.chen@campus.edu',
      'appliedRole': 'Any Role',
      'appliedDate': 'Oct 12, 2024',
      'skills': ['Multitasking', 'Leadership'],
      'previousExperience': 'Event Coordinator for Cultural Fest',
    },
  ];

  final List<Map<String, dynamic>> _assignedVolunteers = [
    {
      'id': '4',
      'studentName': 'Emma Davis',
      'studentId': 'STU004',
      'email': 'emma.davis@campus.edu',
      'assignedRole': 'Stage Manager',
      'assignedDate': 'Oct 8, 2024',
      'contact': '+1 234-567-8900',
    },
    {
      'id': '5',
      'studentName': 'Alex Kumar',
      'studentId': 'STU005',
      'email': 'alex.kumar@campus.edu',
      'assignedRole': 'Technical Support',
      'assignedDate': 'Oct 9, 2024',
      'contact': '+1 234-567-8901',
    },
  ];

  final List<String> _availableRoles = [
    'Registration Desk',
    'Technical Support',
    'Stage Manager',
    'Crowd Management',
    'Photography',
    'Social Media',
    'Logistics',
    'Speaker Support',
  ];

  void _approveApplication(String applicationId, String role) {
    setState(() {
      final application = _pendingApplications.firstWhere((app) => app['id'] == applicationId);
      _pendingApplications.removeWhere((app) => app['id'] == applicationId);
      _assignedVolunteers.add({
        ...application,
        'assignedRole': role,
        'assignedDate': 'Today',
        'contact': 'Not provided',
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.accentYellow,
        content: Text(
          'Application approved! $role assigned.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
        ),
      ),
    );
  }

  void _rejectApplication(String applicationId) {
    setState(() {
      _pendingApplications.removeWhere((app) => app['id'] == applicationId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Application rejected.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
        ),
      ),
    );
  }

  void _reassignRole(String volunteerId, String newRole) {
    setState(() {
      final volunteer = _assignedVolunteers.firstWhere((vol) => vol['id'] == volunteerId);
      volunteer['assignedRole'] = newRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Manage Volunteers - ${widget.event['title']}',
          style: AppTextStyles.headlineSmall,
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: AppColors.darkGray,
            child: Row(
              children: [
                _VolunteerTab(
                  title: 'Applications (${_pendingApplications.length})',
                  isActive: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _VolunteerTab(
                  title: 'Assigned (${_assignedVolunteers.length})',
                  isActive: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: _selectedTab == 0
                ? _buildApplicationsList()
                : _buildAssignedVolunteersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList() {
    return _pendingApplications.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline_rounded,
                  size: 64,
                  color: AppColors.mediumGray,
                ),
                const SizedBox(height: 16),
                Text(
                  'No pending applications',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _pendingApplications.length,
            itemBuilder: (context, index) {
              final application = _pendingApplications[index];
              return _ApplicationCard(
                application: application,
                availableRoles: _availableRoles,
                onApprove: _approveApplication,
                onReject: _rejectApplication,
              );
            },
          );
  }

  Widget _buildAssignedVolunteersList() {
    return _assignedVolunteers.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 64,
                  color: AppColors.mediumGray,
                ),
                const SizedBox(height: 16),
                Text(
                  'No volunteers assigned yet',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _assignedVolunteers.length,
            itemBuilder: (context, index) {
              final volunteer = _assignedVolunteers[index];
              return _AssignedVolunteerCard(
                volunteer: volunteer,
                availableRoles: _availableRoles,
                onReassign: _reassignRole,
              );
            },
          );
  }
}

class _VolunteerTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _VolunteerTab({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.accentYellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Map<String, dynamic> application;
  final List<String> availableRoles;
  final Function(String, String) onApprove;
  final Function(String) onReject;

  const _ApplicationCard({
    required this.application,
    required this.availableRoles,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    String selectedRole = application['appliedRole'] == 'Any Role' 
        ? availableRoles.first 
        : application['appliedRole'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
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
                      application['studentName'],
                      style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                    ),
                    Text(
                      application['studentId'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                application['appliedDate'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Applied for: ${application['appliedRole']}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.accentYellow,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${application['email']}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Skills: ${application['skills'].join(', ')}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Experience: ${application['previousExperience']}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          
          // Role Assignment
          Text(
            'Assign Role:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedRole,
            dropdownColor: AppColors.darkGray,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: availableRoles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (value) {
              selectedRole = value!;
            },
          ),
          const SizedBox(height: 16),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onReject(application['id']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Reject',
                    style: AppTextStyles.buttonMedium.copyWith(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onApprove(application['id'], selectedRole),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentYellow,
                    foregroundColor: AppColors.darkGray,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Approve',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssignedVolunteerCard extends StatelessWidget {
  final Map<String, dynamic> volunteer;
  final List<String> availableRoles;
  final Function(String, String) onReassign;

  const _AssignedVolunteerCard({
    required this.volunteer,
    required this.availableRoles,
    required this.onReassign,
  });

  @override
  Widget build(BuildContext context) {
    String selectedRole = volunteer['assignedRole'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
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
                      volunteer['studentName'],
                      style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                    ),
                    Text(
                      volunteer['studentId'],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Assigned: ${volunteer['assignedDate']}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Email: ${volunteer['email']}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Contact: ${volunteer['contact']}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 12),
          
          // Role Reassignment
          Text(
            'Current Role:',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedRole,
            dropdownColor: AppColors.darkGray,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: availableRoles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (value) {
              selectedRole = value!;
              onReassign(volunteer['id'], selectedRole);
            },
          ),
        ],
      ),
    );
  }
}
