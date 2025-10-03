import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/event/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Upcoming', 'Registered', 'Past'];

  // Mock events data
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Tech Symposium 2024',
      'club': 'Computer Society',
      'date': 'Oct 15',
      'time': '2:00 PM',
      'venue': 'Main Auditorium',
      'interestedCount': 124,
      'imageUrl': 'https://picsum.photos/400/200?random=1',
      'isRegistered': true,
    },
    {
      'title': 'Cultural Fest Auditions',
      'club': 'Cultural Committee',
      'date': 'Oct 18',
      'time': '4:00 PM',
      'venue': 'Arts Block',
      'interestedCount': 89,
      'imageUrl': 'https://picsum.photos/400/200?random=2',
      'isRegistered': false,
    },
    {
      'title': 'Startup Pitch Competition',
      'club': 'Entrepreneurship Cell',
      'date': 'Oct 22',
      'time': '10:00 AM',
      'venue': 'Business School',
      'interestedCount': 67,
      'imageUrl': 'https://picsum.photos/400/200?random=3',
      'isRegistered': true,
    },
    {
      'title': 'Sports Fest Opening',
      'club': 'Sports Committee',
      'date': 'Oct 25',
      'time': '9:00 AM',
      'venue': 'Main Ground',
      'interestedCount': 203,
      'imageUrl': 'https://picsum.photos/400/200?random=4',
      'isRegistered': false,
    },
    {
      'title': 'Alumni Meet 2024',
      'club': 'Alumni Association',
      'date': 'Oct 28',
      'time': '6:00 PM',
      'venue': 'Convocation Hall',
      'interestedCount': 156,
      'imageUrl': 'https://picsum.photos/400/200?random=5',
      'isRegistered': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredEvents {
    switch (_selectedFilter) {
      case 1: // Upcoming
        return _events.where((event) => !event['isRegistered']).toList();
      case 2: // Registered
        return _events.where((event) => event['isRegistered']).toList();
      case 3: // Past
        return _events.sublist(0, 2); // Mock past events
      default: // All
        return _events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Events',
          style: AppTextStyles.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        _filters[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _selectedFilter == index 
                              ? AppColors.darkGray 
                              : AppColors.pureWhite,
                        ),
                      ),
                      selected: _selectedFilter == index,
                      selectedColor: AppColors.accentYellow,
                      backgroundColor: AppColors.lightGray,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = selected ? index : 0;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Events List
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy_rounded,
                          size: 64,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = _filteredEvents[index];
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}