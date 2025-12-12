import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/mock_data_service.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final double amount;

  const PaymentPage({
    super.key,
    required this.event,
    required this.amount,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = 'razorpay';
  bool _isProcessing = false;
  bool _agreedToTerms = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'razorpay',
      'name': 'Razorpay',
      'icon': Icons.payment_rounded,
      'description': 'Secure payment with Razorpay',
      'color': Colors.blue,
    },
    {
      'id': 'stripe',
      'name': 'Credit/Debit Card (Stripe)',
      'icon': Icons.credit_card_rounded,
      'description': 'Pay with your card',
      'color': Colors.indigo,
    },
    {
      'id': 'upi',
      'name': 'UPI',
      'icon': Icons.wallet_rounded,
      'description': 'Unified Payments Interface',
      'color': Colors.orange,
    },
  ];

  void _processPayment() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to terms and conditions')),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      // Register user for event after successful payment
      MockDataService.registerForEvent(widget.event['id']);
      widget.event['isRegistered'] = true;
      widget.event['registeredCount'] = (widget.event['registeredCount'] ?? 0) + 1;

      // Add to payments record
      MockDataService.payments.add({
        'id': 'PAY-${DateTime.now().millisecondsSinceEpoch}',
        'eventId': widget.event['id'],
        'userId': 'student_current',
        'eventTitle': widget.event['title'],
        'amount': widget.amount,
        'paymentMethod': _selectedPaymentMethod,
        'status': 'completed',
        'transactionId': 'TXN-${DateTime.now().millisecondsSinceEpoch}',
        'createdAt': DateTime.now().toIso8601String(),
        'completedAt': DateTime.now().toIso8601String(),
        'receiptUrl': 'https://example.com/receipt/${DateTime.now().millisecondsSinceEpoch}.pdf',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment successful! Registered for event.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Checkout', style: AppTextStyles.headlineSmall),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event['title'] ?? 'Event',
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1 Ticket',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                          ),
                        ],
                      ),
                      Text(
                        '\$${widget.amount.toStringAsFixed(2)}',
                        style: AppTextStyles.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.lightGray),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mediumGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${widget.amount.toStringAsFixed(2)}',
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.accentYellow),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment Method Selection
            Text(
              'Select Payment Method',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 16),
            ..._paymentMethods.map((method) {
              final isSelected = _selectedPaymentMethod == method['id'];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedPaymentMethod = method['id']),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.darkGray,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.accentYellow : AppColors.lightGray,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (method['color'] as Color).withAlpha((0.2 * 255).toInt()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              method['icon'],
                              color: method['color'],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method['name'],
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  method['description'],
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.accentYellow,
                              size: 24,
                            )
                          else
                            Icon(
                              Icons.radio_button_unchecked_rounded,
                              color: AppColors.mediumGray,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),

            const SizedBox(height: 32),

            // Terms and Conditions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                    activeColor: AppColors.accentYellow,
                    checkColor: AppColors.primaryBlack,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'I agree to the Terms & Conditions',
                          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cancellation: 48 hours before event',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Payment Info Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withAlpha((0.3 * 255).toInt())),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your payment is secure and encrypted',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Payment Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentYellow,
                  foregroundColor: AppColors.primaryBlack,
                  disabledBackgroundColor: AppColors.mediumGray,
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlack),
                        ),
                      )
                    : Text(
                        'Pay \$${widget.amount.toStringAsFixed(2)}',
                        style: AppTextStyles.headlineSmall.copyWith(color: AppColors.primaryBlack),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentYellow,
                  side: const BorderSide(color: AppColors.accentYellow),
                ),
                child: const Text('Cancel'),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

