import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
 static const String routeName = '/chat-screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Dummy chat messages list
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text: 'Hello doctor, I received the simulation results for Option 1.',
      time: '10:15 AM',
      isMe: false,
    ),
    ChatMessage(
      id: '2',
      text: 'Hi! Great. Have you had a chance to review the before/after comparison?',
      time: '10:18 AM',
      isMe: true,
    ),
    ChatMessage(
      id: '3',
      text: 'Yes, I looked at it. I wanted to clarify how many sessions are recommended for this treatment.',
      time: '10:20 AM',
      isMe: false,
    ),
    ChatMessage(
      id: '4',
      text: 'Based on the selected areas, we usually plan 2 to 3 sessions spread over two months.',
      time: '10:22 AM',
      isMe: true,
    ),
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          time: timeStr,
          isMe: true,
        ),
      );
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: CustomColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: context.r(18),
              backgroundColor: CustomColors.softGrey,
              child: Text(
                'P',
                style: context.fonts.black14w600,
              ),
            ),
            context.horizontalSpace(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Chat',
                  style: context.fonts.black16w600,
                ),
                Text(
                  'Active Now',
                  style: context.fonts.grey12w400.copyWith(
                    color: CustomColors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900), // Desktop view constraint
          decoration:const BoxDecoration(
            color: CustomColors.white,
            border: Border.symmetric(
              vertical: BorderSide(color: CustomColors.border),
            ),
          ),
          child: Column(
            children: [
              // Dummy Message List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),

              // Bottom Input Bar
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: context.h(12)),
        constraints: const BoxConstraints(maxWidth: 480),
        padding: context.appEdgeInsets(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? CustomColors.purple : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.r(16)),
            topRight: Radius.circular(context.r(16)),
            bottomLeft: Radius.circular(isMe ? context.r(16) : context.r(2)),
            bottomRight: Radius.circular(isMe ? context.r(2) : context.r(16)),
          ),
          border: isMe ? null : Border.all(color: CustomColors.border),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: isMe
                  ? context.fonts.white14w600.copyWith(fontWeight: FontWeight.normal)
                  : context.fonts.black14w600.copyWith(fontWeight: FontWeight.normal),
            ),
            context.verticalSpace(4),
            Text(
              message.time,
              style: TextStyle(
                fontSize: context.sp(10),
                color: isMe
                    ? Colors.white.withValues(alpha: 0.7)
                    : CustomColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(
          top: BorderSide(color: CustomColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: context.appEdgeInsets(horizontal: 16),
              decoration: BoxDecoration(
                color: CustomColors.softGrey,
                borderRadius: BorderRadius.circular(context.r(24)),
              ),
              child: TextField(
                controller: _messageController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          context.horizontalSpace(8),
          InkWell(
            onTap: _sendMessage,
            borderRadius: BorderRadius.circular(context.r(24)),
            child: CircleAvatar(
              radius: context.r(20),
              backgroundColor: CustomColors.purple,
              child: Icon(
                Icons.send_rounded,
                color: CustomColors.white,
                size: context.r(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
  });
}