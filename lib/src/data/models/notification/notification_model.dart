// Notification model and service
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'event', 'approval', 'payment', 'feedback', 'system'
  final String? relatedId; // event id, approval id, etc.
  final bool isRead;
  final DateTime createdAt;
  final String? actionUrl;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    required this.isRead,
    required this.createdAt,
    this.actionUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      relatedId: json['relatedId'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'actionUrl': actionUrl,
    };
  }
}

class NotificationService {
  static final List<NotificationModel> _notifications = [];

  // Send notification
  static Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? relatedId,
    String? actionUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final notification = NotificationModel(
      id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      title: title,
      message: message,
      type: type,
      relatedId: relatedId,
      isRead: false,
      createdAt: DateTime.now(),
      actionUrl: actionUrl,
    );

    _notifications.add(notification);
  }

  // Get user notifications
  static Future<List<NotificationModel>> getUserNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _notifications.where((n) => n.userId == userId).toList();
  }

  // Mark as read
  static Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        id: _notifications[index].id,
        userId: _notifications[index].userId,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        relatedId: _notifications[index].relatedId,
        isRead: true,
        createdAt: _notifications[index].createdAt,
        actionUrl: _notifications[index].actionUrl,
      );
    }
  }

  // Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notifications.removeWhere((n) => n.id == notificationId);
  }

  // Send event reminder
  static Future<void> sendEventReminder(String userId, Map<String, dynamic> event) async {
    await sendNotification(
      userId: userId,
      title: 'Event Reminder',
      message: '${event['title']} starts in 1 hour',
      type: 'event',
      relatedId: event['id'],
      actionUrl: '/event/${event['id']}',
    );
  }

  // Send approval notification
  static Future<void> sendApprovalNotification(String userId, String status, String approvalTitle) async {
    await sendNotification(
      userId: userId,
      title: 'Approval ${status.toUpperCase()}',
      message: '$approvalTitle has been $status',
      type: 'approval',
    );
  }

  // Send payment confirmation
  static Future<void> sendPaymentConfirmation(String userId, String eventTitle, double amount) async {
    await sendNotification(
      userId: userId,
      title: 'Payment Confirmed',
      message: 'Your payment for $eventTitle (\$$amount) has been received',
      type: 'payment',
    );
  }
}
