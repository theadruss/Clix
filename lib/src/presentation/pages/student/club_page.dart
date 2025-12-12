import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import '../student/club_detail_page.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredClubs = [];

  @override
  void initState() {
    super.initState();
    _filteredClubs = MockDataService.getClubsForUser();
    _searchController.addListener(_filterClubs);
  }

  void _filterClubs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredClubs = MockDataService.getClubsForUser();
      } else {
        _filteredClubs = MockDataService.searchClubs(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          'Clubs',
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
                  hintText: 'Search clubs...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.mediumGray),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          // Clubs List
          Expanded(
            child: _filteredClubs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_off_rounded,
                          size: 64,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No clubs found',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredClubs.length,
                    itemBuilder: (context, index) {
                      final club = _filteredClubs[index];
                      return _ClubCard(club: club);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  final Map<String, dynamic> club;

  const _ClubCard({required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(club['imageUrl']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          club['name'],
          style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              club['description'],
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mediumGray,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people_rounded, size: 14, color: AppColors.accentYellow),
                const SizedBox(width: 4),
                Text(
                  '${club['memberCount']} members',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accentYellow,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.event_rounded, size: 14, color: AppColors.accentYellow),
                const SizedBox(width: 4),
                Text(
                  '${club['upcomingEvents']} events',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accentYellow,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: club['isMember'] == true ? AppColors.accentYellow : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: club['isMember'] == true ? AppColors.accentYellow : AppColors.mediumGray,
            ),
          ),
          child: Text(
            club['isMember'] == true ? 'Joined' : 'Join',
            style: AppTextStyles.bodySmall.copyWith(
              color: club['isMember'] == true ? AppColors.darkGray : AppColors.mediumGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailPage(
                club: club,
                canProposeEvents: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
