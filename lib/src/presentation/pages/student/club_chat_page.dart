import 'package:flutter/material.dart';
import '../../../core/theme/color_palette.dart';
import '../../../core/theme/text_styles.dart';

class ClubChatPage extends StatefulWidget {
  final Map<String, dynamic> club;

  const ClubChatPage({super.key, required this.club});

  @override
  State<ClubChatPage> createState() => _ClubChatPageState();
}

class _ClubChatPageState extends State<ClubChatPage> {
  int _selectedChat = 0;
  final TextEditingController _messageController = TextEditingController();

  // Mock chat groups
  final List<Map<String, dynamic>> _chatGroups = [
    {
      'id': 'general',
      'name': 'General',
      'type': 'general',
      'members': 245,
    },
    {
      'id': 'web-dev',
      'name': 'Web Development',
      'type': 'subgroup',
      'members': 45,
      'description': 'For web development projects and discussions',
    },
    {
      'id': 'mobile-dev',
      'name': 'Mobile Development',
      'type': 'subgroup',
      'members': 38,
      'description': 'Flutter and React Native projects',
    },
    {
      'id': 'ai-ml',
      'name': 'AI & Machine Learning',
      'type': 'subgroup',
      'members': 52,
      'description': 'AI projects and research discussions',
    },
    {
      'id': 'cybersecurity',
      'name': 'Cybersecurity',
      'type': 'subgroup',
      'members': 28,
      'description': 'Security projects and workshops',
    },
  ];

  // Mock messages for each chat
  final Map<String, List<Map<String, dynamic>>> _chatMessages = {
    'general': [
      {
        'id': '1',
        'sender': 'Club Coordinator',
        'message': 'Welcome to the Computer Society! Meetings are every Friday at 3 PM.',
        'time': '2 hours ago',
        'isMe': false,
      },
      {
        'id': '2',
        'sender': 'You',
        'message': 'Looking forward to the next workshop!',
        'time': '1 hour ago',
        'isMe': true,
      },
    ],
    'web-dev': [
      {
        'id': '1',
        'sender': 'Project Lead',
        'message': 'We need frontend developers for the campus portal project.',
        'time': '1 day ago',
        'isMe': false,
      },
    ],
    'mobile-dev': [
      {
        'id': '1',
        'sender': 'Flutter Lead',
        'message': 'Flutter workshop this Saturday at 10 AM.',
        'time': '2 days ago',
        'isMe': false,
      },
    ],
    'ai-ml': [
      {
        'id': '1',
        'sender': 'AI Coordinator',
        'message': 'Starting a new ML project next week. Sign up if interested!',
        'time': '3 days ago',
        'isMe': false,
      },
    ],
    'cybersecurity': [
      {
        'id': '1',
        'sender': 'Security Lead',
        'message': 'Cybersecurity competition registrations are open.',
        'time': '4 days ago',
        'isMe': false,
      },
    ],
  };

  List<Map<String, dynamic>> get _currentMessages {
    final currentGroup = _chatGroups[_selectedChat];
    return _chatMessages[currentGroup['id']] ?? [];
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': 'You',
      'message': _messageController.text,
      'time': 'Just now',
      'isMe': true,
    };

    final currentGroup = _chatGroups[_selectedChat];
    
    setState(() {
      _chatMessages[currentGroup['id']]!.add(newMessage);
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppColors.darkGray,
        title: Text(
          '${widget.club['name']} Chat',
          style: AppTextStyles.headlineSmall,
        ),
      ),
      body: Row(
        children: [
          // Chat Groups Sidebar
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.darkGray,
              border: Border(
                right: BorderSide(color: AppColors.lightGray, width: 1),
              ),
            ),
            child: ListView.builder(
              itemCount: _chatGroups.length,
              itemBuilder: (context, index) {
                final group = _chatGroups[index];
                return _ChatGroupItem(
                  group: group,
                  isSelected: _selectedChat == index,
                  onTap: () => setState(() => _selectedChat = index),
                );
              },
            ),
          ),
          // Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    border: Border(
                      bottom: BorderSide(color: AppColors.lightGray, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.accentYellow,
                        child: Text(
                          _chatGroups[_selectedChat]['name'][0],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _chatGroups[_selectedChat]['name'],
                              style: AppTextStyles.headlineSmall.copyWith(fontSize: 16),
                            ),
                            Text(
                              '${_chatGroups[_selectedChat]['members']} members',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Messages
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentMessages.length,
                    itemBuilder: (context, index) {
                      final message = _currentMessages[index];
                      return _MessageBubble(message: message);
                    },
                  ),
                ),
                // Message Input
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGray,
                    border: Border(
                      top: BorderSide(color: AppColors.lightGray, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlack,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.pureWhite),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: AppColors.accentYellow,
                        child: IconButton(
                          icon: Icon(Icons.send_rounded, color: AppColors.darkGray),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
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

class _ChatGroupItem extends StatelessWidget {
  final Map<String, dynamic> group;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChatGroupItem({
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: AppColors.primaryBlack,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: isSelected ? AppColors.accentYellow : AppColors.mediumGray,
        child: Text(
          group['name'][0],
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      title: Text(
        group['name'],
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.accentYellow : AppColors.pureWhite,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: group['type'] == 'subgroup'
          ? Text(
              '${group['members']} members',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.mediumGray,
              ),
            )
          : null,
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message['isMe']) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentYellow,
              child: Text(
                message['sender'][0],
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!message['isMe'])
                  Text(
                    message['sender'],
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mediumGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message['isMe'] ? AppColors.accentYellow : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message['message'],
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: message['isMe'] ? AppColors.darkGray : AppColors.pureWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message['time'],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
          if (message['isMe']) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentYellow,
              child: Icon(
                Icons.person_rounded,
                size: 16,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ],
      ),
    );
  }
}