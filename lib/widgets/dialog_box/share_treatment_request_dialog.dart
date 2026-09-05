import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/responses/patient_treatment_request_response.dart';
import '../../utils/theme.dart';
import '../../view_models/patient_view_model.dart';
import '../app_loader.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class ShareTreatmentRequestDialog extends ConsumerStatefulWidget {
  final String patientName;
  final int patientId;

  const ShareTreatmentRequestDialog({
    super.key,
    this.patientName = 'Jane Cooper',
    required this.patientId,
  });

  @override
  ConsumerState<ShareTreatmentRequestDialog> createState() =>
      _ShareTreatmentRequestDialogState();
}

class _ShareTreatmentRequestDialogState
    extends ConsumerState<ShareTreatmentRequestDialog> {
  PatientTreatmentRequestData? _selectedRequest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientProvider.notifier)
          .getPatientTreatmentRequests(
            patientId: widget.patientId,
            showEasyLoading: false,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Select Treatment Request to Share',
      width: 640.w,
      height: 0.5.sh,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select a treatment request of ${widget.patientName} to send into the chat.',
            style: context.fonts.grey13w500,
          ),
          context.verticalSpace(16),
          Expanded(
            child: Consumer(
              builder: (_, ref, _) {
                final state = ref.watch(patientProvider);
                if (state.loading) {
                  return const AppLoader();
                }
                final requests = state.treatmentRequests;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  separatorBuilder: (context, index) =>
                      context.verticalSpace(10),
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    final isSelected = _selectedRequest?.id == req.id;

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
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? CustomColors.purple
                                  : CustomColors.grey,
                              size: context.sp(20),
                            ),
                            context.horizontalSpace(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          req.name,
                                          style: context.fonts.black16w600,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      _buildStatusBadge(
                                        context,
                                        'Pending Review',
                                      ),
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
                                        'SkinSync Clinic',
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
                                        req.createdAt != null
                                            ? req.createdAt!.substring(0, 10)
                                            : 'Recent',
                                        style: context.fonts.grey12w400,
                                      ),
                                    ],
                                  ),
                                  if (req.treatments.isNotEmpty) ...[
                                    context.verticalSpace(8),
                                    Wrap(
                                      spacing: context.w(6),
                                      runSpacing: context.h(4),
                                      children: req.treatments.map((t) {
                                        return Container(
                                          padding: context.appEdgeInsets(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.softGrey,
                                            borderRadius: BorderRadius.circular(
                                              context.r(6),
                                            ),
                                          ),
                                          child: Text(
                                            t.treatmentName,
                                            style: context.fonts.grey11w600,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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
