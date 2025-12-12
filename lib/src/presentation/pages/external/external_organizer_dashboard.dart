import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../../providers/auth_provider.dart';
import 'external_event_proposal_page.dart';

class ExternalOrganizerDashboard extends StatefulWidget {
  const ExternalOrganizerDashboard({super.key});

  @override
  State<ExternalOrganizerDashboard> createState() => _ExternalOrganizerDashboardState();
}

class _ExternalOrganizerDashboardState extends State<ExternalOrganizerDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(context),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _BottomNavItem(
                  icon: Icons.event_rounded,
                  label: 'Proposals',
                  isActive: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _BottomNavItem(
                  icon: Icons.analytics_rounded,
                  label: 'Analytics',
                  isActive: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _BottomNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
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

  List<Widget> _buildPages(BuildContext context) {
    return [
      _HomeTab(),
      _ProposalsTab(),
      _AnalyticsTab(),
      _ProfileTab(),
    ];
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Welcome, ${user.name}!',
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your events directly with the campus',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 32),
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Active Events',
                  value: '3',
                  icon: Icons.event_rounded,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Registrations',
                  value: '245',
                  icon: Icons.people_rounded,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Revenue',
                  value: '\$1,250',
                  icon: Icons.attach_money_rounded,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Pending',
                  value: '1',
                  icon: Icons.pending_actions_rounded,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Action Buttons
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExternalEventProposalPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.primaryBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Submit New Event'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {
                // Open chat with admin
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat with admin coming soon')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentYellow,
                side: const BorderSide(color: AppColors.accentYellow),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.chat_rounded),
              label: const Text('Contact Admin'),
            ),
          ),
          const SizedBox(height: 32),
          // Recent Activity
          Text(
            'Recent Activity',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          _RecentActivityItem(
            title: 'Tech Fest 2024',
            status: 'Approved',
            date: 'Dec 15, 2024',
            attendees: 320,
            statusColor: Colors.green,
          ),
          const SizedBox(height: 8),
          _RecentActivityItem(
            title: 'Workshop - Flutter Basics',
            status: 'Pending',
            date: 'Dec 20, 2024',
            attendees: 0,
            statusColor: Colors.orange,
          ),
          const SizedBox(height: 8),
          _RecentActivityItem(
            title: 'Networking Event',
            status: 'Approved',
            date: 'Dec 10, 2024',
            attendees: 156,
            statusColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class _ProposalsTab extends StatefulWidget {
  @override
  State<_ProposalsTab> createState() => _ProposalsTabState();
}

class _ProposalsTabState extends State<_ProposalsTab> {
  String _filter = 'all'; // all, pending, approved, rejected

  @override
  Widget build(BuildContext context) {
    final proposals = _getFilteredProposals();

    return Column(
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
        // Proposals List
        Expanded(
          child: proposals.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_rounded, size: 64, color: AppColors.mediumGray),
                      const SizedBox(height: 16),
                      Text(
                        'No proposals found',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: proposals.length,
                  itemBuilder: (context, index) {
                    return _ProposalCard(proposal: proposals[index]);
                  },
                ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredProposals() {
    final proposals = MockDataService.pendingApprovals.where((p) => p['submittedBy'] == 'External').toList();
    if (_filter == 'all') return proposals;
    return proposals.where((p) => (p['status'] ?? 'pending').contains(_filter)).toList();
  }
}

class _AnalyticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Event Analytics',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 16),
          _AnalyticsCard(
            title: 'Total Registrations',
            value: '721',
            description: 'Across all events',
            icon: Icons.people_rounded,
            color: Colors.blue,
          ),
          _AnalyticsCard(
            title: 'Revenue Generated',
            value: '\$4,250',
            description: 'From ticket sales',
            icon: Icons.attach_money_rounded,
            color: Colors.green,
          ),
          _AnalyticsCard(
            title: 'Average Rating',
            value: '4.7',
            description: 'Out of 5 stars',
            icon: Icons.star_rounded,
            color: Colors.orange,
          ),
          _AnalyticsCard(
            title: 'Attendance Rate',
            value: '78%',
            description: 'Registered vs attended',
            icon: Icons.trending_up_rounded,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    size: 40,
                    color: AppColors.primaryBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: AppTextStyles.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Organization Details',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          _ProfileField(label: 'Organization Name', value: user.name),
          _ProfileField(label: 'Email', value: user.email),
          _ProfileField(label: 'Phone', value: user.phoneNumber ?? 'Not provided'),
          _ProfileField(label: 'Member Since', value: 'Dec 2024'),
          const SizedBox(height: 32),
          _ProfileField(label: 'Tax ID', value: 'TAX-2024-001'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile functionality coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.primaryBlack,
              ),
              child: const Text('Edit Profile'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widgets

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.accentYellow : AppColors.mediumGray, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
              fontSize: 10,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.2 * 255).toInt()),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.headlineSmall),
        ],
      ),
    );
  }
}

class _RecentActivityItem extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final int attendees;
  final Color statusColor;

  const _RecentActivityItem({
    required this.title,
    required this.status,
    required this.date,
    required this.attendees,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.2 * 255).toInt()),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.bodySmall.copyWith(color: statusColor, fontSize: 10),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$attendees registered',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray, fontSize: 10),
              ),
            ],
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
    final isActive = filter == currentFilter;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentYellow : AppColors.darkGray,
          borderRadius: BorderRadius.circular(8),
          border: isActive ? null : Border.all(color: AppColors.lightGray),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.primaryBlack : AppColors.pureWhite,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final Map<String, dynamic> proposal;

  const _ProposalCard({required this.proposal});

  @override
  Widget build(BuildContext context) {
    final status = proposal['status'] ?? 'pending';
    final statusColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
            ? Colors.red
            : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proposal['title'] ?? 'Untitled Event',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${proposal['date'] ?? 'TBD'} • ${proposal['venue'] ?? 'TBD'}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status.toUpperCase(),
              style: AppTextStyles.bodySmall.copyWith(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
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
  final IconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha((0.2 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.headlineSmall),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

