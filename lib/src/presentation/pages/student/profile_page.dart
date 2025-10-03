import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    _StatItem(count: '12', label: 'Events\nAttended'),
                    _StatItem(count: '3', label: 'Clubs\nJoined'),
                    _StatItem(count: '8', label: 'Registered\nEvents'),
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
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.event_rounded,
                    title: 'My Events',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.group_rounded,
                    title: 'My Clubs',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.volunteer_activism_rounded,
                    title: 'Volunteering',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  _ProfileMenuItem(
                    icon: Icons.help_rounded,
                    title: 'Help & Support',
                    onTap: () {},
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