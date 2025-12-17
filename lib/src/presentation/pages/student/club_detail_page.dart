import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import 'club_chat_page.dart';
import 'propose_event_page.dart';
import '../volunteer/volunteer_management_page.dart';

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

  // Mock events data - filter to show only this club's events
  List<Map<String, dynamic>> get _upcomingEvents {
    return MockDataService.getEventsForUser().where((event) => event['club'] == widget.club['name']).toList();
  }

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

  void _toggleClubMembership() {
    final wasMember = widget.club['isMember'] == true;
    
    setState(() {
      if (wasMember) {
        MockDataService.leaveClub(widget.club['id']);
        widget.club['isMember'] = false;
      } else {
        MockDataService.joinClub(widget.club['id']);
        widget.club['isMember'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.accentYellow,
        content: Text(
          wasMember ? 
          'Left ${widget.club['name']}' : 
          'Joined ${widget.club['name']}!',
          style: TextStyle(color: AppColors.darkGray),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRole = widget.club['userRole'] as String?;
    final roleDisplayName = userRole != null ? MockDataService.getUserRoleDisplayName(userRole) : 'Member';

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          widget.club['name'],
          style: AppTextStyles.headlineSmall,
      ),
      actions: [
        if (userRole != null && userRole != 'member') ...[
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
          if (['coordinator', 'advisor'].contains(userRole))
            IconButton(
              icon: const Icon(Icons.volunteer_activism_rounded),
              onPressed: _showVolunteerManagementOptions,
            ),
          if (['coordinator', 'subgroup_head', 'advisor'].contains(userRole))
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
      ],
    ),
    body: Column(
      children: [
        // Enhanced Club Header with Role
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.darkGray),
          child: Column(
            children: [
              Row(
                children: [
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
                        if (userRole != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow.withAlpha((0.2 * 255).toInt()),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.accentYellow),
                            ),
                            child: Text(
                              roleDisplayName,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.accentYellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _ClubStatItem(count: widget.club['memberCount'].toString(), label: 'Members'),
                  _ClubStatItem(count: widget.club['upcomingEvents'].toString(), label: 'Events'),
                  if (widget.club['subgroups'] != null)
                    _ClubStatItem(count: widget.club['subgroups'].length.toString(), label: 'Subgroups'),
                  const Spacer(),
                  if (widget.club['isMember'] != true)
                    ElevatedButton(
                      onPressed: _toggleClubMembership,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentYellow,
                        foregroundColor: AppColors.darkGray,
                      ),
                      child: const Text('Join Club'),
                    )
                  else
                    OutlinedButton(
                      onPressed: _toggleClubMembership,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.mediumGray,
                        side: BorderSide(color: AppColors.mediumGray),
                      ),
                      child: const Text('Leave Club'),
                    ),
                ],
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
    if (_upcomingEvents.isEmpty) {
      return Center(
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
              'No upcoming events',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingEvents.length,
      itemBuilder: (context, index) {
        final event = _upcomingEvents[index];
        return _EventCard(
          event: event,
          onManageVolunteers: widget.canProposeEvents
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VolunteerManagementPage(event: event),
                    ),
                  );
                }
              : null,
          onRegisterChanged: () {
            setState(() {}); // Refresh the UI
          },
        );
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

  void _showVolunteerManagementOptions() {
    final eventsNeedingVolunteers = _upcomingEvents.where((event) => event['needsVolunteers'] == true).toList();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.mediumGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Manage Volunteers',
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              if (eventsNeedingVolunteers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 48,
                        color: AppColors.mediumGray,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No events need volunteers',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...eventsNeedingVolunteers.map((event) {
                  return ListTile(
                    leading: Icon(
                      Icons.event_rounded,
                      color: AppColors.accentYellow,
                    ),
                    title: Text(
                      event['title'],
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                    ),
                    subtitle: Text(
                      '${event['date']} • ${event['venue']}',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.mediumGray,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerManagementPage(event: event),
                        ),
                      );
                    },
                  );
                }).toList(),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _ClubStatItem extends StatelessWidget {
  final String count;
  final String label;

  const _ClubStatItem({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.accentYellow,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
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
  final VoidCallback? onManageVolunteers;
  final VoidCallback? onRegisterChanged;

  const _EventCard({
    required this.event,
    this.onManageVolunteers,
    this.onRegisterChanged,
  });

  void _handleRegistration(BuildContext context) {
    final eventProv = Provider.of<EventProvider>(context, listen: false);
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    if (event['isRegistered'] == true) {
      eventProv.unregisterFromEvent(event['id'], userId: authProv.user?.id);
      event['isRegistered'] = false;
      event['registeredCount'] = (event['registeredCount'] ?? 1) - 1;
    } else {
      eventProv.registerForEvent(event['id'], userId: authProv.user?.id);
      event['isRegistered'] = true;
      event['registeredCount'] = (event['registeredCount'] ?? 0) + 1;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.accentYellow,
        content: Text(
          event['isRegistered'] ? 'Registered for ${event['title']}!' : 'Unregistered from ${event['title']}',
          style: TextStyle(color: AppColors.darkGray),
        ),
      ),
    );

    // Notify parent to refresh
    onRegisterChanged?.call();
  }

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
          
          // Volunteer Needs
          if (event['needsVolunteers'] == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentYellow),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.volunteer_activism_rounded,
                    size: 16,
                    color: AppColors.accentYellow,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Volunteers Needed: ${event['volunteerRoles']?.join(', ') ?? 'Various roles'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentYellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleRegistration(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: event['isRegistered'] ? AppColors.mediumGray : AppColors.accentYellow,
                    foregroundColor: event['isRegistered'] ? AppColors.pureWhite : AppColors.darkGray,
                  ),
                  child: Text(
                    event['isRegistered'] ? 'Registered' : 'Register Now',
                    style: AppTextStyles.buttonMedium,
                  ),
                ),
              ),
              if (onManageVolunteers != null) ...[
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onManageVolunteers,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentYellow,
                    side: BorderSide(color: AppColors.accentYellow),
                  ),
                  child: const Icon(Icons.people_alt_rounded, size: 20),
                ),
              ],
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
