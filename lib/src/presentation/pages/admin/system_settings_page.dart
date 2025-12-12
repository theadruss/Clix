import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _autoApproveEvents = false;
  bool _requirePayment = false;
  String _defaultVenue = 'Main Auditorium';
  int _maxEventCapacity = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('System Settings', style: AppTextStyles.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Settings', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _SettingCard(
              title: 'Email Notifications',
              description: 'Send email notifications for event updates',
              value: _emailNotifications,
              onChanged: (value) => setState(() => _emailNotifications = value),
            ),
            _SettingCard(
              title: 'SMS Notifications',
              description: 'Send SMS alerts for critical updates',
              value: _smsNotifications,
              onChanged: (value) => setState(() => _smsNotifications = value),
            ),
            
            const SizedBox(height: 24),
            Text('Event Settings', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _SettingCard(
              title: 'Auto-Approve Events',
              description: 'Automatically approve events after advisor approval',
              value: _autoApproveEvents,
              onChanged: (value) => setState(() => _autoApproveEvents = value),
            ),
            _SettingCard(
              title: 'Require Payment',
              description: 'Require payment for event registrations',
              value: _requirePayment,
              onChanged: (value) => setState(() => _requirePayment = value),
            ),
            
            const SizedBox(height: 24),
            Text('Venue Settings', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Default Venue', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.pureWhite)),
                  const SizedBox(height: 8),
                  TextField(
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                    decoration: InputDecoration(
                      hintText: 'Enter default venue',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                      filled: true,
                      fillColor: AppColors.primaryBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => _defaultVenue = value),
                    controller: TextEditingController(text: _defaultVenue),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Max Event Capacity', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.pureWhite)),
                  const SizedBox(height: 8),
                  TextField(
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter max capacity',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                      filled: true,
                      fillColor: AppColors.primaryBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      final capacity = int.tryParse(value);
                      if (capacity != null) {
                        setState(() => _maxEventCapacity = capacity);
                      }
                    },
                    controller: TextEditingController(text: _maxEventCapacity.toString()),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings saved successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.darkGray,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text('Save Settings', style: AppTextStyles.buttonLarge),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingCard({
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accentYellow,
          ),
        ],
      ),
    );
  }
}


