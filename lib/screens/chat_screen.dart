import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/gradient_scaffold.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';

  final bool showBackButton;

  const ChatScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showPatientInfo = false;

  final List<String> _quickTemplates = [
    'Schedule Next Visit',
    'Send Pre-Treatment Instructions',
    'Request Follow-up Photos',
    'Share Consent Form',
  ];

  // Dummy chat messages list
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      senderName: 'Jane Cooper',
      text: 'Hello doctor, I received the simulation results for Option 1.',
      time: '10:15 AM',
      isMe: false,
    ),
    ChatMessage(
      id: '2',
      senderName: 'You',
      text:
          'Hi Jane! Great. Have you had a chance to review the before/after comparison?',
      time: '10:18 AM',
      isMe: true,
      isRead: true,
    ),
    ChatMessage(
      id: '3',
      senderName: 'Jane Cooper',
      text:
          'Yes, I looked at it. I wanted to clarify how many sessions are recommended for this treatment.',
      time: '10:20 AM',
      isMe: false,
    ),
    ChatMessage(
      id: '4',
      senderName: 'Jane Cooper',
      text: 'Here is the simulation summary document I was referring to.',
      time: '10:21 AM',
      isMe: false,
      attachmentName: 'Facial_Rejuvenation_Option_1.pdf',
      attachmentSize: '1.4 MB',
    ),
    ChatMessage(
      id: '5',
      senderName: 'You',
      text:
          'Based on the selected areas, we usually plan 2 to 3 sessions spread over two months.',
      time: '10:22 AM',
      isMe: true,
      isRead: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? customText]) {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: 'You',
          text: text,
          time: timeStr,
          isMe: true,
          isRead: false,
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
    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(16),
            if (_showPatientInfo) ...[
              _buildPatientInfoBanner(context),
              context.verticalSpace(16),
            ],
            Expanded(
              child: BorderdContainerWidget(
                padding: EdgeInsets.zero,
                borderRadius: context.r(16),
                child: Column(
                  children: [
                    // Date Divider Header
                    _buildDateDivider(context),
                    // Message List
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: context.appEdgeInsets(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return _buildMessageBubble(context, message);
                        },
                      ),
                    ),
                    const Divider(color: CustomColors.border, height: 1),
                    // Quick Action Presets Row
                    _buildQuickPresetsRow(context),
                    const Divider(color: CustomColors.border, height: 1),
                    // Bottom Input Bar
                    _buildInputArea(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Stack(
          children: [
            CircleAvatar(
              radius: context.r(24),
              backgroundColor: CustomColors.lightPurple,
              child: Text(
                'J',
                style: context.fonts.purple16w700,
              ),
            ),
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
        context.horizontalSpace(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Jane Cooper',
                    style: context.fonts.black18w600,
                  ),
                  context.horizontalSpace(8),
                  Container(
                    padding: context.appEdgeInsets(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: CustomColors.softGrey,
                      borderRadius: BorderRadius.circular(context.r(12)),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Text(
                      'ID: #PT-1082',
                      style: context.fonts.grey11w600,
                    ),
                  ),
                ],
              ),
              context.verticalSpace(2),
              Row(
                children: [
                  Text(
                    'Active Now',
                    style: context.fonts.grey12w400.copyWith(
                      color: CustomColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  context.horizontalSpace(8),
                  Text('•', style: context.fonts.grey12w400),
                  context.horizontalSpace(8),
                  Text(
                    'Botox & Facial Treatment',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Header Quick Actions
        IconButton(
          onPressed: () {
            setState(() {
              _showPatientInfo = !_showPatientInfo;
            });
          },
          tooltip: 'Toggle Patient Details',
          icon: Icon(
            _showPatientInfo ? Iconsax.info_circle5 : Iconsax.info_circle,
            color: CustomColors.purple,
            size: context.sp(22),
          ),
          style: IconButton.styleFrom(
            backgroundColor: CustomColors.lightPurple,
            shape: RoundedRectangleBorder(
              borderRadius: context.appBorderRadius(all: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientInfoBanner(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(horizontal: 20, vertical: 14),
      backgroundColor: CustomColors.lightPurple.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(context, 'Email', 'jane.cooper@example.com'),
          const VerticalDivider(color: CustomColors.border, width: 1),
          _buildInfoItem(context, 'Phone', '+1 (555) 234-5678'),
          const VerticalDivider(color: CustomColors.border, width: 1),
          _buildInfoItem(context, 'Last Visit', 'Aug 18, 2026'),
          const VerticalDivider(color: CustomColors.border, width: 1),
          _buildInfoItem(context, 'Next Appointment', 'Sep 05, 2026 (10:00 AM)'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey11w600),
        context.verticalSpace(2),
        Text(value, style: context.fonts.black13w600),
      ],
    );
  }

  Widget _buildDateDivider(BuildContext context) {
    return Padding(
      padding: context.appEdgeInsets(vertical: 16),
      child: Center(
        child: Container(
          padding: context.appEdgeInsets(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: BorderRadius.circular(context.r(20)),
            border: Border.all(color: CustomColors.border),
          ),
          child: Text(
            'Today, Aug 28, 2026',
            style: context.fonts.grey12w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: context.h(16)),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: context.h(4)),
              child: Text(
                '${message.senderName}, ${message.time}',
                style: context.fonts.grey11w400,
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: context.w(480)),
              padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? CustomColors.purple : CustomColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.r(16)),
                  topRight: Radius.circular(context.r(16)),
                  bottomLeft:
                      Radius.circular(isMe ? context.r(16) : context.r(2)),
                  bottomRight:
                      Radius.circular(isMe ? context.r(2) : context.r(16)),
                ),
                border: Border.all(
                  color: isMe ? CustomColors.purple : CustomColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: isMe
                        ? context.fonts.white14w600
                            .copyWith(fontWeight: FontWeight.w400)
                        : context.fonts.black14w400,
                  ),
                  if (message.attachmentName != null) ...[
                    context.verticalSpace(10),
                    Container(
                      padding: context.appEdgeInsets(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isMe
                            ? CustomColors.white.withValues(alpha: 0.15)
                            : CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(10)),
                        border: Border.all(
                          color: isMe
                              ? CustomColors.white.withValues(alpha: 0.3)
                              : CustomColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            size: context.sp(24),
                            color: isMe
                                ? CustomColors.white
                                : CustomColors.purple,
                          ),
                          context.horizontalSpace(10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.attachmentName!,
                                  style: isMe
                                      ? context.fonts.white12w700
                                      : context.fonts.black12w600,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (message.attachmentSize != null)
                                  Text(
                                    message.attachmentSize!,
                                    style: isMe
                                        ? context.fonts.white10w600
                                        : context.fonts.grey10w400,
                                  ),
                              ],
                            ),
                          ),
                          context.horizontalSpace(10),
                          Icon(
                            Icons.download_rounded,
                            size: context.sp(18),
                            color: isMe
                                ? CustomColors.white
                                : CustomColors.purple,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isMe) ...[
              context.verticalSpace(2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    message.isRead
                        ? Icons.done_all_rounded
                        : Icons.check_rounded,
                    size: context.sp(14),
                    color: CustomColors.purple,
                  ),
                  context.horizontalSpace(4),
                  Text(
                    message.isRead ? 'Read' : 'Sent',
                    style: context.fonts.purple11w600,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPresetsRow(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 10),
      color: CustomColors.whiteGrey,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(
              Iconsax.flash_1,
              size: context.sp(16),
              color: CustomColors.purple,
            ),
            context.horizontalSpace(8),
            Text(
              'Quick Responses:',
              style: context.fonts.grey11w600,
            ),
            context.horizontalSpace(12),
            ..._quickTemplates.map(
              (template) => Padding(
                padding: EdgeInsets.only(right: context.w(8)),
                child: ActionChip(
                  label: Text(template),
                  labelStyle: context.fonts.purple12w700,
                  backgroundColor: CustomColors.lightPurple,
                  side: BorderSide(
                    color: CustomColors.purple.withValues(alpha: 0.2),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  onPressed: () {
                    _messageController.text = template;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: CustomColors.white,
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.attach_file_rounded,
              color: CustomColors.grey,
              size: context.sp(22),
            ),
            tooltip: 'Attach Media or Document',
            onSelected: (value) {
              if (value == 'photo') {
                _sendMessage('Shared recent pre-treatment photo.');
              } else if (value == 'document') {
                setState(() {
                  _messages.add(
                    ChatMessage(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      senderName: 'You',
                      text: 'Shared treatment care document for review.',
                      time: 'Now',
                      isMe: true,
                      isRead: false,
                      attachmentName: 'Post_Treatment_Care_Guide.pdf',
                      attachmentSize: '950 KB',
                    ),
                  );
                });
                _scrollToBottom();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'photo',
                child: Row(
                  children: [
                    Icon(Icons.image_outlined,
                        size: context.sp(18), color: CustomColors.purple),
                    context.horizontalSpace(12),
                    Text('Send Photo / Image',
                        style: context.fonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'document',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_outlined,
                        size: context.sp(18), color: CustomColors.purple),
                    context.horizontalSpace(12),
                    Text('Send Care Document (PDF)',
                        style: context.fonts.black14w400),
                  ],
                ),
              ),
            ],
          ),
          context.horizontalSpace(8),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              style: context.fonts.black14w400,
              decoration: AppDecorations.input(
                context,
                hint: 'Type a professional message...',
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          context.horizontalSpace(12),
          InkWell(
            onTap: () => _sendMessage(),
            borderRadius: BorderRadius.circular(context.r(24)),
            child: Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: const BoxDecoration(
                color: CustomColors.purple,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: CustomColors.white,
                size: context.sp(18),
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
  final String senderName;
  final String text;
  final String time;
  final bool isMe;
  final bool isRead;
  final String? attachmentName;
  final String? attachmentSize;

  ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.attachmentName,
    this.attachmentSize,
  });
}
