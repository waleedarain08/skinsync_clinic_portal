import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/theme.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
 static const String routeName = '/chat-list-screen';
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy list of patient conversations
  final List<ChatListItem> _allChats = [
    ChatListItem(
      id: '1',
      patientName: 'Jane Cooper',
      lastMessage: 'Based on the selected areas, we usually plan 2 to 3 sessions.',
      time: '10:22 AM',
      unreadCount: 2,
      isOnline: true,
    ),
    ChatListItem(
      id: '2',
      patientName: 'Robert Fox',
      lastMessage: 'Thank you doctor! When should I schedule the next visit?',
      time: 'Yesterday',
      unreadCount: 0,
      isOnline: false,
    ),
    ChatListItem(
      id: '3',
      patientName: 'Emily Watson',
      lastMessage: 'Is there any preparation required before the treatment?',
      time: '24 Aug',
      unreadCount: 1,
      isOnline: true,
    ),
    ChatListItem(
      id: '4',
      patientName: 'Michael Brown',
      lastMessage: 'Option 3 looks good to me. Let us proceed with it.',
      time: '21 Aug',
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  List<ChatListItem> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = List.from(_allChats);
  }

  void _filterChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(_allChats);
      } else {
        _filteredChats = _allChats
            .where((chat) =>
                chat.patientName.toLowerCase().contains(query.toLowerCase()) ||
                chat.lastMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
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
        title: Text(
          'Messages',
          style: context.fonts.black18w600,
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900), // Web layout constraint
          decoration:const BoxDecoration(
            color: CustomColors.white,
            border: Border.symmetric(
              vertical: BorderSide(color: CustomColors.border),
            ),
          ),
          child: Column(
            children: [
              // Search Bar Section
              Padding(
                padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
                child: Container(
                  padding: context.appEdgeInsets(horizontal: 14),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterChats,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search_rounded,
                        color: CustomColors.grey,
                        size: context.r(20),
                      ),
                      hintText: 'Search patients or messages...',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              const Divider(height: 1),

              // Chat List Area
              Expanded(
                child: _filteredChats.isEmpty
                    ? Center(
                        child: Text(
                          'No conversations found',
                          style: context.fonts.grey14w400,
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredChats.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                          indent: 72,
                        ),
                        itemBuilder: (context, index) {
                          final item = _filteredChats[index];
                          return _buildChatTile(context, item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildChatTile(BuildContext context, ChatListItem item) {
  return Material(
    color: Colors.transparent,
    child: ListTile(
      contentPadding: context.appEdgeInsets(horizontal: 16, vertical: 8),
      onTap: () {
        context.pushNamed(ChatScreen.routeName);
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: context.r(24),
            backgroundColor: CustomColors.softGrey,
            child: Text(
              item.patientName.isNotEmpty ? item.patientName[0] : 'P',
              style: context.fonts.black16w600,
            ),
          ),
          if (item.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: context.r(12),
                height: context.r(12),
                decoration: BoxDecoration(
                  color: CustomColors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: CustomColors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.patientName,
              style: context.fonts.black16w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            item.time,
            style: item.unreadCount > 0
                ? context.fonts.black12w600.copyWith(color: CustomColors.purple)
                : context.fonts.grey12w400,
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: context.h(4)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.lastMessage,
                style: item.unreadCount > 0
                    ? context.fonts.black14w600
                    : context.fonts.grey14w400,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.unreadCount > 0) ...[
              context.horizontalSpace(8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration:const BoxDecoration(
                  color: CustomColors.purple,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${item.unreadCount}',
                  style: context.fonts.white10w600
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
}

class ChatListItem {
  final String id;
  final String patientName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  ChatListItem({
    required this.id,
    required this.patientName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
  });
}