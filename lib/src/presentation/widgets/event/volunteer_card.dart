import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class VolunteerCard extends StatelessWidget {
  final String eventTitle;
  final String clubName;
  final String eventDate;
  final String eventTime;
  final String venue;
  final List<String> neededRoles;
  final int volunteersNeeded;
  final int currentVolunteers;
  final VoidCallback onApply;
  final bool hasApplied;

  const VolunteerCard({
    super.key,
    required this.eventTitle,
    required this.clubName,
    required this.eventDate,
    required this.eventTime,
    required this.venue,
    required this.neededRoles,
    required this.volunteersNeeded,
    required this.currentVolunteers,
    required this.onApply,
    this.hasApplied = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentVolunteers / volunteersNeeded;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventTitle,
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  clubName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.accentYellow,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Event Details
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlack,
            ),
            child: Row(
              children: [
                _EventDetailChip(icon: Icons.calendar_today_rounded, text: eventDate),
                const SizedBox(width: 8),
                _EventDetailChip(icon: Icons.access_time_rounded, text: eventTime),
                const SizedBox(width: 8),
                _EventDetailChip(icon: Icons.location_on_rounded, text: venue),
              ],
            ),
          ),
          
          // Volunteer Progress
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Volunteers Needed',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$currentVolunteers/$volunteersNeeded',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.accentYellow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.lightGray,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 ? Colors.green : AppColors.accentYellow,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 12),
                
                // Needed Roles
                Text(
                  'Roles Needed:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.pureWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: neededRoles.map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.lightGray),
                      ),
                      child: Text(
                        role,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasApplied ? null : onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasApplied ? AppColors.mediumGray : AppColors.accentYellow,
                      foregroundColor: hasApplied ? AppColors.pureWhite : AppColors.darkGray,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      hasApplied ? 'Application Submitted' : 'Apply as Volunteer',
                      style: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetailChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EventDetailChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.mediumGray,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}