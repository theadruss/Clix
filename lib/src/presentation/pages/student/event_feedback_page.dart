import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';

class EventFeedbackPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventFeedbackPage({
    super.key,
    required this.event,
  });

  @override
  State<EventFeedbackPage> createState() => _EventFeedbackPageState();
}

class _EventFeedbackPageState extends State<EventFeedbackPage> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _wouldAttendAgain = true;
  final List<String> _selectedTags = [];
  bool _isSubmitting = false;

  final List<String> _availableTags = [
    'Organization',
    'Venue',
    'Content',
    'Speakers',
    'Food',
    'Networking',
    'Timing',
    'Overall',
  ];

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _submitFeedback() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating')),
      );
      return;
    }

    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a review')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 2));

    final feedback = {
      'id': 'FB-${DateTime.now().millisecondsSinceEpoch}',
      'eventId': widget.event['id'],
      'rating': _rating,
      'review': _reviewController.text,
      'tags': _selectedTags,
      'wouldAttendAgain': _wouldAttendAgain,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // Add to mock data
    if (!MockDataService.feedbacks.any((f) => f['eventId'] == widget.event['id'])) {
      MockDataService.feedbacks.add(feedback);
    }

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Rate Event', style: AppTextStyles.headlineSmall),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.event['imageUrl'] ?? 'https://via.placeholder.com/80',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.event_rounded, color: AppColors.mediumGray),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event['title'] ?? 'Event',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.event['club'] ?? 'Club',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Star Rating
            Text(
              'How would you rate this event?',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => setState(() => _rating = index + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.star_rounded,
                        size: 48,
                        color: index < _rating ? AppColors.accentYellow : AppColors.lightGray,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            if (_rating > 0)
              Center(
                child: Text(
                  _getRatingLabel(_rating),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.accentYellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Review Text
            Text(
              'Tell us more about your experience',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reviewController,
              maxLines: 5,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Share your thoughts about this event...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                filled: true,
                fillColor: AppColors.darkGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.lightGray),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.lightGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.accentYellow),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),

            const SizedBox(height: 32),

            // Tags
            Text(
              'What stood out? (Select all that apply)',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => _toggleTag(tag),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accentYellow : AppColors.darkGray,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.accentYellow : AppColors.lightGray,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected ? AppColors.primaryBlack : AppColors.pureWhite,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Would Attend Again
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Would you attend another event like this?',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Help us understand event quality',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                      ),
                    ],
                  ),
                  Switch.adaptive(
                    value: _wouldAttendAgain,
                    onChanged: (value) => setState(() => _wouldAttendAgain = value),
                    activeColor: AppColors.accentYellow,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentYellow,
                  foregroundColor: AppColors.primaryBlack,
                  disabledBackgroundColor: AppColors.mediumGray,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
                        ),
                      )
                    : const Text('Submit Feedback'),
              ),
            ),

            const SizedBox(height: 16),

            // Skip Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentYellow,
                  side: const BorderSide(color: AppColors.accentYellow),
                ),
                child: const Text('Skip'),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}

