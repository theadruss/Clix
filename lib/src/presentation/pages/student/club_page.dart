import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../providers/club_provider.dart';
import '../student/club_detail_page.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClubProvider>(context, listen: false).loadClubs();
    });
    _searchController.addListener(_filterClubs);
  }

  void _filterClubs() {
    setState(() {
      // Trigger rebuild to filter clubs from provider
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
      body: Consumer<ClubProvider>(
        builder: (context, clubProvider, _) {
          final query = _searchController.text.toLowerCase();
          final filteredClubs = clubProvider.clubs.where((club) {
            return club['name'].toString().toLowerCase().contains(query);
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
                child: clubProvider.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
                    : filteredClubs.isEmpty
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
                            itemCount: filteredClubs.length,
                            itemBuilder: (context, index) {
                              final club = filteredClubs[index];
                              return _ClubCard(club: club);
                            },
                          ),
              ),
            ],
          );
        },
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
