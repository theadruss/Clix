import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/event/event_card.dart';
import '../../providers/event_provider.dart';
import 'event_details_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

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
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, _) {
          // Filter events based on search and category
          final filteredEvents = eventProvider.events.where((event) {
            final query = _searchController.text.toLowerCase();
            final matchesQuery = event['title'].toString().toLowerCase().contains(query);
            final matchesFilter = _selectedFilter == 'all' || event['category'] == _selectedFilter;
            return matchesQuery && matchesFilter;
          }).toList();

          return Column(
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
                child: eventProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.yellow),
                      )
                    : filteredEvents.isEmpty
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
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];
                              return EventCard(
                                title: event['title'],
                                club: event['club'],
                                date: event['date'],
                                time: event['time'],
                                venue: event['venue'],
                                interestedCount: event['interestedCount'] ?? 0,
                                imageUrl: event['imageUrl'],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(event: event),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          );
        },
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
