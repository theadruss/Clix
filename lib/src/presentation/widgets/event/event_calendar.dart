import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  DateTime _selectedDate = DateTime.now();
  final List<String> _days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> _filters = ['Today', 'Tomorrow', 'This Week', 'Month'];

  int _selectedFilter = 0;

  // Mock events data with dates
  final Map<String, List<Map<String, dynamic>>> _eventsByDate = {
    '2024-10-15': [
      {'title': 'Tech Symposium', 'type': 'conference'},
    ],
    '2024-10-18': [
      {'title': 'Cultural Fest Auditions', 'type': 'cultural'},
    ],
    '2024-10-20': [
      {'title': 'Sports Tournament', 'type': 'sports'},
      {'title': 'Workshop: Flutter Basics', 'type': 'workshop'},
    ],
    '2024-10-22': [
      {'title': 'Startup Pitch Competition', 'type': 'competition'},
    ],
    '2024-10-25': [
      {'title': 'Alumni Meet', 'type': 'networking'},
    ],
    '2024-10-28': [
      {'title': 'Hackathon 2024', 'type': 'competition'},
    ],
  };

  List<DateTime> _getDaysInMonth(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    final last = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];
    
    // Add empty days for the first week
    for (int i = 0; i < first.weekday; i++) {
      days.add(DateTime(0));
    }
    
    // Add all days of the month
    for (int i = 1; i <= last.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    
    return days;
  }

  bool _hasEvents(DateTime date) {
    if (date.year == 0) return false; // Empty day
    
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _eventsByDate.containsKey(dateKey);
  }

  int _getEventCount(DateTime date) {
    if (date.year == 0) return 0;
    
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _eventsByDate[dateKey]?.length ?? 0;
  }

  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    if (date.year == 0) return [];
    
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return _eventsByDate[dateKey] ?? [];
  }

  void _showEventDetails(BuildContext context, DateTime date, List<Map<String, dynamic>> events) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Events on ${_getMonthName(date.month)} ${date.day}',
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.pureWhite),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _EventTypeIndicator(type: event['type']),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        event['title'],
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTextStyles.buttonMedium.copyWith(color: AppColors.accentYellow),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_selectedDate);
    final monthName = _getMonthName(_selectedDate.month);
    final year = _selectedDate.year;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Date Filters
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedFilter == index 
                            ? AppColors.accentYellow 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedFilter == index 
                              ? AppColors.accentYellow 
                              : AppColors.lightGray,
                        ),
                      ),
                      child: Text(
                        _filters[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _selectedFilter == index 
                              ? AppColors.darkGray 
                              : AppColors.pureWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Month Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$monthName $year',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                      });
                    },
                    icon: Icon(Icons.chevron_left, color: AppColors.accentYellow),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                      });
                    },
                    icon: Icon(Icons.chevron_right, color: AppColors.accentYellow),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Day Headers
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 7,
            itemBuilder: (context, index) {
              return Center(
                child: Text(
                  _days[index],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          // Calendar Days
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth.length,
            itemBuilder: (context, index) {
              final day = daysInMonth[index];
              final isCurrentMonth = day.year != 0;
              final isToday = isCurrentMonth && 
                  day.day == DateTime.now().day && 
                  day.month == DateTime.now().month &&
                  day.year == DateTime.now().year;
              final isSelected = isCurrentMonth && 
                  day.day == _selectedDate.day && 
                  day.month == _selectedDate.month;
              final hasEvents = _hasEvents(day);
              final eventCount = _getEventCount(day);
              final events = _getEventsForDate(day);

              if (!isCurrentMonth) {
                return const SizedBox(); // Empty day
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                  if (hasEvents) {
                    _showEventDetails(context, day, events);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentYellow : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday 
                        ? Border.all(color: AppColors.accentYellow, width: 1)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: isSelected ? AppColors.darkGray : AppColors.pureWhite,
                                fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            if (hasEvents) ...[
                              const SizedBox(height: 2),
                              // Event indicator dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < (eventCount > 3 ? 3 : eventCount); i++)
                                    Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.darkGray : AppColors.accentYellow,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  if (eventCount > 3)
                                    Text(
                                      '+${eventCount - 3}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: isSelected ? AppColors.darkGray : AppColors.accentYellow,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Badge for multiple events
                      if (eventCount > 1 && !isSelected)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$eventCount',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.darkGray,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }
}

class _EventTypeIndicator extends StatelessWidget {
  final String type;

  const _EventTypeIndicator({required this.type});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (type) {
      case 'conference':
        color = Colors.blue;
        icon = Icons.school_rounded;
        break;
      case 'cultural':
        color = Colors.purple;
        icon = Icons.music_note_rounded;
        break;
      case 'sports':
        color = Colors.green;
        icon = Icons.sports_soccer_rounded;
        break;
      case 'workshop':
        color = Colors.orange;
        icon = Icons.work_rounded;
        break;
      case 'competition':
        color = Colors.red;
        icon = Icons.emoji_events_rounded;
        break;
      case 'networking':
        color = Colors.teal;
        icon = Icons.people_rounded;
        break;
      default:
        color = AppColors.accentYellow;
        icon = Icons.event_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }
}