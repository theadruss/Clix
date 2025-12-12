import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String _filter = 'all'; // all, students, coordinators, advisors, admins
  final TextEditingController _searchController = TextEditingController();

  // Mock users data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@campus.edu',
      'role': 'student',
      'status': 'active',
      'joinDate': '2024-09-01',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@campus.edu',
      'role': 'coordinator',
      'status': 'active',
      'joinDate': '2024-08-15',
    },
    {
      'id': '3',
      'name': 'Prof. Advisor',
      'email': 'advisor@campus.edu',
      'role': 'advisor',
      'status': 'active',
      'joinDate': '2024-07-01',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredUsers {
    var filtered = _users;
    
    if (_filter != 'all') {
      filtered = filtered.where((user) => user['role'] == _filter).toList();
    }
    
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((user) {
        return user['name'].toLowerCase().contains(query) ||
               user['email'].toLowerCase().contains(query);
      }).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('User Management', style: AppTextStyles.headlineSmall),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.mediumGray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterTab(label: 'All', filter: 'all', currentFilter: _filter, onTap: () => setState(() => _filter = 'all')),
                  const SizedBox(width: 8),
                  _FilterTab(label: 'Students', filter: 'student', currentFilter: _filter, onTap: () => setState(() => _filter = 'student')),
                  const SizedBox(width: 8),
                  _FilterTab(label: 'Coordinators', filter: 'coordinator', currentFilter: _filter, onTap: () => setState(() => _filter = 'coordinator')),
                  const SizedBox(width: 8),
                  _FilterTab(label: 'Advisors', filter: 'advisor', currentFilter: _filter, onTap: () => setState(() => _filter = 'advisor')),
                ],
              ),
            ),
          ),
          
          // Users List
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 64, color: AppColors.mediumGray),
                        const SizedBox(height: 16),
                        Text(
                          'No users found',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return _UserCard(
                        user: user,
                        onApprove: () => _handleUserAction(user, 'approve'),
                        onRemove: () => _handleUserAction(user, 'remove'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(Map<String, dynamic> user, String action) {
    if (action == 'approve') {
      setState(() {
        user['status'] = 'active';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user['name']} approved'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (action == 'remove') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkGray,
          title: Text('Remove User', style: AppTextStyles.headlineSmall),
          content: Text(
            'Are you sure you want to remove ${user['name']}?',
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
                  _users.remove(user);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${user['name']} removed'),
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

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onApprove;
  final VoidCallback onRemove;

  const _UserCard({
    required this.user,
    required this.onApprove,
    required this.onRemove,
  });

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'student':
        return 'Student';
      case 'coordinator':
        return 'Club Coordinator';
      case 'advisor':
        return 'Club Advisor';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }

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
            child: Icon(
              Icons.person_rounded,
              color: AppColors.darkGray,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'],
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getRoleDisplayName(user['role']),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.accentYellow,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user['status'] == 'active' ? Colors.green.withAlpha((0.2 * 255).toInt()) : Colors.orange.withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user['status'] == 'active' ? 'Active' : 'Pending',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: user['status'] == 'active' ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (user['status'] != 'active')
            IconButton(
              icon: Icon(Icons.check_circle_rounded, color: Colors.green),
              onPressed: onApprove,
              tooltip: 'Approve',
            ),
          IconButton(
            icon: Icon(Icons.delete_rounded, color: Colors.red),
            onPressed: onRemove,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}


