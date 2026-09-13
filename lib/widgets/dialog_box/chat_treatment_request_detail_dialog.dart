import 'package:before_after/before_after.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/chat_treatment_request_model.dart';
import '../../utils/theme.dart';
import '../borderd_container_widget.dart';
import '../custom_outlined_button.dart';
import 'standard_dialog.dart';

class ChatTreatmentRequestDetailDialog extends StatefulWidget {
  final ChatTreatmentRequestModel request;

  const ChatTreatmentRequestDetailDialog({
    super.key,
    required this.request,
  });

  @override
  State<ChatTreatmentRequestDetailDialog> createState() =>
      _ChatTreatmentRequestDetailDialogState();
}

class _ChatTreatmentRequestDetailDialogState
    extends State<ChatTreatmentRequestDetailDialog> {
  double _sliderValue = 0.5;
  String _selectedView = 'Front';

  @override
  Widget build(BuildContext context) {
    final req = widget.request;
    final patientName = req.patientName?.isNotEmpty == true
        ? req.patientName!
        : 'Patient Details';
    final patientEmail = req.patientEmail ?? '';

    final hasSimulations = (req.frontImageBefore?.isNotEmpty == true ||
        req.frontImageAfter?.isNotEmpty == true ||
        req.rightImageBefore?.isNotEmpty == true ||
        req.rightImageAfter?.isNotEmpty == true ||
        req.leftImageBefore?.isNotEmpty == true ||
        req.leftImageAfter?.isNotEmpty == true);

    return StandardDialog(
      title: 'Treatment Request Details #${req.id}',
      width: 660.w,
      height: 0.8.sh,
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'Close',
          width: 120.w,
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient & Request Overview Card
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 16),
              backgroundColor: CustomColors.whiteGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: context.r(22),
                            backgroundColor: CustomColors.lightPurple,
                            backgroundImage: (req.patientImage != null &&
                                    req.patientImage!.startsWith('http'))
                                ? CachedNetworkImageProvider(req.patientImage!)
                                : null,
                            child: (req.patientImage == null ||
                                    !req.patientImage!.startsWith('http'))
                                ? Text(
                                    patientName[0].toUpperCase(),
                                    style: context.fonts.purple14w700,
                                  )
                                : null,
                          ),
                          context.horizontalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(patientName,
                                  style: context.fonts.black16w600),
                              if (patientEmail.isNotEmpty) ...[
                                context.verticalSpace(2),
                                Text(patientEmail,
                                    style: context.fonts.grey12w400),
                              ],
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: context.appEdgeInsets(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.purple,
                          borderRadius: BorderRadius.circular(context.r(12)),
                        ),
                        child: Text(
                          'Option: ${req.name}',
                          style: context.fonts.white12w700,
                        ),
                      ),
                    ],
                  ),
                  if (req.createdAt != null && req.createdAt!.isNotEmpty) ...[
                    const Divider(height: 24, color: CustomColors.border),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: CustomColors.grey,
                        ),
                        context.horizontalSpace(6),
                        Text(
                          'Created: ${req.createdAt}',
                          style: context.fonts.grey12w400,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            context.verticalSpace(16),

            // Simulation Comparison Viewer
            if (hasSimulations) ...[
              Text(
                'Simulation Before / After Comparisons',
                style: context.fonts.black16w600,
              ),
              context.verticalSpace(10),
              _buildSimulationViewer(context, req),
              context.verticalSpace(16),
            ],

            // Treatments, Areas & Materials Breakdown
            Text(
              'Requested Treatments & Area Details',
              style: context.fonts.black16w600,
            ),
            context.verticalSpace(10),
            if (req.treatments.isEmpty)
              Padding(
                padding: context.appEdgeInsets(vertical: 12),
                child: Text(
                  'No specific treatments attached to this request.',
                  style: context.fonts.grey14w400,
                ),
              )
            else
              ...req.treatments.map((t) => _buildTreatmentCard(context, t)),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentCard(BuildContext context, ChatTreatmentData t) {
    return BorderdContainerWidget(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: context.appEdgeInsets(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (t.icon != null && t.icon!.startsWith('http')) ...[
                CachedNetworkImage(
                  imageUrl: t.icon!,
                  width: context.w(28),
                  height: context.w(28),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.medical_services_outlined,
                    color: CustomColors.purple,
                  ),
                ),
                context.horizontalSpace(10),
              ],
              Expanded(
                child: Text(
                  t.treatmentName,
                  style: context.fonts.purple16w700,
                ),
              ),
            ],
          ),
          if (t.description != null && t.description!.isNotEmpty) ...[
            context.verticalSpace(6),
            Text(t.description!, style: context.fonts.grey13w500),
          ],
          if (t.areas.isNotEmpty) ...[
            const Divider(height: 24, color: CustomColors.border),
            Text('Target Areas & Materials:', style: context.fonts.black14w600),
            context.verticalSpace(10),
            ...t.areas.map((area) => _buildAreaTile(context, area)),
          ],
        ],
      ),
    );
  }

  Widget _buildAreaTile(BuildContext context, ChatTreatmentAreaData area) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(8)),
      padding: context.appEdgeInsets(all: 12),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(context.r(8)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.center_focus_strong,
                    size: 16,
                    color: CustomColors.purple,
                  ),
                  context.horizontalSpace(8),
                  Text(area.areaName, style: context.fonts.black14w600),
                ],
              ),
              if (area.price != null)
                Text(
                  '\$${area.price!.toStringAsFixed(2)}',
                  style: context.fonts.purple14w700,
                ),
            ],
          ),
          if (area.materials.isNotEmpty) ...[
            context.verticalSpace(8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: area.materials.map((m) {
                return Container(
                  padding: context.appEdgeInsets(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.lightPurple,
                    borderRadius: BorderRadius.circular(context.r(6)),
                    border: Border.all(
                      color: CustomColors.purple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    'Material: ${m.name} [Qty: ${m.selectedQuantity}]',
                    style: context.fonts.purple12w600,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSimulationViewer(
    BuildContext context,
    ChatTreatmentRequestModel req,
  ) {
    String? beforeUrl = req.frontImageBefore;
    String? afterUrl = req.frontImageAfter;

    if (_selectedView == 'Right') {
      beforeUrl = req.rightImageBefore;
      afterUrl = req.rightImageAfter;
    } else if (_selectedView == 'Left') {
      beforeUrl = req.leftImageBefore;
      afterUrl = req.leftImageAfter;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: ['Front', 'Right', 'Left'].map((view) {
            final isSelected = _selectedView == view;
            return Padding(
              padding: EdgeInsets.only(right: context.w(8)),
              child: ChoiceChip(
                label: Text('$view View'),
                selected: isSelected,
                onSelected: (val) {
                  if (val) setState(() => _selectedView = view);
                },
                selectedColor: CustomColors.purple,
                labelStyle: isSelected
                    ? context.fonts.white12w700
                    : context.fonts.black12w600,
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
        context.verticalSpace(10),
        if (beforeUrl != null &&
            beforeUrl.isNotEmpty &&
            afterUrl != null &&
            afterUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: SizedBox(
              height: context.h(240),
              width: double.infinity,
              child: BeforeAfter(
                value: _sliderValue,
                onValueChanged: (val) => setState(() => _sliderValue = val),
                before: CachedNetworkImage(
                  imageUrl: beforeUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: context.h(240),
                  placeholder: (context, url) =>
                      Container(color: CustomColors.softGrey),
                  errorWidget: (context, url, error) =>
                      Container(color: CustomColors.softGrey),
                ),
                after: CachedNetworkImage(
                  imageUrl: afterUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: context.h(240),
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
            height: context.h(140),
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: BorderRadius.circular(context.r(12)),
            ),
            child: Center(
              child: Text(
                'No $_selectedView view image available for this simulation',
                style: context.fonts.grey14w400,
              ),
            ),
          ),
      ],
    );
  }
}
