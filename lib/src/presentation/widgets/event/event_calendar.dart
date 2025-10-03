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

              if (!isCurrentMonth) {
                return const SizedBox(); // Empty day
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentYellow : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday 
                        ? Border.all(color: AppColors.accentYellow, width: 1)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected ? AppColors.darkGray : AppColors.pureWhite,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
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