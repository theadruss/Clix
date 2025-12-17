import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/event/event_calendar.dart';
import '../../widgets/event/event_card.dart';
import '../../widgets/event/volunteer_card.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
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

  List<Widget> _buildPages(BuildContext context) {
    return [
      _HomeContent(context: context),
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

class _HomeContent extends StatefulWidget {
  final BuildContext context;

  const _HomeContent({required this.context});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).loadEvents();
    });
    _searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    setState(() {
      // Trigger rebuild to filter events from provider
    });
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showModalBottomSheet(
      context: widget.context,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(event['title'], style: AppTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text('by ${event['club']}', 
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentYellow)),
              const SizedBox(height: 16),
              _EventDetailRow(icon: Icons.calendar_today_rounded, text: event['date']),
              _EventDetailRow(icon: Icons.access_time_rounded, text: event['time']),
              _EventDetailRow(icon: Icons.location_on_rounded, text: event['venue']),
              const SizedBox(height: 16),
              Text(
                event['description'],
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final eventProv = Provider.of<EventProvider>(context, listen: false);
                        final authProv = Provider.of<AuthProvider>(context, listen: false);
                        setState(() {
                          event['isRegistered'] = !(event['isRegistered'] == true);
                          event['registeredCount'] = (event['registeredCount'] ?? 0) + (event['isRegistered'] == true ? 1 : -1);
                        });
                        if (event['isRegistered'] == true) {
                          await eventProv.registerForEvent(event['id'], userId: authProv.user?.id);
                        } else {
                          await eventProv.unregisterFromEvent(event['id'], userId: authProv.user?.id);
                        }
                        ScaffoldMessenger.of(widget.context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.accentYellow,
                            content: Text(
                              event['isRegistered'] ? 'Registered for ${event['title']}!' : 'Unregistered from ${event['title']}',
                              style: TextStyle(color: AppColors.darkGray),
                            ),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: event['isRegistered'] == true ? 
                            AppColors.mediumGray : AppColors.accentYellow,
                        foregroundColor: event['isRegistered'] == true ? 
                            AppColors.pureWhite : AppColors.darkGray,
                      ),
                      child: Text(event['isRegistered'] == true ? 'Registered' : 'Register Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user!;

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
                        onPressed: () {
                          Navigator.push(
                            widget.context, 
                            MaterialPageRoute(builder: (context) => const EventsPage())
                          );
                        },
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
                  const SizedBox(height: 24),
                  
                  // Volunteers Needed Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Volunteers Needed',
                        style: AppTextStyles.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(widget.context).showSnackBar(
                            const SnackBar(content: Text('Volunteer opportunities page coming soon')),
                          );
                        },
                        child: Text(
                          'See All',
                          style: AppTextStyles.link,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Volunteers Needed Cards
                  _buildVolunteerOpportunities(widget.context),
                  const SizedBox(height: 80), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // In _HomeContent class - update the _buildRecommendedEvents method:

Widget _buildRecommendedEvents() {
  return Consumer<EventProvider>(
    builder: (context, eventProvider, _) {
      final events = eventProvider.events.take(3).toList();
      
      if (eventProvider.isLoading) {
        return const Center(child: CircularProgressIndicator(color: Colors.yellow));
      }
      
      if (events.isEmpty) {
        return Center(
          child: Text(
            'No events available',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
        );
      }
      
      return Column(
        children: events.map((event) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: EventCard(
              title: event['title'],
              club: event['club'],
              date: event['date'],
              time: event['time'],
              venue: event['venue'],
              interestedCount: event['interestedCount'] ?? 0,
              imageUrl: event['imageUrl'],
              onTap: () {
                _showEventDetails(event);
              },
            ),
          );
        }).toList(),
      );
    },
  );
}

// Also update the _buildVolunteerOpportunities method:

Widget _buildVolunteerOpportunities(BuildContext context) {
  final List<Map<String, dynamic>> volunteerOpportunities = [
    {
      'eventTitle': 'Tech Symposium 2024',
      'clubName': 'Computer Society',
      'eventDate': 'Oct 15',
      'eventTime': '2:00 PM',
      'venue': 'Main Auditorium',
      'neededRoles': ['Registration Desk', 'Technical Support', 'Stage Manager'],
      'volunteersNeeded': 8,
      'currentVolunteers': 3,
      'hasApplied': false,
    },
  ];

  return Column(
    children: volunteerOpportunities.map((opportunity) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16), // Added margin
        child: VolunteerCard(
          eventTitle: opportunity['eventTitle'],
          clubName: opportunity['clubName'],
          eventDate: opportunity['eventDate'],
          eventTime: opportunity['eventTime'],
          venue: opportunity['venue'],
          neededRoles: opportunity['neededRoles'],
          volunteersNeeded: opportunity['volunteersNeeded'],
          currentVolunteers: opportunity['currentVolunteers'],
          hasApplied: opportunity['hasApplied'],
          onApply: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.accentYellow,
                content: Text(
                  'Applied for ${opportunity['eventTitle']} volunteer position!',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkGray),
                ),
              ),
            );
          },
        ),
      );
    }).toList(),
  );
}
}

class _EventDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventDetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.mediumGray),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
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
