// Payment model for handling payment transactions
class PaymentModel {
  final String id;
  final String eventId;
  final String userId;
  final String eventTitle;
  final double amount;
  final String paymentMethod; // 'razorpay', 'stripe', 'upi', 'credit_card'
  final String status; // 'pending', 'completed', 'failed', 'refunded'
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? refundId;
  final String? receiptUrl;
  final Map<String, dynamic>? metadata;

  PaymentModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.eventTitle,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.completedAt,
    this.refundId,
    this.receiptUrl,
    this.metadata,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      eventId: json['eventId'],
      userId: json['userId'],
      eventTitle: json['eventTitle'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      transactionId: json['transactionId'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      refundId: json['refundId'],
      receiptUrl: json['receiptUrl'],
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'eventTitle': eventTitle,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionId': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'refundId': refundId,
      'receiptUrl': receiptUrl,
      'metadata': metadata,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? eventTitle,
    double? amount,
    String? paymentMethod,
    String? status,
    String? transactionId,
    DateTime? createdAt,
    DateTime? completedAt,
    String? refundId,
    String? receiptUrl,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      eventTitle: eventTitle ?? this.eventTitle,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      refundId: refundId ?? this.refundId,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
