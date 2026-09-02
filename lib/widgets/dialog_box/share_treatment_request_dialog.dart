import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/dummy/chat_dummy_model.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class ShareTreatmentRequestDialog extends StatefulWidget {
  final String patientName;

  const ShareTreatmentRequestDialog({
    super.key,
    this.patientName = 'Jane Cooper',
  });

  @override
  State<ShareTreatmentRequestDialog> createState() =>
      _ShareTreatmentRequestDialogState();
}

class _ShareTreatmentRequestDialogState
    extends State<ShareTreatmentRequestDialog> {
  late final List<ChatSharedRequestData> _requests;
  ChatSharedRequestData? _selectedRequest;

  @override
  void initState() {
    super.initState();
    // Dummy treatment requests for the patient
    _requests = [
      ChatSharedRequestData(
        requestId: 102,
        patientName: widget.patientName,
        treatmentName: 'Botox & Dermal Fillers Combo',
        dateShared: 'Aug 28, 2026',
        status: 'Pending Review',
        clinicName: 'Aesthetic Beauty Center',
      ),
      ChatSharedRequestData(
        requestId: 105,
        patientName: widget.patientName,
        treatmentName: 'Laser Skin Resurfacing & Hydrafacial',
        dateShared: 'Aug 20, 2026',
        status: 'Approved',
        clinicName: 'SkinSync Aesthetic Clinic',
      ),
      ChatSharedRequestData(
        requestId: 108,
        patientName: widget.patientName,
        treatmentName: 'Chemical Peel & Anti-Aging Protocol',
        dateShared: 'Aug 15, 2026',
        status: 'Completed',
        clinicName: 'Aesthetic Care Center',
      ),
    ];

    // Default select first request
    if (_requests.isNotEmpty) {
      _selectedRequest = _requests.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Select Treatment Request to Share',
      width: 620.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select a treatment request of ${widget.patientName} to send into the chat.',
            style: context.fonts.grey13w500,
          ),
          context.verticalSpace(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _requests.length,
            separatorBuilder: (context, index) => context.verticalSpace(10),
            itemBuilder: (context, index) {
              final req = _requests[index];
              final isSelected = _selectedRequest?.requestId == req.requestId;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedRequest = req;
                  });
                },
                borderRadius: BorderRadius.circular(context.r(12)),
                child: Container(
                  padding: context.appEdgeInsets(all: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColors.lightPurple.withValues(alpha: 0.5)
                        : CustomColors.white,
                    borderRadius: BorderRadius.circular(context.r(12)),
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.purple
                          : CustomColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Radio<ChatSharedRequestData>(
                        value: req,
                        groupValue: _selectedRequest,
                        activeColor: CustomColors.purple,
                        onChanged: (val) {
                          setState(() {
                            _selectedRequest = val;
                          });
                        },
                      ),
                      context.horizontalSpace(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    req.treatmentName,
                                    style: context.fonts.black16w600,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildStatusBadge(context, req.status),
                              ],
                            ),
                            context.verticalSpace(4),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.hospital,
                                  size: context.sp(14),
                                  color: CustomColors.grey,
                                ),
                                context.horizontalSpace(6),
                                Text(
                                  req.clinicName,
                                  style: context.fonts.grey12w400,
                                ),
                                context.horizontalSpace(12),
                                Icon(
                                  Iconsax.calendar_1,
                                  size: context.sp(14),
                                  color: CustomColors.grey,
                                ),
                                context.horizontalSpace(6),
                                Text(
                                  req.dateShared,
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'Cancel',
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () {
            if (_selectedRequest != null) {
              Navigator.of(context).pop(_selectedRequest);
            }
          },
          label: 'Share Request',
          width: 160.w,
        ),
      ],
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
