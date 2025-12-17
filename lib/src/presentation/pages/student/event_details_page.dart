import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import 'feedback_page.dart';
import 'registration_page.dart';
import 'payment_page.dart';

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  Future<void> _registerForFreeEvent(Map<String, dynamic> event, BuildContext context) async {
    final eventProv = Provider.of<EventProvider>(context, listen: false);
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      event['isRegistered'] = true;
      event['registeredCount'] = (event['registeredCount'] ?? 0) + 1;
    });
    await eventProv.registerForEvent(event['id'], userId: authProv.user?.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registered successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.darkGray,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                event['imageUrl'] ?? 'https://picsum.photos/400/200',
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Club
                  Text(
                    event['title'] ?? 'Event Title',
                    style: AppTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.group_rounded, size: 16, color: AppColors.accentYellow),
                      const SizedBox(width: 4),
                      Text(
                        event['club'] ?? 'Unknown Club',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentYellow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Event Details
                  _DetailRow(icon: Icons.calendar_today_rounded, label: 'Date', value: event['date'] ?? 'TBD'),
                  _DetailRow(icon: Icons.access_time_rounded, label: 'Time', value: event['time'] ?? 'TBD'),
                  _DetailRow(icon: Icons.location_on_rounded, label: 'Venue', value: event['venue'] ?? 'TBD'),
                  if (event['capacity'] != null)
                    _DetailRow(icon: Icons.people_rounded, label: 'Capacity', value: '${event['capacity']} people'),
                  if (event['fee'] != null && event['fee'] > 0)
                    _DetailRow(icon: Icons.attach_money_rounded, label: 'Fee', value: '\$${event['fee']}'),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  Text('Description', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    event['description'] ?? 'No description available',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stats
                  Row(
                    children: [
                      _StatItem(icon: Icons.favorite_rounded, value: '${event['interestedCount'] ?? 0}', label: 'Interested'),
                      const SizedBox(width: 24),
                      _StatItem(icon: Icons.people_rounded, value: '${event['registeredCount'] ?? 0}', label: 'Registered'),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  if (event['isRegistered'] == true) ...[
                    CustomButton(
                      text: 'View Registration',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistrationPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        final eventProv = Provider.of<EventProvider>(context, listen: false);
                        final authProv = Provider.of<AuthProvider>(context, listen: false);
                        setState(() {
                          event['isRegistered'] = false;
                          event['registeredCount'] = (event['registeredCount'] ?? 1) - 1;
                        });
                        await eventProv.unregisterFromEvent(event['id'], userId: authProv.user?.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Unregistered from event'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Unregister'),
                    ),
                  ] else ...[
                    CustomButton(
                      text: event['fee'] != null && event['fee'] > 0 ? 'Register & Pay' : 'Register Now',
                      onPressed: () {
                        if (event['fee'] != null && event['fee'] > 0) {
                          // Navigate to payment page for paid events
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(event: event, amount: event['fee']),
                            ),
                          ).then((_) {
                            setState(() {}); // Refresh on return
                          });
                        } else {
                          // Register for free event
                          _registerForFreeEvent(event, context);
                        }
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Additional Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackPage(event: event),
                              ),
                            );
                          },
                          icon: const Icon(Icons.feedback_rounded),
                          label: const Text('Feedback'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accentYellow,
                            side: BorderSide(color: AppColors.accentYellow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sharing event...')),
                            );
                          },
                          icon: const Icon(Icons.share_rounded),
                          label: const Text('Share'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accentYellow,
                            side: BorderSide(color: AppColors.accentYellow),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Volunteer Section
                  if (event['needsVolunteers'] == true) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.volunteer_activism_rounded, color: AppColors.accentYellow),
                              const SizedBox(width: 8),
                              Text('Volunteers Needed', style: AppTextStyles.headlineSmall),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (event['volunteerRoles'] != null)
                            ...(event['volunteerRoles'] as List).map((role) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.accentYellow),
                                  const SizedBox(width: 8),
                                  Text(role, style: AppTextStyles.bodyMedium),
                                ],
                              ),
                            )),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Volunteer application submitted!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentYellow,
                              foregroundColor: AppColors.darkGray,
                            ),
                            child: const Text('Apply as Volunteer'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.accentYellow),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentYellow),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.pureWhite),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
        ),
      ],
    );
  }
}


