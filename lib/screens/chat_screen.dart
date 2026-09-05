import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../models/chat_appointment_model.dart';
import '../models/chat_treatment_request_model.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../services/media_service.dart';
import '../utils/enums.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../view_models/chat_view_model.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/dialog_box/share_treatment_request_dialog.dart';
import '../widgets/gradient_scaffold.dart';
import 'create_appointment_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';

  final bool showBackButton;
  final PatientTreatmentRequestData? treatmentRequestData;

  const ChatScreen({
    super.key,
    this.showBackButton = true,
    this.treatmentRequestData,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showPatientInfo = false;

  final List<String> _quickTemplates = [
    'Schedule Next Visit',
    'Send Pre-Treatment Instructions',
    'Request Follow-up Photos',
    'Share Consent Form',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.treatmentRequestData != null) {
      _showPatientInfo = true;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).loadMessages();
    });
  }

  Future<void> _pickMediaAndSend() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) {
      return;
    }

    final mediaUrl = await MediaService().uploadMedia(
      path: 'chat/media',
      file: picked,
    );
    if (mediaUrl == null) {
      return;
    }

    await _sendMessage(
      customText: 'Shared media.',
      messageType: MessageType.media,
      mediaUrl: mediaUrl,
    );
  }

  Future<void> _pickDocumentAndSend() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: false,
    );
    final file = result.singleOrNull;
    if (file == null || file.path == null) {
      return;
    }

    final documentUrl = await MediaService().uploadMedia(
      path: 'chat/documents',
      file: file,
    );
    if (documentUrl == null) {
      return;
    }

    await _sendMessage(
      customText: 'Shared document.',
      messageType: MessageType.document,
      documentName: file.name,
      documentUrl: documentUrl,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({
    String? customText,
    MessageType messageType = MessageType.text,
    String? mediaUrl,
    String? documentName,
    String? documentUrl,
    ChatTreatmentRequestModel? sharedRequestData,
    ChatAppointmentData? appointmentData,
  }) async {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty &&
        messageType == MessageType.text &&
        documentName == null &&
        mediaUrl == null &&
        sharedRequestData == null &&
        appointmentData == null) {
      return;
    }

    if (messageType == MessageType.media && mediaUrl == null) {
      await _pickMediaAndSend();
      return;
    }

    if (messageType == MessageType.document && documentUrl == null) {
      await _pickDocumentAndSend();
      return;
    }

    await ref
        .read(chatProvider.notifier)
        .sendChatMessage(
          type: messageType,
          content: text,
          mediaUrl: mediaUrl,
          documentUrl: documentUrl,
        );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref.read(chatProvider.notifier).clearSelectedChatAndMessages();
      },
      child: GradientScaffold(
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
                      Expanded(child: _buildMessages()),
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
      ),
    );
  }

  Widget _buildMessages() {
    return Consumer(
      builder: (_, ref, _) {
        final messages = ref.watch(
          chatProvider.select((s) => s.messagesData?.messages),
        );
        if (messages?.isEmpty ?? true) {
          return const SizedBox.shrink();
        }
        return ListView.builder(
          controller: _scrollController,
          padding: context.appEdgeInsets(horizontal: 20, vertical: 12),
          reverse: true,
          itemCount: messages!.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ChatMessageBubble(message: message);
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer(
      builder: (_, ref, _) {
        final user = ref.watch(
          chatProvider.select((s) => s.messagesData?.user),
        );
        final req = widget.treatmentRequestData;
        final displayName = req?.patientName ?? user?.name ?? 'N/A';
        final displayId = req != null
            ? 'Ref: #${req.referenceId ?? req.id}'
            : 'ID: ${user?.userId ?? 'N/A'}';

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
                    displayName.firstOrNull ?? 'P',
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
                      Text(displayName, style: context.fonts.black18w600),
                      context.horizontalSpace(8),
                      Container(
                        padding: context.appEdgeInsets(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.softGrey,
                          borderRadius: BorderRadius.circular(context.r(12)),
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: Text(displayId, style: context.fonts.grey11w600),
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
                        req != null
                            ? 'Option: ${req.name}'
                            : 'Botox & Facial Treatment',
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Header Quick Actions: Create Appointment & Toggle Patient Details
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(CreateAppointmentScreen.routeName);
              },
              icon: Icon(
                Iconsax.calendar_add,
                color: CustomColors.white,
                size: context.sp(16),
              ),
              label: Text(
                'Create Appointment',
                style: context.fonts.white12w700,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.purple,
                foregroundColor: CustomColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(8)),
                ),
                padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
              ),
            ),
            context.horizontalSpace(8),
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
      },
    );
  }

  Widget _buildPatientInfoBanner(BuildContext context) {
    final req = widget.treatmentRequestData;
    if (req != null) {
      return _buildTreatmentRequestBanner(context, req);
    }

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(horizontal: 20, vertical: 14),
      backgroundColor: CustomColors.lightPurple.withValues(alpha: 0.5),
      child: Consumer(
        builder: (_, ref, _) {
          final user = ref.watch(
            chatProvider.select((s) => s.messagesData?.user),
          );
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(context, 'Email', user?.emailAddress ?? 'N/A'),
              const VerticalDivider(color: CustomColors.border, width: 1),
              _buildInfoItem(context, 'Phone', user?.phoneNumber ?? 'N/A'),
              const VerticalDivider(color: CustomColors.border, width: 1),
              _buildInfoItem(context, 'Last Visit', 'Aug 18, 2026'),
              const VerticalDivider(color: CustomColors.border, width: 1),
              _buildInfoItem(
                context,
                'Next Appointment',
                'Sep 05, 2026 (10:00 AM)',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTreatmentRequestBanner(
    BuildContext context,
    PatientTreatmentRequestData req,
  ) {
    final String refId = req.referenceId != null
        ? '#${req.referenceId}'
        : '#${req.id}';
    final String patientName = req.patientName?.isNotEmpty == true
        ? req.patientName!
        : 'Patient';
    final String patientEmail = req.patientEmail?.isNotEmpty == true
        ? req.patientEmail!
        : 'N/A';
    final hasSlots =
        req.preferredSlots != null && req.preferredSlots!.isNotEmpty;
    final hasMedicalHistory = req.medicalHistory != null;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      backgroundColor: CustomColors.lightPurple.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header - Reference ID, Option Name & Hide Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CustomColors.purple,
                      borderRadius: BorderRadius.circular(context.r(12)),
                    ),
                    child: Text(
                      'Ref: $refId',
                      style: context.fonts.white12w700,
                    ),
                  ),
                  context.horizontalSpace(10),
                  Text(
                    'Option: ${req.name}',
                    style: context.fonts.purple13w700,
                  ),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _showPatientInfo = false),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: CustomColors.grey,
                ),
              ),
            ],
          ),
          context.verticalSpace(12),

          // Row 2: Patient Info (Email, Date, Total Treatments)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(context, 'Patient Name', patientName),
              _buildInfoItem(context, 'Email', patientEmail),
              _buildInfoItem(
                context,
                'Date',
                (req.createdAt != null && req.createdAt!.length >= 10)
                    ? req.createdAt!.substring(0, 10)
                    : 'N/A',
              ),
              _buildInfoItem(
                context,
                'Total Treatments',
                '${req.treatments.length} requested',
              ),
            ],
          ),

          // Row 3: Requested Treatments & Areas
          if (req.treatments.isNotEmpty) ...[
            context.verticalSpace(12),
            const Divider(color: CustomColors.border, height: 1),
            context.verticalSpace(10),
            Text(
              'Requested Treatments & Areas:',
              style: context.fonts.black12w600,
            ),
            context.verticalSpace(6),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(6),
              children: req.treatments.expand((t) {
                return t.areas.map((a) {
                  final priceText = a.price != null
                      ? ' (\$${a.price!.toStringAsFixed(0)})'
                      : '';
                  return Container(
                    padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(context.r(8)),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: context.sp(12),
                          color: CustomColors.purple,
                        ),
                        context.horizontalSpace(4),
                        Text(
                          '${t.treatmentName}: ${a.areaName}$priceText',
                          style: context.fonts.purple11w600,
                        ),
                      ],
                    ),
                  );
                });
              }).toList(),
            ),
          ],

          // Row 4: Preferred Appointment Slots (if available)
          if (hasSlots) ...[
            context.verticalSpace(10),
            Text('Preferred Slots:', style: context.fonts.black12w600),
            context.verticalSpace(6),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(6),
              children: req.preferredSlots!.map((slot) {
                return Container(
                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(context.r(8)),
                    border: Border.all(
                      color: CustomColors.purple.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: context.sp(12),
                        color: CustomColors.purple,
                      ),
                      context.horizontalSpace(4),
                      Text(
                        '${slot.date ?? ''} ${slot.time != null ? 'at ${slot.time}' : ''}'
                            .trim(),
                        style: context.fonts.black11w600,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Row 5: Patient Medical History (if available)
          if (hasMedicalHistory) ...[
            context.verticalSpace(10),
            Text('Medical History:', style: context.fonts.black12w600),
            context.verticalSpace(6),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(6),
              children: [
                if (req.medicalHistory!.allergies.isNotEmpty)
                  _buildMedicalBadge(
                    'Allergies: ${req.medicalHistory!.allergies.join(", ")}',
                    CustomColors.red,
                  ),
                if (req.medicalHistory!.medicalConditions.isNotEmpty)
                  _buildMedicalBadge(
                    'Conditions: ${req.medicalHistory!.medicalConditions.join(", ")}',
                    CustomColors.amber,
                  ),
                if (req.medicalHistory!.currentMedications.isNotEmpty)
                  _buildMedicalBadge(
                    'Medications: ${req.medicalHistory!.currentMedications.join(", ")}',
                    CustomColors.purple,
                  ),
              ],
            ),
          ],

          // Row 6: Simulation Thumbnails (if available)
          if (req.frontImageBefore != null || req.frontImageAfter != null) ...[
            context.verticalSpace(10),
            Text('Simulation Images:', style: context.fonts.black12w600),
            context.verticalSpace(6),
            Row(
              children: [
                if (req.frontImageBefore != null)
                  _buildSimulationThumbnail(
                    context,
                    'Front Before',
                    req.frontImageBefore!,
                  ),
                if (req.frontImageAfter != null) ...[
                  context.horizontalSpace(8),
                  _buildSimulationThumbnail(
                    context,
                    'Front After',
                    req.frontImageAfter!,
                  ),
                ],
                if (req.rightImageBefore != null) ...[
                  context.horizontalSpace(8),
                  _buildSimulationThumbnail(
                    context,
                    'Right Before',
                    req.rightImageBefore!,
                  ),
                ],
                if (req.rightImageAfter != null) ...[
                  context.horizontalSpace(8),
                  _buildSimulationThumbnail(
                    context,
                    'Right After',
                    req.rightImageAfter!,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicalBadge(String text, Color color) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.r(6)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: context.fonts.black11w600.copyWith(color: color),
      ),
    );
  }

  Widget _buildSimulationThumbnail(
    BuildContext context,
    String label,
    String url,
  ) {
    return Container(
      width: context.w(60),
      height: context.h(50),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(8)),
        border: Border.all(color: CustomColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(8)),
        child: url.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, size: 16),
              )
            : Image.asset(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 16),
              ),
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
          child: Text('Today, Aug 28, 2026', style: context.fonts.grey12w600),
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
            Text('Quick Responses:', style: context.fonts.grey11w600),
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
      decoration: const BoxDecoration(color: CustomColors.white),
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
                _pickMediaAndSend();
              } else if (value == 'document') {
                _pickDocumentAndSend();
              } else if (value == 'shared_request') {
                showDialog<PatientTreatmentRequestData>(
                  context: context,
                  builder: (context) => const ShareTreatmentRequestDialog(
                    patientName: 'Jane Cooper',
                  ),
                ).then((selectedReq) {
                  if (selectedReq != null) {
                    _sendMessage(
                      customText: 'Attached shared treatment request details.',
                      messageType: MessageType.sharedRequest,
                      sharedRequestData:
                          ChatTreatmentRequestModel.fromPatientTreatmentRequestData(
                            selectedReq,
                          ),
                    );
                  }
                });
              } else if (value == 'create_appointment') {
                context.pushNamed(CreateAppointmentScreen.routeName);
              } else if (value == 'appointment') {
                _sendMessage(
                  customText: 'Attached appointment confirmation details.',
                  messageType: MessageType.appointment,
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
                    Icon(
                      Icons.image_outlined,
                      size: context.sp(18),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(12),
                    Text(
                      'Send Photo / Media',
                      style: context.fonts.black14w400,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'document',
                child: Row(
                  children: [
                    Icon(
                      Icons.picture_as_pdf_outlined,
                      size: context.sp(18),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(12),
                    Text(
                      'Send Care Document (PDF)',
                      style: context.fonts.black14w400,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'shared_request',
                child: Row(
                  children: [
                    Icon(
                      Iconsax.profile_2user,
                      size: context.sp(18),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(12),
                    Text(
                      'Share Treatment Request',
                      style: context.fonts.black14w400,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'create_appointment',
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar_add,
                      size: context.sp(18),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(12),
                    Text(
                      'Create New Appointment',
                      style: context.fonts.black14w400,
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'appointment',
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      size: context.sp(18),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(12),
                    Text(
                      'Share Appointment Card',
                      style: context.fonts.black14w400,
                    ),
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
