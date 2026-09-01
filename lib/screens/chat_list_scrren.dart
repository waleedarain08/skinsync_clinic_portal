import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/gradient_scaffold.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  static const String routeName = '/chat-list-screen';

  final bool showBackButton;

  const ChatListScreen({
    super.key,
    this.showBackButton = false,
  });

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildSearchBar(context),
            context.verticalSpace(24),
            _buildChatListSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: CustomColors.black,
            ),
            onPressed: () => context.pop(),
          ),
          context.horizontalSpace(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: context.fonts.level1Heading,
              ),
              context.verticalSpace(6),
              Text(
                'Manage clinic communication and direct patient discussions.',
                style: context.fonts.grey13w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      child: TextFormField(
        controller: _searchController,
        style: context.fonts.black14w400,
        decoration: AppDecorations.input(
          context,
          hint: 'Search patients or messages...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: CustomColors.grey,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: CustomColors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _filterChats('');
                  },
                )
              : null,
        ),
        onChanged: _filterChats,
      ),
    );
  }

  Widget _buildChatListSection(BuildContext context) {
    if (_filteredChats.isEmpty) {
      return BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: context.appEdgeInsets(all: 20),
                decoration: const BoxDecoration(
                  color: CustomColors.whiteGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: CustomColors.grey,
                ),
              ),
              context.verticalSpace(24),
              Text('No conversations found', style: context.fonts.black18w600),
              context.verticalSpace(8),
              Text(
                'Try clearing your search keyword or search for another patient.',
                style: context.fonts.grey14w400,
                textAlign: TextAlign.center,
              ),
              if (_searchController.text.isNotEmpty) ...[
                context.verticalSpace(24),
                CustomOutlinedButton(
                  onTap: () {
                    _searchController.clear();
                    _filterChats('');
                  },
                  label: 'Clear Search',
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredChats.length,
      itemBuilder: (context, index) {
        final item = _filteredChats[index];
        return _buildChatCard(context, item);
      },
    );
  }

  Widget _buildChatCard(BuildContext context, ChatListItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(context.r(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(context.r(16)),
          onTap: () {
            context.pushNamed(
              ChatScreen.routeName,
              queryParameters: {'showBackButton': 'true'},
            );
          },
          child: Padding(
            padding: context.appEdgeInsets(all: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: context.r(24),
                      backgroundColor: CustomColors.lightPurple,
                      child: Text(
                        item.patientName.isNotEmpty
                            ? item.patientName[0]
                            : 'P',
                        style: context.fonts.purple16w700,
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
                            border:
                                Border.all(color: CustomColors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                ? context.fonts.purple12w700
                                : context.fonts.grey12w400,
                          ),
                        ],
                      ),
                      context.verticalSpace(4),
                      Row(
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
                              padding: context.appEdgeInsets(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: const BoxDecoration(
                                color: CustomColors.purple,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${item.unreadCount}',
                                style: context.fonts.white10w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
