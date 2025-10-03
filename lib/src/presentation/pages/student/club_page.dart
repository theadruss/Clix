import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import 'club_detail_page.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'My Clubs', 'Tech', 'Cultural', 'Sports', 'Academic'];

  final List<Map<String, dynamic>> _clubs = [
    {
      'id': '1',
      'name': 'Computer Society',
      'category': 'Tech',
      'members': 245,
      'events': 12,
      'imageUrl': 'https://picsum.photos/300/200?random=10',
      'isJoined': true,
      'description': 'The premier tech club for coding enthusiasts and developers.',
      'upcomingEvent': 'Tech Workshop - Oct 20',
    },
    {
      'id': '2',
      'name': 'Cultural Committee',
      'category': 'Cultural',
      'members': 189,
      'events': 8,
      'imageUrl': 'https://picsum.photos/300/200?random=11',
      'isJoined': false,
      'description': 'Celebrating arts, music, dance and cultural diversity.',
      'upcomingEvent': 'Cultural Fest - Oct 25',
    },
    {
      'id': '3',
      'name': 'Sports Club',
      'category': 'Sports',
      'members': 312,
      'events': 15,
      'imageUrl': 'https://picsum.photos/300/200?random=12',
      'isJoined': false,
      'description': 'Promoting sports and physical activities on campus.',
      'upcomingEvent': 'Sports Tournament - Oct 18',
    },
    {
      'id': '4',
      'name': 'Robotics Club',
      'category': 'Tech',
      'members': 134,
      'events': 6,
      'imageUrl': 'https://picsum.photos/300/200?random=13',
      'isJoined': true,
      'description': 'Building the future with robotics and automation.',
      'upcomingEvent': 'Robotics Competition - Nov 5',
    },
    {
      'id': '5',
      'name': 'Drama Society',
      'category': 'Cultural',
      'members': 98,
      'events': 5,
      'imageUrl': 'https://picsum.photos/300/200?random=14',
      'isJoined': false,
      'description': 'Where actors and playwrights come together.',
      'upcomingEvent': 'Play Auditions - Oct 22',
    },
    {
      'id': '6',
      'name': 'Entrepreneurship Cell',
      'category': 'Academic',
      'members': 167,
      'events': 9,
      'imageUrl': 'https://picsum.photos/300/200?random=15',
      'isJoined': true,
      'description': 'Fostering innovation and startup culture.',
      'upcomingEvent': 'Startup Pitch - Oct 28',
    },
  ];

  List<Map<String, dynamic>> get _filteredClubs {
    switch (_selectedCategory) {
      case 1: // My Clubs
        return _clubs.where((club) => club['isJoined'] == true).toList();
      case 2: // Tech
        return _clubs.where((club) => club['category'] == 'Tech').toList();
      case 3: // Cultural
        return _clubs.where((club) => club['category'] == 'Cultural').toList();
      case 4: // Sports
        return _clubs.where((club) => club['category'] == 'Sports').toList();
      case 5: // Academic
        return _clubs.where((club) => club['category'] == 'Academic').toList();
      default: // All
        return _clubs;
    }
  }

  void _toggleJoinClub(String clubId) {
    setState(() {
      final club = _clubs.firstWhere((c) => c['id'] == clubId);
      club['isJoined'] = !club['isJoined'];
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        _categories[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _selectedCategory == index 
                              ? AppColors.darkGray 
                              : AppColors.pureWhite,
                        ),
                      ),
                      selected: _selectedCategory == index,
                      selectedColor: AppColors.accentYellow,
                      backgroundColor: AppColors.lightGray,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? index : 0;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Clubs Grid
          Expanded(
            child: _filteredClubs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedCategory == 1 ? Icons.group_off_rounded : Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory == 1 ? 'No clubs joined yet' : 'No clubs found',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                        if (_selectedCategory == 1) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Join clubs to see them here',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredClubs.length,
                    itemBuilder: (context, index) {
                      final club = _filteredClubs[index];
                      return _ClubCard(
                        club: club,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClubDetailPage(
                                club: club,
                                canProposeEvents: club['isJoined'], // Users can propose events only if they've joined the club
                              ),
                            ),
                          );
                        },
                        onJoinToggle: () => _toggleJoinClub(club['id']),
                      );
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
  final VoidCallback onTap;
  final VoidCallback onJoinToggle;

  const _ClubCard({
    required this.club,
    required this.onTap,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                club['imageUrl'],
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 90,
                    color: AppColors.lightGray,
                    child: Icon(
                      Icons.group_rounded,
                      color: AppColors.mediumGray,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            // Club Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club['name'],
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club['category'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentYellow,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: 12,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${club['members']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.event_rounded,
                          size: 12,
                          color: AppColors.mediumGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${club['events']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onJoinToggle,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: club['isJoined'] ? AppColors.accentYellow : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: club['isJoined'] ? AppColors.accentYellow : AppColors.lightGray,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            club['isJoined'] ? 'Joined' : 'Join',
                            style: AppTextStyles.buttonSmall.copyWith(
                              color: club['isJoined'] ? AppColors.darkGray : AppColors.pureWhite,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}