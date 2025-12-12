import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class FeedbackPage extends StatefulWidget {
  final Map<String, dynamic>? event;

  const FeedbackPage({super.key, this.event});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Event Feedback', style: AppTextStyles.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.event != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(widget.event!['imageUrl'] ?? 'https://picsum.photos/200'),
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
                              widget.event!['title'] ?? 'Event',
                              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.event!['club'] ?? 'Club',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              Text('Rate this Event', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              // Rating Slider
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rating', style: AppTextStyles.bodyMedium),
                      Text(
                        _rating.toStringAsFixed(1),
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accentYellow),
                      ),
                    ],
                  ),
                  Slider(
                    value: _rating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppColors.accentYellow,
                    onChanged: (value) => setState(() => _rating = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Poor', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                      Text('Excellent', style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray)),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Star Rating Display
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < _rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.accentYellow,
                      size: 32,
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text('Your Feedback', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Write your feedback',
                hintText: 'Share your experience, suggestions, or comments...',
                controller: _feedbackController,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide your feedback';
                  }
                  if (value.trim().length < 10) {
                    return 'Feedback must be at least 10 characters';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              CustomButton(
                text: 'Submit Feedback',
                onPressed: _submitFeedback,
                isLoading: _isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


