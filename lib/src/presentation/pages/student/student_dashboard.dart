import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/event/event_calendar.dart';
import '../../widgets/event/event_card.dart';
import '../../providers/auth_provider.dart';
import 'events_page.dart';
import 'club_page.dart';
import 'profile_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

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
      body: IndexedStack(
        index: _currentIndex,
        children: _buildPages(),
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
                  onTap: () => _onItemTapped(0),
                ),
                _BottomNavItem(
                  icon: Icons.event_rounded,
                  label: 'Events',
                  isActive: _currentIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _BottomNavItem(
                  icon: Icons.group_rounded,
                  label: 'Club',
                  isActive: _currentIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                _BottomNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: _currentIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      _HomeContent(recommendedEvents: _recommendedEvents),
      const EventsPage(),
      const ClubPage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

// Home Content - Your original student dashboard design
class _HomeContent extends StatelessWidget {
  final List<Map<String, dynamic>> recommendedEvents;

  const _HomeContent({required this.recommendedEvents});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user!;
    final TextEditingController searchController = TextEditingController();

    return SafeArea(
      child: Column(
        children: [
          // Header Section
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
                          'Welcome back, ${user.name}!',
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
                    controller: searchController,
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
                  const EventCalendar(),
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
                  _buildRecommendedEvents(),
                  const SizedBox(height: 80), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedEvents() {
    return Column(
      children: recommendedEvents.map((event) {
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
    );
  }
}

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
      ),
    );
  }
}