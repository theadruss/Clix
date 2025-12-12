import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _filter = 'all'; // all, unread, events, approvals, payments
  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': '1',
      'title': 'Event Reminder',
      'message': 'Tech Symposium 2024 starts in 1 hour',
      'type': 'event',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'icon': Icons.event_rounded,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Approval Approved',
      'message': 'Your event proposal "Flutter Workshop" has been approved',
      'type': 'approval',
      'isRead': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': Icons.check_circle_rounded,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'Payment Confirmed',
      'message': 'Your payment for "Annual Conference" has been received',
      'type': 'payment',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': Icons.receipt_rounded,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'New Event Posted',
      'message': 'Cultural Committee posted a new event: "Annual Fest"',
      'type': 'event',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'icon': Icons.event_rounded,
      'color': Colors.blue,
    },
    {
      'id': '5',
      'title': 'System Update',
      'message': 'New features added to CampusConnect',
      'type': 'system',
      'isRead': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'icon': Icons.info_rounded,
      'color': Colors.purple,
    },
  ];

  List<Map<String, dynamic>> _getFilteredNotifications() {
    if (_filter == 'all') return _mockNotifications;
    if (_filter == 'unread') return _mockNotifications.where((n) => !n['isRead']).toList();
    return _mockNotifications.where((n) => n['type'] == _filter).toList();
  }

  void _markAsRead(String id) {
    final index = _mockNotifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      setState(() {
        _mockNotifications[index]['isRead'] = true;
      });
    }
  }

  void _deleteNotification(String id) {
    setState(() {
      _mockNotifications.removeWhere((n) => n['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _getFilteredNotifications();

    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text('Notifications', style: AppTextStyles.headlineSmall),
        centerTitle: false,
        actions: [
          if (filteredNotifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${filteredNotifications.where((n) => !n['isRead']).length} new',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentYellow),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    filter: 'all',
                    currentFilter: _filter,
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Unread',
                    filter: 'unread',
                    currentFilter: _filter,
                    onTap: () => setState(() => _filter = 'unread'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Events',
                    filter: 'event',
                    currentFilter: _filter,
                    onTap: () => setState(() => _filter = 'event'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Approvals',
                    filter: 'approval',
                    currentFilter: _filter,
                    onTap: () => setState(() => _filter = 'approval'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Payments',
                    filter: 'payment',
                    currentFilter: _filter,
                    onTap: () => setState(() => _filter = 'payment'),
                  ),
                ],
              ),
            ),
          ),
          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.mediumGray),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _NotificationItem(
                        notification: notification,
                        onMarkAsRead: () => _markAsRead(notification['id']),
                        onDelete: () => _deleteNotification(notification['id']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String filter;
  final String currentFilter;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.filter,
    required this.currentFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = filter == currentFilter;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentYellow : AppColors.darkGray,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: AppColors.lightGray),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isActive ? AppColors.primaryBlack : AppColors.pureWhite,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const _NotificationItem({
    required this.notification,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] ?? false;

    return Dismissible(
      key: Key(notification['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: isRead ? null : onMarkAsRead,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isRead ? AppColors.darkGray : AppColors.darkGray.withAlpha((0.8 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRead ? AppColors.lightGray : AppColors.accentYellow.withAlpha((0.5 * 255).toInt()),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (notification['color'] as Color).withAlpha((0.2 * 255).toInt()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification['icon'],
                  color: notification['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.accentYellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(notification['timestamp'] as DateTime),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray, fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton(
                itemBuilder: (context) => [
                  if (!isRead)
                    PopupMenuItem(
                      child: const Text('Mark as read'),
                      onTap: onMarkAsRead,
                    ),
                  PopupMenuItem(
                    child: const Text('Delete'),
                    onTap: onDelete,
                  ),
                ],
                icon: Icon(Icons.more_vert_rounded, color: AppColors.mediumGray, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

