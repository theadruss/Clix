import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../../widgets/event/event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredEvents = [];
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _filteredEvents = MockDataService.getEventsForUser();
    _searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEvents = MockDataService.getEventsForUser();
      } else {
        _filteredEvents = MockDataService.searchEvents(query);
      }
      
      // Apply category filter
      if (_selectedFilter != 'all') {
        _filteredEvents = _filteredEvents.where((event) => event['category'] == _selectedFilter).toList();
      }
    });
  }

  void _showEventDetails(Map<String, dynamic> event) {
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
                      onPressed: () {
                        setState(() {
                          if (event['isRegistered'] == true) {
                            MockDataService.unregisterFromEvent(event['id']);
                          } else {
                            MockDataService.registerForEvent(event['id']);
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.accentYellow,
                            content: Text(
                              event['isRegistered'] ? 
                              'Unregistered from ${event['title']}' : 
                              'Registered for ${event['title']}!',
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
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'All Events',
          style: AppTextStyles.headlineSmall,
        ),
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
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.mediumGray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedFilter == 'all',
                  onTap: () => _setFilter('all'),
                ),
                _FilterChip(
                  label: 'Technology',
                  isSelected: _selectedFilter == 'Technology',
                  onTap: () => _setFilter('Technology'),
                ),
                _FilterChip(
                  label: 'Cultural',
                  isSelected: _selectedFilter == 'Cultural',
                  onTap: () => _setFilter('Cultural'),
                ),
                _FilterChip(
                  label: 'Business',
                  isSelected: _selectedFilter == 'Business',
                  onTap: () => _setFilter('Business'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search or filter',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
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
                          _showEventDetails(event);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _setFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterEvents();
    });
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentYellow : AppColors.darkGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accentYellow : AppColors.mediumGray,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? AppColors.darkGray : AppColors.mediumGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
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