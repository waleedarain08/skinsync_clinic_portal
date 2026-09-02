import 'package:before_after/before_after.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/chat_message_model.dart';
import '../../screens/dashboard/shared_treatment_request_screen.dart';
import '../../utils/theme.dart';

class SharedRequestChatBubble extends StatefulWidget {
  final ChatMessageModel message;

  const SharedRequestChatBubble({super.key, required this.message});

  @override
  State<SharedRequestChatBubble> createState() =>
      _SharedRequestChatBubbleState();
}

class _SharedRequestChatBubbleState extends State<SharedRequestChatBubble> {
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.isMe;
    final request = widget.message.sharedRequestData;

    if (request == null) {
      return Container(
        padding: context.appEdgeInsets(all: 16),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(color: CustomColors.border),
        ),
        child: Text(
          widget.message.text.isNotEmpty
              ? widget.message.text
              : 'Shared Treatment Request Data Unavailable',
          style: context.fonts.black14w400,
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(520)),
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
                        request.name.isNotEmpty
                            ? request.name
                            : 'Shared Treatment Request',
                        style: context.fonts.purple13w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context, 'Pending Review'),
            ],
          ),
          context.verticalSpace(12),

          if (widget.message.text.isNotEmpty) ...[
            Text(
              widget.message.text,
              style: context.fonts.black14w400,
            ),
            context.verticalSpace(12),
          ],

          // Patient Summary Info Box
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
                          request.patientName != null &&
                                  request.patientName!.isNotEmpty
                              ? request.patientName![0].toUpperCase()
                              : 'P',
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
                        request.patientName ?? 'Jane Cooper',
                        style: context.fonts.black14w600,
                      ),
                      if (request.patientEmail != null) ...[
                        context.verticalSpace(2),
                        Text(
                          request.patientEmail!,
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
          if (request.frontImageBefore != null &&
              request.frontImageAfter != null) ...[
            Text('Simulation Before / After:', style: context.fonts.black13w600),
            context.verticalSpace(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(context.r(12)),
              child: SizedBox(
                height: context.h(180),
                width: double.infinity,
                child: BeforeAfter(
                  value: _sliderValue,
                  onValueChanged: (val) => setState(() => _sliderValue = val),
                  before: CachedNetworkImage(
                    imageUrl: request.frontImageBefore!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: context.h(180),
                    placeholder: (context, url) =>
                        Container(color: CustomColors.softGrey),
                    errorWidget: (context, url, error) =>
                        Container(color: CustomColors.softGrey),
                  ),
                  after: CachedNetworkImage(
                    imageUrl: request.frontImageAfter!,
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
            ),
            context.verticalSpace(12),
          ],

          // Treatments & Areas Breakdown
          if (request.treatments.isNotEmpty) ...[
            Text('Requested Treatments:', style: context.fonts.black13w600),
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
                          final materialText = area.materials.isNotEmpty
                              ? ' (${area.materials.first.name}: ${area.materials.first.selectedQuantity})'
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
                              '${area.areaName}$materialText',
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

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color badgeColor = CustomColors.purple;
    Color bgColor = CustomColors.lightPurple;

    if (status.toLowerCase().contains('approved') ||
        status.toLowerCase().contains('completed')) {
      badgeColor = CustomColors.green;
      bgColor = CustomColors.green.withValues(alpha: 0.1);
    } else if (status.toLowerCase().contains('pending')) {
      badgeColor = CustomColors.amber;
      bgColor = CustomColors.amber.withValues(alpha: 0.1);
    }

    return Container(
      padding: context.appEdgeInsets(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Text(
        status,
        style: context.fonts.black12w600.copyWith(color: badgeColor),
      ),
    );
  }
}
