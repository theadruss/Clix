import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedPeriod = 'month'; // month, quarter, year

  @override
  Widget build(BuildContext context) {
    final stats = MockDataService.adminStats;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Analytics & Reports', style: AppTextStyles.headlineSmall),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded),
            color: AppColors.darkGray,
            onSelected: (value) {
              if (value == 'export') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting report...')),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'export', child: Text('Export Report', style: AppTextStyles.bodyMedium)),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Row(
              children: [
                _PeriodChip(label: 'Month', period: 'month', selected: _selectedPeriod, onTap: () => setState(() => _selectedPeriod = 'month')),
                const SizedBox(width: 8),
                _PeriodChip(label: 'Quarter', period: 'quarter', selected: _selectedPeriod, onTap: () => setState(() => _selectedPeriod = 'quarter')),
                const SizedBox(width: 8),
                _PeriodChip(label: 'Year', period: 'year', selected: _selectedPeriod, onTap: () => setState(() => _selectedPeriod = 'year')),
              ],
            ),
            const SizedBox(height: 24),
            
            // Key Metrics
            Text('Key Metrics', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _MetricCard(
                  title: 'Total Events',
                  value: stats['totalEvents'].toString(),
                  icon: Icons.event_rounded,
                  color: Colors.blue,
                  change: '+12%',
                ),
                _MetricCard(
                  title: 'Active Users',
                  value: stats['totalStudents'].toString(),
                  icon: Icons.people_rounded,
                  color: Colors.green,
                  change: '+8%',
                ),
                _MetricCard(
                  title: 'Revenue',
                  value: '\$${stats['revenue']}',
                  icon: Icons.attach_money_rounded,
                  color: Colors.orange,
                  change: '+24%',
                ),
                _MetricCard(
                  title: 'Active Clubs',
                  value: stats['activeClubs'].toString(),
                  icon: Icons.group_rounded,
                  color: Colors.purple,
                  change: '+2',
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Event Participation
            Text('Event Participation', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _AnalyticsCard(
              title: 'Average Participation Rate',
              value: '78%',
              description: 'Students participating in events',
              icon: Icons.trending_up_rounded,
              color: Colors.green,
            ),
            _AnalyticsCard(
              title: 'Most Popular Category',
              value: 'Technology',
              description: 'Highest event registrations',
              icon: Icons.category_rounded,
              color: Colors.blue,
            ),
            _AnalyticsCard(
              title: 'Peak Event Day',
              value: 'Friday',
              description: 'Most events scheduled on',
              icon: Icons.calendar_today_rounded,
              color: Colors.orange,
            ),
            
            const SizedBox(height: 24),
            
            // Financial Overview
            Text('Financial Overview', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _AnalyticsCard(
              title: 'Total Revenue',
              value: '\$${stats['revenue']}',
              description: 'Revenue from event registrations',
              icon: Icons.attach_money_rounded,
              color: Colors.green,
            ),
            _AnalyticsCard(
              title: 'Average Event Fee',
              value: '\$15.50',
              description: 'Average registration fee per event',
              icon: Icons.payments_rounded,
              color: Colors.blue,
            ),
            
            const SizedBox(height: 24),
            
            // Club Performance
            Text('Club Performance', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            ...MockDataService.clubs.take(3).map((club) => _ClubPerformanceCard(club: club)),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final String period;
  final String selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.period,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selected == period;
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha((0.2 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 24,
              color: AppColors.pureWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
  });

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
              color: color.withAlpha((0.2 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.accentYellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubPerformanceCard extends StatelessWidget {
  final Map<String, dynamic> club;

  const _ClubPerformanceCard({required this.club});

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
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(club['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club['name'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${club['upcomingEvents']} events • ${club['memberCount']} members',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '78%',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.accentYellow,
                ),
              ),
              Text(
                'Participation',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


