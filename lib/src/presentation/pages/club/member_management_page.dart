import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class MemberManagementPage extends StatefulWidget {
  const MemberManagementPage({super.key});

  @override
  State<MemberManagementPage> createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends State<MemberManagementPage> {
  final List<Map<String, dynamic>> _members = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@campus.edu',
      'role': 'student',
      'profileImage': null,
      'joinDate': '2024-09-01',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@campus.edu',
      'role': 'club_coordinator',
      'profileImage': null,
      'joinDate': '2024-08-15',
    },
    {
      'id': '3',
      'name': 'Dr. Robert Brown',
      'email': 'robert@campus.edu',
      'role': 'club_advisor',
      'profileImage': null,
      'joinDate': '2024-07-20',
    },
    {
      'id': '4',
      'name': 'Mike Johnson',
      'email': 'mike@campus.edu',
      'role': 'student',
      'profileImage': null,
      'joinDate': '2024-09-10',
    },
  ];

  void _showMemberOptions(Map<String, dynamic> member) {
    // Removed unused variable isAdvisor
    final bool isCoordinator = member['role'] == 'club_coordinator';
    final bool isStudent = member['role'] == 'student';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.mediumGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Member Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.lightGray,
                    child: member['profileImage'] != null
                        ? Image.network(member['profileImage']!)
                        : Icon(Icons.person_rounded, color: AppColors.mediumGray),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member['name'], style: AppTextStyles.headlineSmall),
                        Text(member['email'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
                        const SizedBox(height: 4),
                        _RoleBadge(role: member['role']),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Action Buttons
              if (isStudent) ...[
                _ActionButton(
                  icon: Icons.star_rounded,
                  title: 'Make Coordinator',
                  onTap: () => _makeCoordinator(member),
                ),
                const SizedBox(height: 12),
              ],
              
              if (isCoordinator) ...[
                _ActionButton(
                  icon: Icons.person_remove_rounded,
                  title: 'Remove Coordinator',
                  onTap: () => _removeCoordinator(member),
                ),
                const SizedBox(height: 12),
              ],
              
              _ActionButton(
                icon: Icons.remove_circle_outline_rounded,
                title: 'Remove from Club',
                onTap: () => _removeMember(member),
                isDestructive: true,
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Close', style: AppTextStyles.buttonMedium),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _makeCoordinator(Map<String, dynamic> member) {
    setState(() {
      member['role'] = 'club_coordinator';
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member['name']} is now a coordinator'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _removeCoordinator(Map<String, dynamic> member) {
    setState(() {
      member['role'] = 'student';
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member['name']} is no longer a coordinator'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _removeMember(Map<String, dynamic> member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text('Remove Member', style: AppTextStyles.headlineSmall),
        content: Text(
          'Are you sure you want to remove ${member['name']} from the club?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.buttonMedium.copyWith(color: AppColors.mediumGray)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _members.remove(member);
              });
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${member['name']} removed from club'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Remove', style: AppTextStyles.buttonMedium.copyWith(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Removed unused function _getRoleDisplayName

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Club Members', style: AppTextStyles.headlineSmall),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return _MemberCard(
            member: member,
            onTap: () => _showMemberOptions(member),
          );
        },
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final Map<String, dynamic> member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkGray,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.lightGray,
          backgroundImage: member['profileImage'] != null 
              ? NetworkImage(member['profileImage']!)
              : null,
          child: member['profileImage'] == null
              ? Icon(Icons.person_rounded, color: AppColors.mediumGray)
              : null,
        ),
        title: Text(member['name'], style: AppTextStyles.bodyMedium),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member['email'], style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
            const SizedBox(height: 4),
            _RoleBadge(role: member['role']),
          ],
        ),
        trailing: Icon(Icons.more_vert_rounded, color: AppColors.mediumGray),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    String displayText;

    switch (role) {
      case 'club_advisor':
        backgroundColor = Colors.blue;
        displayText = 'Advisor';
        break;
      case 'club_coordinator':
        backgroundColor = Colors.green;
        displayText = 'Coordinator';
        break;
      case 'student':
        backgroundColor = AppColors.mediumGray;
        displayText = 'Member';
        break;
      default:
        backgroundColor = AppColors.mediumGray;
        displayText = role;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.pureWhite,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.accentYellow,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDestructive ? Colors.red : AppColors.pureWhite,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: isDestructive ? Colors.red : AppColors.mediumGray,
      ),
    );
  }
}
