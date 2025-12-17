import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegistrationPage extends StatefulWidget {
  final Map<String, dynamic>? event;

  const RegistrationPage({super.key, this.event});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedPaymentMethod = 'razorpay';
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Register for event (store in Firestore if available)
    if (widget.event != null) {
      final eventProv = Provider.of<EventProvider>(context, listen: false);
      final authProv = Provider.of<AuthProvider>(context, listen: false);
      await eventProv.registerForEvent(widget.event!['id'], userId: authProv.user?.id);
    }

    setState(() => _isProcessing = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.darkGray,
          title: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              const SizedBox(width: 8),
              Text('Payment Successful!', style: AppTextStyles.headlineSmall),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Event Registration Confirmed', style: AppTextStyles.bodyLarge),
              const SizedBox(height: 8),
              if (widget.event != null) ...[
                Text('Event: ${widget.event!['title']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
                Text('Date: ${widget.event!['date']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
                Text('Venue: ${widget.event!['venue']}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray)),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Amount Paid:', style: AppTextStyles.bodyMedium),
                    Text(
                      '\$${widget.event?['fee'] ?? 0}',
                      style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accentYellow),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to event details
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                foregroundColor: AppColors.darkGray,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final fee = event?['fee'] ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Event Registration', style: AppTextStyles.headlineSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Summary
              if (event != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Event Details', style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(event['imageUrl'] ?? 'https://picsum.photos/200'),
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
                                  event['title'] ?? 'Event',
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  event['club'] ?? 'Club',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                                ),
                                Text(
                                  '${event['date']} • ${event['time']}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Registration Form
              Text('Registration Details', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Full Name',
                hintText: 'Enter your full name',
                controller: _nameController,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Please enter your email';
                  if (!value!.contains('@')) return 'Please enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter your phone number' : null,
              ),
              
              if (fee > 0) ...[
                const SizedBox(height: 24),
                Text('Payment', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 16),
                
                // Payment Method Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Method', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      _PaymentMethodOption(
                        method: 'razorpay',
                        label: 'Razorpay',
                        icon: Icons.payment_rounded,
                        isSelected: _selectedPaymentMethod == 'razorpay',
                        onTap: () => setState(() => _selectedPaymentMethod = 'razorpay'),
                      ),
                      const SizedBox(height: 8),
                      _PaymentMethodOption(
                        method: 'stripe',
                        label: 'Stripe',
                        icon: Icons.credit_card_rounded,
                        isSelected: _selectedPaymentMethod == 'stripe',
                        onTap: () => setState(() => _selectedPaymentMethod = 'stripe'),
                      ),
                      const SizedBox(height: 8),
                      _PaymentMethodOption(
                        method: 'upi',
                        label: 'UPI',
                        icon: Icons.account_balance_wallet_rounded,
                        isSelected: _selectedPaymentMethod == 'upi',
                        onTap: () => setState(() => _selectedPaymentMethod = 'upi'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Payment Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Event Fee', style: AppTextStyles.bodyMedium),
                          Text('\$$fee', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                      const Divider(color: AppColors.mediumGray),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            '\$$fee',
                            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accentYellow),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              CustomButton(
                text: fee > 0 ? 'Pay & Register' : 'Register Now',
                onPressed: _processPayment,
                isLoading: _isProcessing,
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodOption extends StatelessWidget {
  final String method;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodOption({
    required this.method,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentYellow.withAlpha((0.2 * 255).toInt()) : AppColors.primaryBlack,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accentYellow : AppColors.mediumGray,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.accentYellow : AppColors.mediumGray),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(color: isSelected ? AppColors.accentYellow : AppColors.pureWhite)),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: AppColors.accentYellow),
          ],
        ),
      ),
    );
  }
}


