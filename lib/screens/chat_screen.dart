import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../models/dummy/chat_dummy_model.dart';
import '../utils/enums.dart';
import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/chat/chat_message_bubble.dart';
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

  late final List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    // Copy initial dummy messages list
    _messages = List.from(dummyChatMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({
    String? customText,
    ChatMessageType messageType = ChatMessageType.normal,
    String? mediaUrl,
    String? mediaCaption,
    String? documentName,
    String? documentSize,
    ChatSharedRequestData? sharedRequestData,
    ChatAppointmentData? appointmentData,
  }) {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty &&
        messageType == ChatMessageType.normal &&
        documentName == null &&
        mediaUrl == null &&
        sharedRequestData == null &&
        appointmentData == null) {
      return;
    }

    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: 'You',
          time: timeStr,
          isMe: true,
          isRead: false,
          messageType: messageType,
          text: text,
          mediaUrl: mediaUrl,
          mediaCaption: mediaCaption,
          documentName: documentName,
          documentSize: documentSize,
          sharedRequestData: sharedRequestData,
          appointmentData: appointmentData,
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
                          return ChatMessageBubble(message: message);
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
            tooltip: 'Attach Media, Document, Request or Appointment',
            onSelected: (value) {
              if (value == 'photo') {
                _sendMessage(
                  customText: 'Shared pre-treatment photo.',
                  messageType: ChatMessageType.media,
                  mediaUrl:
                      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80',
                  mediaCaption: 'Pre-treatment Progress Photo',
                );
              } else if (value == 'document') {
                _sendMessage(
                  customText: 'Shared treatment care instructions document.',
                  messageType: ChatMessageType.document,
                  documentName: 'Post_Treatment_Care_Guide.pdf',
                  documentSize: '950 KB',
                );
              } else if (value == 'shared_request') {
                _sendMessage(
                  customText: 'Attached shared treatment request details.',
                  messageType: ChatMessageType.sharedRequest,
                  sharedRequestData: ChatSharedRequestData(
                    requestId: 105,
                    patientName: 'Jane Cooper',
                    treatmentName: 'Botox & Dermal Fillers Session',
                    dateShared: 'Aug 28, 2026',
                    status: 'Pending Approval',
                    clinicName: 'SkinSync Aesthetic Clinic',
                  ),
                );
              } else if (value == 'appointment') {
                _sendMessage(
                  customText: 'Attached appointment confirmation details.',
                  messageType: ChatMessageType.appointment,
                  appointmentData: ChatAppointmentData(
                    appointmentId: 408,
                    patientName: 'Jane Cooper',
                    serviceName: 'Dermal Fillers Follow-up',
                    date: 'Sep 12, 2026',
                    time: '11:30 AM',
                    practitionerName: 'Dr. Sarah Johnson',
                    status: 'Confirmed',
                  ),
                );
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
                    Text('Send Photo / Media', style: context.fonts.black14w400),
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
                    Text('Send Care Document (PDF)', style: context.fonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'shared_request',
                child: Row(
                  children: [
                    Icon(Iconsax.profile_2user,
                        size: context.sp(18), color: CustomColors.purple),
                    context.horizontalSpace(12),
                    Text('Share Treatment Request', style: context.fonts.black14w400),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'appointment',
                child: Row(
                  children: [
                    Icon(Iconsax.calendar,
                        size: context.sp(18), color: CustomColors.purple),
                    context.horizontalSpace(12),
                    Text('Share Appointment Card', style: context.fonts.black14w400),
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
