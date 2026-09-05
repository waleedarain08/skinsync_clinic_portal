import 'dart:convert';
import 'package:before_after/before_after.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/responses/messages_response.dart';
import '../../models/responses/patient_treatment_request_response.dart';
import '../../screens/dashboard/shared_treatment_request_screen.dart';
import '../../utils/theme.dart';

class SharedRequestChatBubble extends StatefulWidget {
  final Message message;

  const SharedRequestChatBubble({super.key, required this.message});

  @override
  State<SharedRequestChatBubble> createState() =>
      _SharedRequestChatBubbleState();
}

class _SharedRequestChatBubbleState extends State<SharedRequestChatBubble> {
  double _sliderValue = 0.5;
  String _selectedView = 'Front';

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.isMe;
    final contentStr = widget.message.content;

    PatientTreatmentRequestData? request;
    if (contentStr != null && contentStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(contentStr);
        if (decoded is Map<String, dynamic>) {
          request = PatientTreatmentRequestData.fromJson(decoded);
        }
      } catch (_) {
        // Content is plain text or fallback string
      }
    }

    if (request == null) {
      return Container(
        constraints: BoxConstraints(maxWidth: context.w(520)),
        padding: context.appEdgeInsets(all: 16),
        decoration: BoxDecoration(
          color: isMe ? CustomColors.purple : CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(
            color: isMe ? CustomColors.purple : CustomColors.border,
          ),
        ),
        child: Text(
          contentStr?.isNotEmpty == true
              ? contentStr!
              : 'Shared Treatment Request Data Unavailable',
          style: isMe
              ? context.fonts.white14w600.copyWith(fontWeight: FontWeight.w400)
              : context.fonts.black14w400,
        ),
      );
    }

    final refId =
        request.referenceId != null ? '#${request.referenceId}' : '#${request.id}';
    final patientName = request.patientName?.isNotEmpty == true
        ? request.patientName!
        : 'Patient';
    final patientEmail = request.patientEmail?.isNotEmpty == true
        ? request.patientEmail!
        : '';
    final hasSlots =
        request.preferredSlots != null && request.preferredSlots!.isNotEmpty;
    final hasMedicalHistory = request.medicalHistory != null;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(540)),
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(16)),
          topRight: Radius.circular(context.r(16)),
          bottomLeft: Radius.circular(isMe ? context.r(16) : context.r(2)),
          bottomRight: Radius.circular(isMe ? context.r(2) : context.r(16)),
        ),
        border: Border.all(
          color: CustomColors.purple.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 6),
                      decoration: const BoxDecoration(
                        color: CustomColors.lightPurple,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.profile_2user,
                        size: context.sp(16),
                        color: CustomColors.purple,
                      ),
                    ),
                    context.horizontalSpace(8),
                    Expanded(
                      child: Text(
                        'Option: ${request.name}',
                        style: context.fonts.purple13w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: context.appEdgeInsets(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: CustomColors.purple,
                  borderRadius: BorderRadius.circular(context.r(12)),
                ),
                child: Text(
                  'Ref: $refId',
                  style: context.fonts.white10w700,
                ),
              ),
            ],
          ),
          context.verticalSpace(12),

          // Patient Summary Card
          Container(
            padding: context.appEdgeInsets(all: 12),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: BorderRadius.circular(context.r(12)),
              border: Border.all(color: CustomColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: context.r(20),
                  backgroundColor: CustomColors.lightPurple,
                  backgroundImage: (request.patientImage != null &&
                          request.patientImage!.startsWith('http'))
                      ? CachedNetworkImageProvider(request.patientImage!)
                      : null,
                  child: (request.patientImage == null ||
                          !request.patientImage!.startsWith('http'))
                      ? Text(
                          patientName[0].toUpperCase(),
                          style: context.fonts.purple14w700,
                        )
                      : null,
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: context.fonts.black14w600,
                      ),
                      if (patientEmail.isNotEmpty) ...[
                        context.verticalSpace(2),
                        Text(
                          patientEmail,
                          style: context.fonts.grey12w400,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          context.verticalSpace(12),

          // Simulation Before & After Preview Slider (If Images Exist)
          if (request.frontImageBefore != null ||
              request.frontImageAfter != null) ...[
            Text('Simulation Before / After:', style: context.fonts.black13w600),
            context.verticalSpace(8),
            _buildSimulationViewer(context, request),
            context.verticalSpace(12),
          ],

          // Requested Treatments & Areas
          if (request.treatments.isNotEmpty) ...[
            Text('Requested Treatments & Areas:',
                style: context.fonts.black13w600),
            context.verticalSpace(8),
            ...request.treatments.map((treatment) {
              return Container(
                margin: EdgeInsets.only(bottom: context.h(8)),
                padding: context.appEdgeInsets(all: 10),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(context.r(8)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment.treatmentName,
                      style: context.fonts.purple13w700,
                    ),
                    if (treatment.description != null &&
                        treatment.description!.isNotEmpty) ...[
                      context.verticalSpace(2),
                      Text(
                        treatment.description!,
                        style: context.fonts.grey12w400,
                      ),
                    ],
                    if (treatment.areas.isNotEmpty) ...[
                      context.verticalSpace(8),
                      Wrap(
                        spacing: context.w(6),
                        runSpacing: context.h(6),
                        children: treatment.areas.map((area) {
                          final priceText = area.price != null
                              ? ' (\$${area.price!.toStringAsFixed(0)})'
                              : '';
                          return Container(
                            padding: context.appEdgeInsets(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.lightPurple,
                              borderRadius:
                                  BorderRadius.circular(context.r(6)),
                            ),
                            child: Text(
                              '${area.areaName}$priceText',
                              style: context.fonts.purple11w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );
            }),
            context.verticalSpace(12),
          ],

          // Preferred Appointment Slots
          if (hasSlots) ...[
            Text('Preferred Slots:', style: context.fonts.black13w600),
            context.verticalSpace(8),
            Wrap(
              spacing: context.w(6),
              runSpacing: context.h(6),
              children: request.preferredSlots!.map((slot) {
                return Container(
                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: BorderRadius.circular(context.r(8)),
                    border: Border.all(color: CustomColors.border),
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
            context.verticalSpace(12),
          ],

          // Patient Medical History
          if (hasMedicalHistory) ...[
            Text('Medical History:', style: context.fonts.black13w600),
            context.verticalSpace(8),
            Wrap(
              spacing: context.w(6),
              runSpacing: context.h(6),
              children: [
                if (request.medicalHistory!.allergies.isNotEmpty)
                  _buildMedicalChip(
                    context,
                    'Allergies: ${request.medicalHistory!.allergies.join(", ")}',
                    CustomColors.red,
                  ),
                if (request.medicalHistory!.medicalConditions.isNotEmpty)
                  _buildMedicalChip(
                    context,
                    'Conditions: ${request.medicalHistory!.medicalConditions.join(", ")}',
                    CustomColors.amber,
                  ),
                if (request.medicalHistory!.currentMedications.isNotEmpty)
                  _buildMedicalChip(
                    context,
                    'Medications: ${request.medicalHistory!.currentMedications.join(", ")}',
                    CustomColors.purple,
                  ),
              ],
            ),
            context.verticalSpace(12),
          ],

          // View Full Request Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                context.pushNamed(
                  SharedTreatmentRequestScreen.routeName,
                  queryParameters: {'showBackButton': 'true'},
                );
              },
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: context.sp(16),
                color: CustomColors.purple,
              ),
              label: Text(
                'View Full Request Details',
                style: context.fonts.purple13w700,
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: CustomColors.purple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(8)),
                ),
                padding: context.appEdgeInsets(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationViewer(
    BuildContext context,
    PatientTreatmentRequestData request,
  ) {
    String? beforeUrl = request.frontImageBefore;
    String? afterUrl = request.frontImageAfter;

    if (_selectedView == 'Right') {
      beforeUrl = request.rightImageBefore;
      afterUrl = request.rightImageAfter;
    } else if (_selectedView == 'Left') {
      beforeUrl = request.leftImageBefore;
      afterUrl = request.leftImageAfter;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // View Selector Chips (Front, Left, Right)
        Row(
          children: ['Front', 'Right', 'Left'].map((view) {
            final isSelected = _selectedView == view;
            return Padding(
              padding: EdgeInsets.only(right: context.w(6)),
              child: ChoiceChip(
                label: Text('$view View'),
                selected: isSelected,
                onSelected: (val) {
                  if (val) setState(() => _selectedView = view);
                },
                selectedColor: CustomColors.purple,
                labelStyle: isSelected
                    ? context.fonts.white10w700
                    : context.fonts.black10w600,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
        context.verticalSpace(8),

        if (beforeUrl != null && afterUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: SizedBox(
              height: context.h(180),
              width: double.infinity,
              child: BeforeAfter(
                value: _sliderValue,
                onValueChanged: (val) => setState(() => _sliderValue = val),
                before: CachedNetworkImage(
                  imageUrl: beforeUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: context.h(180),
                  placeholder: (context, url) =>
                      Container(color: CustomColors.softGrey),
                  errorWidget: (context, url, error) =>
                      Container(color: CustomColors.softGrey),
                ),
                after: CachedNetworkImage(
                  imageUrl: afterUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: context.h(180),
                  placeholder: (context, url) =>
                      Container(color: CustomColors.softGrey),
                  errorWidget: (context, url, error) =>
                      Container(color: CustomColors.softGrey),
                ),
              ),
            ),
          )
        else
          Container(
            height: context.h(120),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: BorderRadius.circular(context.r(12)),
            ),
            child: Center(
              child: Text(
                'No $_selectedView view image available',
                style: context.fonts.grey12w400,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMedicalChip(BuildContext context, String text, Color color) {
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
}
