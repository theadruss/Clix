import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/event/event_calendar.dart';
import '../../widgets/event/event_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final TextEditingController _searchController = TextEditingController();

  // Mock data for events
  final List<Map<String, dynamic>> _recommendedEvents = [
    {
      'title': 'Tech Symposium 2024',
      'club': 'Computer Society',
      'date': 'Oct 15',
      'time': '2:00 PM',
      'venue': 'Main Auditorium',
      'interestedCount': 124,
      'imageUrl': 'https://picsum.photos/400/200?random=1',
    },
    {
      'title': 'Cultural Fest Auditions',
      'club': 'Cultural Committee',
      'date': 'Oct 18',
      'time': '4:00 PM',
      'venue': 'Arts Block',
      'interestedCount': 89,
      'imageUrl': 'https://picsum.photos/400/200?random=2',
    },
    {
      'title': 'Startup Pitch Competition',
      'club': 'Entrepreneurship Cell',
      'date': 'Oct 22',
      'time': '10:00 AM',
      'venue': 'Business School',
      'interestedCount': 67,
      'imageUrl': 'https://picsum.photos/400/200?random=3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section (Fixed height)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CampusConnect',
                            style: AppTextStyles.headlineLarge.copyWith(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Welcome back!',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.darkGray,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                      decoration: InputDecoration(
                        hintText: 'Search for events...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                        prefixIcon: Icon(Icons.search_rounded, color: AppColors.mediumGray),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Calendar Section
                    EventCalendar(),
                    const SizedBox(height: 24),
                    // Recommended Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommended For You',
                          style: AppTextStyles.headlineSmall,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: AppTextStyles.link,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Recommended Events
                    Column(
                      children: _recommendedEvents.map((event) {
                        return EventCard(
                          title: event['title'],
                          club: event['club'],
                          date: event['date'],
                          time: event['time'],
                          venue: event['venue'],
                          interestedCount: event['interestedCount'],
                          imageUrl: event['imageUrl'],
                          onTap: () {
                            // TODO: Navigate to event details
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 80), // Space for bottom navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
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
                _BottomNavItem(icon: Icons.home_rounded, label: 'Home', isActive: true),
                _BottomNavItem(icon: Icons.calendar_today_rounded, label: 'Calendar', isActive: false),
                _BottomNavItem(icon: Icons.explore_rounded, label: 'Explore', isActive: false),
                _BottomNavItem(icon: Icons.person_rounded, label: 'Profile', isActive: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}