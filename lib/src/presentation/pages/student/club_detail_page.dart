import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import 'club_chat_page.dart'; // We'll create this next
import 'propose_event_page.dart'; // We'll create this too

class ClubDetailPage extends StatefulWidget {
  final Map<String, dynamic> club;
  final bool canProposeEvents;

  const ClubDetailPage({
    super.key,
    required this.club,
    this.canProposeEvents = false,
  });

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  int _selectedTab = 0; // 0: Events, 1: My Proposals

  // Mock events data
  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'id': '1',
      'title': 'Tech Workshop: Flutter Basics',
      'date': 'Oct 20, 2024',
      'time': '3:00 PM - 5:00 PM',
      'venue': 'CS Lab 101',
      'status': 'approved',
      'registered': true,
    },
    {
      'id': '2',
      'title': 'Hackathon 2024',
      'date': 'Oct 25, 2024',
      'time': '9:00 AM - 6:00 PM',
      'venue': 'Main Auditorium',
      'status': 'approved',
      'registered': false,
    },
    {
      'id': '3',
      'title': 'AI Seminar',
      'date': 'Nov 2, 2024',
      'time': '2:00 PM - 4:00 PM',
      'venue': 'Lecture Hall B',
      'status': 'pending',
      'registered': false,
    },
  ];

  // Mock proposals data (only visible if user can propose events)
  final List<Map<String, dynamic>> _myProposals = [
    {
      'id': 'p1',
      'title': 'Web Development Bootcamp',
      'date': 'Nov 10, 2024',
      'status': 'pending',
      'submittedDate': 'Oct 10, 2024',
      'reviewer': 'Club Advisor',
    },
    {
      'id': 'p2',
      'title': 'Mobile App Competition',
      'date': 'Nov 15, 2024',
      'status': 'approved',
      'submittedDate': 'Oct 5, 2024',
      'reviewer': 'Club Advisor',
    },
    {
      'id': 'p3',
      'title': 'Git & GitHub Workshop',
      'date': 'Oct 30, 2024',
      'status': 'rejected',
      'submittedDate': 'Oct 1, 2024',
      'reviewer': 'Club Advisor',
      'feedback': 'Already scheduled similar workshop for next month',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          widget.club['name'],
          style: AppTextStyles.headlineSmall,
        ),
        actions: [
          // Chat Icon
          IconButton(
            icon: const Icon(Icons.chat_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClubChatPage(club: widget.club),
                ),
              );
            },
          ),
          // Propose Event Button (only if user has permission)
          if (widget.canProposeEvents)
            IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProposeEventPage(club: widget.club),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Club Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkGray,
            ),
            child: Row(
              children: [
                // Club Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(widget.club['imageUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Club Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.club['name'],
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.club['description'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.mediumGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            color: AppColors.darkGray,
            child: Row(
              children: [
                _DetailTab(
                  title: 'Upcoming Events',
                  isActive: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                if (widget.canProposeEvents)
                  _DetailTab(
                    title: 'My Proposals',
                    isActive: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _selectedTab == 0
                ? _buildEventsList()
                : _buildProposalsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = _upcomingEvents[index];
        return _EventCard(event: event);
      },
    );
  }

  Widget _buildProposalsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _myProposals.length,
      itemBuilder: (context, index) {
        final proposal = _myProposals[index];
        return _ProposalCard(proposal: proposal);
      },
    );
  }
}

class _DetailTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _DetailTab({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? AppColors.accentYellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.accentYellow : AppColors.mediumGray,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event['title'],
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusBadge(status: event['status']),
            ],
          ),
          const SizedBox(height: 12),
          _EventDetailRow(icon: Icons.calendar_today_rounded, text: event['date']),
          _EventDetailRow(icon: Icons.access_time_rounded, text: event['time']),
          _EventDetailRow(icon: Icons.location_on_rounded, text: event['venue']),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Register for event
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: event['registered'] ? AppColors.mediumGray : AppColors.accentYellow,
                    foregroundColor: event['registered'] ? AppColors.pureWhite : AppColors.darkGray,
                  ),
                  child: Text(
                    event['registered'] ? 'Registered' : 'Register Now',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  final Map<String, dynamic> proposal;

  const _ProposalCard({required this.proposal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  proposal['title'],
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusBadge(status: proposal['status']),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Proposed for: ${proposal['date']}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Submitted: ${proposal['submittedDate']}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reviewer: ${proposal['reviewer']}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
          if (proposal['feedback'] != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Feedback: ${proposal['feedback']}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accentYellow,
                ),
              ),
            ),
          ],
        ],
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

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status) {
      case 'approved':
        backgroundColor = Colors.green;
        textColor = AppColors.pureWhite;
        statusText = 'Approved';
        break;
      case 'pending':
        backgroundColor = Colors.orange;
        textColor = AppColors.pureWhite;
        statusText = 'Pending';
        break;
      case 'rejected':
        backgroundColor = Colors.red;
        textColor = AppColors.pureWhite;
        statusText = 'Rejected';
        break;
      default:
        backgroundColor = AppColors.mediumGray;
        textColor = AppColors.pureWhite;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}