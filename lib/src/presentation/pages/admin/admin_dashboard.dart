import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import 'event_approval_page.dart';
import 'user_management_page.dart';
import 'analytics_page.dart';
import 'system_settings_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Admin Dashboard',
          style: AppTextStyles.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () {
              // Navigate to notifications page (if implemented)
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              // Navigate to profile page (if implemented)
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _OverviewTab(),
          _ApprovalsTab(),
          _AnalyticsTab(),
          _ClubsTab(),
        ],
      ),
      bottomNavigationBar: Container(
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
              children: [
                _AdminNavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Overview',
                  isActive: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _AdminNavItem(
                  icon: Icons.approval_rounded,
                  label: 'Approvals',
                  isActive: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _AdminNavItem(
                  icon: Icons.analytics_rounded,
                  label: 'Analytics',
                  isActive: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _AdminNavItem(
                  icon: Icons.group_rounded,
                  label: 'Clubs',
                  isActive: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final stats = MockDataService.adminStats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, Principal',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Campus Event Management Overview',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 24),

          // Statistics Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _StatCard(
                title: 'Total Events',
                value: stats['totalEvents'].toString(),
                icon: Icons.event_rounded,
                color: Colors.blue,
              ),
              _StatCard(
                title: 'Pending Approvals',
                value: stats['pendingApprovals'].toString(),
                icon: Icons.pending_actions_rounded,
                color: Colors.orange,
              ),
              _StatCard(
                title: 'Active Clubs',
                value: stats['activeClubs'].toString(),
                icon: Icons.group_rounded,
                color: Colors.green,
              ),
              _StatCard(
                title: 'Total Students',
                value: stats['totalStudents'].toString(),
                icon: Icons.people_rounded,
                color: Colors.purple,
              ),
              _StatCard(
                title: 'Revenue',
                value: '\$${stats['revenue']}',
                icon: Icons.attach_money_rounded,
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _ActionCard(
                title: 'Approve Events',
                icon: Icons.event_available_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventApprovalPage()),
                  );
                },
                color: Colors.green,
              ),
              _ActionCard(
                title: 'Manage Users',
                icon: Icons.group_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserManagementPage()),
                  );
                },
                color: Colors.blue,
              ),
              _ActionCard(
                title: 'View Reports',
                icon: Icons.analytics_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AnalyticsPage()),
                  );
                },
                color: Colors.purple,
              ),
              _ActionCard(
                title: 'System Settings',
                icon: Icons.settings_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SystemSettingsPage()),
                  );
                },
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          ...MockDataService.pendingApprovals.take(3).map((approval) => 
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventApprovalPage()),
                );
              },
              child: _ActivityItem(approval: approval),
            ),
          ).toList(),
        ],
      ),
    );
  }
}

class _ApprovalsTab extends StatefulWidget {
  const _ApprovalsTab();

  @override
  State<_ApprovalsTab> createState() => _ApprovalsTabState();
}

class _ApprovalsTabState extends State<_ApprovalsTab> {
  void _handleApproval(Map<String, dynamic> approval, bool isApproved) {
    setState(() {
      approval['status'] = isApproved ? 'approved' : 'rejected';
      approval['reviewedBy'] = 'Admin';
      approval['reviewedDate'] = DateTime.now().toIso8601String();
    });

    if (isApproved) {
      final event = {
        'id': approval['id'],
        'title': approval['title'],
        'club': approval['club'],
        'date': approval['date'] ?? 'TBD',
        'time': '${approval['startTime'] ?? 'TBD'} - ${approval['endTime'] ?? 'TBD'}',
        'venue': approval['venue'] ?? 'TBD',
        'description': approval['description'] ?? '',
        'interestedCount': 0,
        'imageUrl': 'https://picsum.photos/400/200?random=${approval['id']}',
        'status': 'approved',
        'category': approval['category'] ?? 'Other',
        'isRegistered': false,
      };
      MockDataService.events.insert(0, event);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isApproved ? 'Event approved successfully!' : 'Event rejected'),
        backgroundColor: isApproved ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: MockDataService.pendingApprovals.length,
      itemBuilder: (context, index) {
        final approval = MockDataService.pendingApprovals[index];
        return _ApprovalCard(
          approval: approval,
          onApprove: () => _handleApproval(approval, true),
          onReject: () => _handleApproval(approval, false),
        );
      },
    );
  }
}

class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics & Reports',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 16),
          _AnalyticsCard(
            title: 'Event Participation',
            value: '78%',
            description: 'Average student participation in events',
          ),
          _AnalyticsCard(
            title: 'Club Engagement',
            value: '65%',
            description: 'Students involved in club activities',
          ),
          _AnalyticsCard(
            title: 'Revenue Growth',
            value: '+24%',
            description: 'Compared to last semester',
          ),
        ],
      ),
    );
  }
}

class _ClubsTab extends StatelessWidget {
  const _ClubsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: MockDataService.clubs.length,
      itemBuilder: (context, index) {
        final club = MockDataService.clubs[index];
        return _ClubManagementCard(club: club);
      },
    );
  }
}

// Widget components for Admin Dashboard
class _AdminNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _AdminNavItem({
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
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 24,
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
            Icon(icon, color: color, size: 32),
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

class _ActivityItem extends StatelessWidget {
  final Map<String, dynamic> approval;

  const _ActivityItem({required this.approval});

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
                  '${approval['club']} • ${approval['submittedBy']}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Review',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accentYellow,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
              Text(
                approval['title'],
                style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha((0.2 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Pending',
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
            'Club: ${approval['club']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            'Submitted by: ${approval['submittedBy']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            'Budget: \$${approval['budget']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
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
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.description,
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.analytics_rounded, color: AppColors.accentYellow),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.accentYellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubManagementCard extends StatelessWidget {
  final Map<String, dynamic> club;

  const _ClubManagementCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${club['memberCount']} members • ${club['upcomingEvents']} events',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.mediumGray),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
