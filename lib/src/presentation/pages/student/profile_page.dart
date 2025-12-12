import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _calculateEventsAttended() {
    return MockDataService.getEventsForUser().where((event) => event['isRegistered'] == true).length;
  }

  int _calculateClubsJoined() {
    return MockDataService.getClubsForUser().where((club) => club['isMember'] == true).length;
  }

  int _calculateRegisteredEvents() {
    return MockDataService.getEventsForUser().where((event) => event['isRegistered'] == true).length;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user!;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Profile Picture
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentYellow,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.accentYellow,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Statistics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(count: _calculateEventsAttended().toString(), label: 'Events\nAttended'),
                    _StatItem(count: _calculateClubsJoined().toString(), label: 'Clubs\nJoined'),
                    _StatItem(count: _calculateRegisteredEvents().toString(), label: 'Registered\nEvents'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Items
              Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.edit_rounded,
                    title: 'Edit Profile',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.accentYellow,
                          content: Text(
                            'Edit Profile feature coming soon!',
                            style: TextStyle(color: AppColors.darkGray),
                          ),
                        ),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.event_rounded,
                    title: 'My Events',
                    onTap: () {
                      final myEvents = MockDataService.getEventsForUser().where((event) => event['isRegistered'] == true).toList();
                      _showMyEvents(myEvents);
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.group_rounded,
                    title: 'My Clubs',
                    onTap: () {
                      final myClubs = MockDataService.getClubsForUser().where((club) => club['isMember'] == true).toList();
                      _showMyClubs(myClubs);
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.volunteer_activism_rounded,
                    title: 'Volunteering',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.accentYellow,
                          content: Text(
                            'Volunteering feature coming soon!',
                            style: TextStyle(color: AppColors.darkGray),
                          ),
                        ),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.accentYellow,
                          content: Text(
                            'Settings feature coming soon!',
                            style: TextStyle(color: AppColors.darkGray),
                          ),
                        ),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.help_rounded,
                    title: 'Help & Support',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.accentYellow,
                          content: Text(
                            'Help & Support feature coming soon!',
                            style: TextStyle(color: AppColors.darkGray),
                          ),
                        ),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    onTap: () => authProvider.logout(),
                    isLogout: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMyEvents(List<Map<String, dynamic>> events) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkGray,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.mediumGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'My Registered Events',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 16),
              if (events.isEmpty)
                Column(
                  children: [
                    Icon(
                      Icons.event_busy_rounded,
                      size: 64,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No events registered yet',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                )
              else
                ...events.map((event) => ListTile(
                  leading: Icon(Icons.event_rounded, color: AppColors.accentYellow),
                  title: Text(event['title'], style: AppTextStyles.bodyMedium),
                  subtitle: Text('${event['date']} • ${event['club']}', 
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                )).toList(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMyClubs(List<Map<String, dynamic>> clubs) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkGray,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.mediumGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'My Clubs',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 16),
              if (clubs.isEmpty)
                Column(
                  children: [
                    Icon(
                      Icons.group_off_rounded,
                      size: 64,
                      color: AppColors.mediumGray,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Not a member of any clubs yet',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                )
              else
                ...clubs.map((club) => ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(club['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(club['name'], style: AppTextStyles.bodyMedium),
                  subtitle: Text('${club['memberCount']} members', 
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                )).toList(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 20,
            color: AppColors.accentYellow,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.mediumGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : AppColors.accentYellow,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isLogout ? Colors.red : AppColors.pureWhite,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: isLogout ? Colors.red : AppColors.mediumGray,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: AppColors.darkGray,
      ),
    );
  }
}
