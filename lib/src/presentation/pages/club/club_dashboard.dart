import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../../../data/models/user/user_model.dart';
import '../../providers/auth_provider.dart';
import 'event_proposal_page.dart';
import 'volunteer_management_page.dart';
import 'member_management_page.dart';

class ClubDashboard extends StatefulWidget {
  const ClubDashboard({super.key});

  @override
  State<ClubDashboard> createState() => _ClubDashboardState();
}

class _ClubDashboardState extends State<ClubDashboard> {
  int _currentIndex = 0;
  Map<String, dynamic>? _selectedClub;

  @override
  void initState() {
    super.initState();
    // Select first club by default for advisors
    final userClubs = _getUserClubs();
    if (userClubs.isNotEmpty) {
      _selectedClub = userClubs.first;
    }
  }

  List<Map<String, dynamic>> _getUserClubs() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user!;
    
    if (user.role == 'advisor') {
      return MockDataService.getClubsForAdvisor();
    } else {
      // For coordinators/subgroup heads, show clubs where they have roles
      return MockDataService.clubs.where((club) => 
        club['isMember'] == true && club['userRole'] != null
      ).toList();
    }
  }

  bool get _isAdvisor {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.user!.role == 'advisor';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user!;
    final userClubs = _getUserClubs();

    if (userClubs.isEmpty) {
      return _buildNoClubsView(user);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: _buildAppBarTitle(user),
        actions: _buildAppBarActions(userClubs),
      ),
      body: _selectedClub == null
          ? _buildNoClubSelected()
          : IndexedStack(
              index: _currentIndex,
              children: _isAdvisor 
                  ? _buildAdvisorTabs()
                  : _buildCoordinatorTabs(),
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBarTitle(UserModel user) {
    if (_selectedClub != null) {
      final roleDisplay = _isAdvisor ? 'Advisor' : MockDataService.getUserRoleDisplayName(_selectedClub!['userRole']);
      return Text(
        '${_selectedClub!['name']} - $roleDisplay',
        style: AppTextStyles.headlineSmall,
      );
    }
    return Text(
      'Club Dashboard',
      style: AppTextStyles.headlineSmall,
    );
  }

  List<Widget> _buildAppBarActions(List<Map<String, dynamic>> userClubs) {
    final actions = <Widget>[];
    
    // Add club dropdown if user manages multiple clubs (advisor)
    if (userClubs.length > 1 && _isAdvisor) {
      actions.add(_buildClubDropdown(userClubs));
    }
    
    actions.addAll([
      IconButton(
        icon: const Icon(Icons.notifications_rounded),
        onPressed: () {},
      ),
    ]);
    
    return actions;
  }

  Widget _buildClubDropdown(List<Map<String, dynamic>> clubs) {
    return DropdownButton<Map<String, dynamic>>(
      value: _selectedClub,
      dropdownColor: AppColors.darkGray,
      icon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.accentYellow),
      underline: const SizedBox(),
      items: clubs.map((club) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: club,
          child: Text(
            club['name'],
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
          ),
        );
      }).toList(),
      onChanged: (club) {
        setState(() {
          _selectedClub = club;
        });
      },
    );
  }

  List<Widget> _buildAdvisorTabs() {
    return [
      _AdvisorOverviewTab(club: _selectedClub!),
      _AdvisorApprovalsTab(club: _selectedClub!),
      _AdvisorMembersTab(club: _selectedClub!),
      _AdvisorReportsTab(club: _selectedClub!),
    ];
  }

  List<Widget> _buildCoordinatorTabs() {
    return [
      _CoordinatorOverviewTab(club: _selectedClub!),
      _CoordinatorEventsTab(club: _selectedClub!),
      _CoordinatorMembersTab(club: _selectedClub!),
      _CoordinatorVolunteersTab(club: _selectedClub!),
    ];
  }

  Widget _buildNoClubsView(UserModel user) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(_isAdvisor ? 'Club Advisor Dashboard' : 'Club Dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isAdvisor ? Icons.school_rounded : Icons.group_off_rounded,
                size: 64,
                color: AppColors.mediumGray,
              ),
              const SizedBox(height: 16),
              Text(
                _isAdvisor ? 'No Clubs Assigned' : 'No Club Management Access',
                style: AppTextStyles.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isAdvisor 
                  ? 'You are not currently assigned as an advisor to any clubs. Please contact the administration.'
                  : 'You need to be assigned as a Club Coordinator or Subgroup Head to access club management features.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoClubSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_rounded,
            size: 64,
            color: AppColors.mediumGray,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a Club',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Please select a club from the dropdown to view details',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final isAdvisor = _isAdvisor;
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        border: Border(
          top: BorderSide(color: AppColors.lightGray, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: isAdvisor 
                ? _buildAdvisorNavItems()
                : _buildCoordinatorNavItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAdvisorNavItems() {
    return [
      _ClubNavItem(
        icon: Icons.dashboard_rounded,
        label: 'Overview',
        isActive: _currentIndex == 0,
        onTap: () => setState(() => _currentIndex = 0),
      ),
      _ClubNavItem(
        icon: Icons.approval_rounded,
        label: 'Approvals',
        isActive: _currentIndex == 1,
        onTap: () => setState(() => _currentIndex = 1),
      ),
      _ClubNavItem(
        icon: Icons.people_rounded,
        label: 'Members',
        isActive: _currentIndex == 2,
        onTap: () => setState(() => _currentIndex = 2),
      ),
      _ClubNavItem(
        icon: Icons.assessment_rounded,
        label: 'Reports',
        isActive: _currentIndex == 3,
        onTap: () => setState(() => _currentIndex = 3),
      ),
    ];
  }

  List<Widget> _buildCoordinatorNavItems() {
    return [
      _ClubNavItem(
        icon: Icons.dashboard_rounded,
        label: 'Overview',
        isActive: _currentIndex == 0,
        onTap: () => setState(() => _currentIndex = 0),
      ),
      _ClubNavItem(
        icon: Icons.event_rounded,
        label: 'Events',
        isActive: _currentIndex == 1,
        onTap: () => setState(() => _currentIndex = 1),
      ),
      _ClubNavItem(
        icon: Icons.people_rounded,
        label: 'Members',
        isActive: _currentIndex == 2,
        onTap: () => setState(() => _currentIndex = 2),
      ),
      _ClubNavItem(
        icon: Icons.volunteer_activism_rounded,
        label: 'Volunteers',
        isActive: _currentIndex == 3,
        onTap: () => setState(() => _currentIndex = 3),
      ),
    ];
  }
}

// ADVISOR TABS
class _AdvisorOverviewTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _AdvisorOverviewTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final analytics = MockDataService.getClubAnalytics(club['id']);
    final pendingApprovals = MockDataService.getPendingApprovalsForAdvisor(club['id']);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ClubHeader(club: club, isAdvisor: true),
          const SizedBox(height: 24),

          // Quick Stats
          Text('Club Overview', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _StatCard(title: 'Total Members', value: analytics['totalMembers'].toString(), icon: Icons.people_rounded, color: Colors.blue),
              _StatCard(title: 'Active Members', value: analytics['activeMembers'].toString(), icon: Icons.people_alt_rounded, color: Colors.green),
              _StatCard(title: 'Events This Month', value: analytics['eventsThisMonth'].toString(), icon: Icons.event_rounded, color: Colors.orange),
              _StatCard(title: 'Attendance Rate', value: analytics['attendanceRate'], icon: Icons.trending_up_rounded, color: Colors.purple),
            ],
          ),

          const SizedBox(height: 24),

          // Pending Approvals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pending Approvals', style: AppTextStyles.headlineSmall),
              Badge(
                backgroundColor: Colors.orange,
                label: Text(pendingApprovals.length.toString()),
                child: Icon(Icons.pending_actions_rounded, color: AppColors.mediumGray),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...pendingApprovals.take(2).map((approval) => _PendingApprovalItem(approval: approval)),

          const SizedBox(height: 24),

          // Quick Actions
          Text('Quick Actions', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _ActionCard(
                title: 'Assign Roles',
                icon: Icons.admin_panel_settings_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MemberManagementPage()),
                  );
                },
                color: Colors.blue,
              ),
              _ActionCard(
                title: 'Review Budget',
                icon: Icons.attach_money_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budget review coming soon')),
                  );
                },
                color: Colors.green,
              ),
              _ActionCard(
                title: 'Generate Report',
                icon: Icons.assessment_rounded,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report generation coming soon')),
                  );
                },
                color: Colors.orange,
              ),
              _ActionCard(
                title: 'Forward to Admin',
                icon: Icons.forward_to_inbox_rounded,
                onTap: () {
                  _forwardToAdmin(context);
                },
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _forwardToAdmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text('Forward to Admin', style: AppTextStyles.headlineSmall),
        content: Text(
          'This will forward all approved events to the admin for final approval.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.mediumGray)),
          ),
          ElevatedButton(
            onPressed: () {
              // Update pending approvals to forward to admin
              final pendingApprovals = MockDataService.getPendingApprovalsForAdvisor(club['id']);
              for (var approval in pendingApprovals) {
                if (approval['status'] == 'pending_advisor') {
                  approval['status'] = 'pending_admin';
                }
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Events forwarded to admin successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentYellow,
              foregroundColor: AppColors.darkGray,
            ),
            child: const Text('Forward'),
          ),
        ],
      ),
    );
  }
}

class _AdvisorApprovalsTab extends StatefulWidget {
  final Map<String, dynamic> club;

  const _AdvisorApprovalsTab({required this.club});

  @override
  State<_AdvisorApprovalsTab> createState() => _AdvisorApprovalsTabState();
}

class _AdvisorApprovalsTabState extends State<_AdvisorApprovalsTab> {
  void _handleApproval(Map<String, dynamic> approval, bool isApproved) {
    setState(() {
      approval['status'] = isApproved ? 'pending_admin' : 'rejected';
      approval['reviewedBy'] = 'Advisor';
      approval['reviewedDate'] = DateTime.now().toIso8601String();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isApproved ? 'Event approved! Forwarded to admin.' : 'Event rejected'),
        backgroundColor: isApproved ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingApprovals = MockDataService.getPendingApprovalsForAdvisor(widget.club['id']);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingApprovals.length,
      itemBuilder: (context, index) {
        final approval = pendingApprovals[index];
        return _AdvisorApprovalCard(
          approval: approval,
          onApprove: () => _handleApproval(approval, true),
          onReject: () => _handleApproval(approval, false),
        );
      },
    );
  }
}

void _handleAdvisorApproval(BuildContext context, Map<String, dynamic> approval, bool isApproved) {
  approval['status'] = isApproved ? 'pending_admin' : 'rejected';
  approval['reviewedBy'] = 'Advisor';
  approval['reviewedDate'] = DateTime.now().toIso8601String();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(isApproved ? 'Event approved! Forwarded to admin.' : 'Event rejected'),
      backgroundColor: isApproved ? Colors.green : Colors.red,
    ),
  );
}

class _AdvisorMembersTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _AdvisorMembersTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final members = _getClubMembers();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Club Members - ${club['name']}',
                  style: AppTextStyles.headlineSmall,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showRoleAssignmentDialog(),
                icon: Icon(Icons.admin_panel_settings_rounded, size: 18),
                label: Text('Assign Roles'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentYellow,
                  foregroundColor: AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return _AdvisorMemberCard(member: member, onRoleChange: () {});
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getClubMembers() {
    return [
      {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@campus.edu',
        'currentRole': 'member',
        'joinDate': '2024-09-01',
        'canPromote': true,
      },
      {
        'id': '2',
        'name': 'Jane Smith',
        'email': 'jane@campus.edu',
        'currentRole': 'coordinator',
        'joinDate': '2024-08-15',
        'canPromote': false,
      },
      {
        'id': '3',
        'name': 'Mike Johnson',
        'email': 'mike@campus.edu',
        'currentRole': 'subgroup_head',
        'joinDate': '2024-09-10',
        'canPromote': true,
      },
    ];
  }

  void _showRoleAssignmentDialog() {
    // TODO: Implement role assignment dialog
  }
}

class _AdvisorReportsTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _AdvisorReportsTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final reports = MockDataService.getAdvisorReports(club['id']);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _AdvisorReportCard(report: report);
      },
    );
  }
}

// COORDINATOR TABS
class _CoordinatorOverviewTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _CoordinatorOverviewTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final clubEvents = MockDataService.getEventsForUser().where((event) => event['club'] == club['name']).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ClubHeader(club: club, isAdvisor: false),
          const SizedBox(height: 24),

          // Quick Stats
          Text('Club Overview', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _StatCard(title: 'Total Members', value: club['memberCount'].toString(), icon: Icons.people_rounded, color: Colors.blue),
              _StatCard(title: 'Upcoming Events', value: club['upcomingEvents'].toString(), icon: Icons.event_rounded, color: Colors.green),
              _StatCard(title: 'Subgroups', value: club['subgroups']?.length.toString() ?? '0', icon: Icons.group_work_rounded, color: Colors.orange),
              _StatCard(title: 'Volunteers Needed', value: '5', icon: Icons.volunteer_activism_rounded, color: Colors.purple),
            ],
          ),

          const SizedBox(height: 24),

          // Upcoming Events
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Upcoming Events', style: AppTextStyles.headlineSmall),
              TextButton(
                onPressed: () {},
                child: Text('View All', style: AppTextStyles.link),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...clubEvents.take(2).map((event) => _CoordinatorEventItem(event: event)),

          const SizedBox(height: 24),

          // Quick Actions
          Text('Quick Actions', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _ActionCard(
                title: 'Propose Event',
                icon: Icons.add_circle_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventProposalPage()),
                  );
                },
                color: Colors.green,
              ),
              _ActionCard(
                title: 'Manage Volunteers',
                icon: Icons.volunteer_activism_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VolunteerManagementPage()),
                  );
                },
                color: Colors.orange,
              ),
              _ActionCard(
                title: 'Member Requests',
                icon: Icons.person_add_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MemberManagementPage()),
                  );
                },
                color: Colors.blue,
              ),
              _ActionCard(
                title: 'Club Chat',
                icon: Icons.chat_rounded,
                onTap: () {
                  // TODO: Navigate to club chat
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Club chat coming soon')),
                  );
                },
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoordinatorEventsTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _CoordinatorEventsTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final clubEvents = MockDataService.getEventsForUser().where((event) => event['club'] == club['name']).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubEvents.length,
      itemBuilder: (context, index) {
        final event = clubEvents[index];
        return _CoordinatorEventCard(event: event);
      },
    );
  }
}

class _CoordinatorMembersTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _CoordinatorMembersTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final members = _getClubMembers();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _CoordinatorMemberCard(member: member);
      },
    );
  }

  List<Map<String, dynamic>> _getClubMembers() {
    return [
      {
        'name': 'John Doe',
        'email': 'john@campus.edu',
        'role': 'Member',
        'joinDate': '2024-09-01',
        'subgroup': 'Web Development',
      },
      {
        'name': 'Jane Smith',
        'email': 'jane@campus.edu',
        'role': 'Subgroup Head',
        'joinDate': '2024-08-15',
        'subgroup': 'Mobile Development',
      },
    ];
  }
}

class _CoordinatorVolunteersTab extends StatelessWidget {
  final Map<String, dynamic> club;

  const _CoordinatorVolunteersTab({required this.club});

  @override
  Widget build(BuildContext context) {
    final volunteerOpportunities = [
      {
        'eventTitle': 'Tech Symposium 2024',
        'neededRoles': ['Registration', 'Technical Support'],
        'volunteersNeeded': 8,
        'currentVolunteers': 3,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: volunteerOpportunities.length,
      itemBuilder: (context, index) {
        final opportunity = volunteerOpportunities[index];
        return _VolunteerOpportunityCard(opportunity: opportunity);
      },
    );
  }
}

// WIDGET COMPONENTS

class _ClubNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ClubNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.accentYellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClubHeader extends StatelessWidget {
  final Map<String, dynamic> club;
  final bool isAdvisor;

  const _ClubHeader({required this.club, required this.isAdvisor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(club['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club['name'],
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  club['description'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isAdvisor ? 'Club Advisor' : MockDataService.getUserRoleDisplayName(club['userRole']),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontSize: 20,
              color: AppColors.pureWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha((0.3 * 255).toInt())),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingApprovalItem extends StatelessWidget {
  final Map<String, dynamic> approval;

  const _PendingApprovalItem({required this.approval});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withAlpha((0.3 * 255).toInt())),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.pending_rounded, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  approval['title'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Submitted by: ${approval['submittedBy']}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.mediumGray),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _AdvisorApprovalCard extends StatelessWidget {
  final Map<String, dynamic> approval;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _AdvisorApprovalCard({
    required this.approval,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  approval['title'],
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha((0.2 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pending Review',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Submitted by: ${approval['submittedBy']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            'Date: ${approval['submittedDate']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          if (approval['budget'] != null)
            Text(
              'Budget: \$${approval['budget']}',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _handleAdvisorApproval(context, approval, false);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Request Changes'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _handleAdvisorApproval(context, approval, true);
                      },
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
      ),
    );
  }
}

// ADD THE MISSING _AdvisorMemberCard WIDGET
class _AdvisorMemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onRoleChange;

  const _AdvisorMemberCard({required this.member, required this.onRoleChange});

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.darkGray,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member['email'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
                Text(
                  'Joined: ${member['joinDate']}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: member['currentRole'],
            dropdownColor: AppColors.darkGray,
            icon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.accentYellow),
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: 'member', 
                child: Text('Member', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite)),
              ),
              DropdownMenuItem(
                value: 'subgroup_head', 
                child: Text('Subgroup Head', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite)),
              ),
              DropdownMenuItem(
                value: 'coordinator', 
                child: Text('Coordinator', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite)),
              ),
            ],
            onChanged: member['canPromote'] ? (newRole) {
              onRoleChange();
            } : null,
          ),
        ],
      ),
    );
  }
}

class _AdvisorReportCard extends StatelessWidget {
  final Map<String, dynamic> report;

  const _AdvisorReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  report['title'],
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
              ),
              IconButton(
                icon: Icon(Icons.download_rounded, color: AppColors.accentYellow),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading report...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Period: ${report['period']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            'Generated: ${report['generatedDate']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 12),
          // Metrics
          if (report['metrics'] != null) ...[
            Text(
              'Key Metrics:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: (report['metrics'] as Map<String, dynamic>).entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlack,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentYellow,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CoordinatorEventItem extends StatelessWidget {
  final Map<String, dynamic> event;

  const _CoordinatorEventItem({required this.event});

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
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(event['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${event['date']} • ${event['venue']}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          _StatusBadge(status: event['status']),
        ],
      ),
    );
  }
}

class _CoordinatorEventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _CoordinatorEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event['title'],
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                ),
              ),
              _StatusBadge(status: event['status']),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${event['date']} • ${event['time']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            event['venue'],
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Text('Edit Event'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
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

class _CoordinatorMemberCard extends StatelessWidget {
  final Map<String, dynamic> member;

  const _CoordinatorMemberCard({required this.member});

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.darkGray,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member['email'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              member['role'],
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.accentYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VolunteerOpportunityCard extends StatelessWidget {
  final Map<String, dynamic> opportunity;

  const _VolunteerOpportunityCard({required this.opportunity});

  @override
  Widget build(BuildContext context) {
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
            'Needed Roles: ${opportunity['neededRoles'].join(', ')}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            'Volunteers: ${opportunity['currentVolunteers']}/${opportunity['volunteersNeeded']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VolunteerManagementPage()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Text('View Applications'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VolunteerManagementPage()),
                    );
                  },
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
      case 'pending':
        backgroundColor = Colors.orange;
        textColor = AppColors.pureWhite;
        statusText = 'Pending';
        break;
      case 'rejected':
        backgroundColor = Colors.red;
        textColor = AppColors.pureWhite;
        statusText = 'Rejected';
        break;
      default:
        backgroundColor = AppColors.mediumGray;
        textColor = AppColors.pureWhite;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
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
