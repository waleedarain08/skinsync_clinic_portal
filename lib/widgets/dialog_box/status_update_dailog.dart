import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../custom_primary_button.dart';
import 'patient_follow_up_appointment.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class StatusUpdateDailog extends StatelessWidget {
  const StatusUpdateDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "", // Success state uses centered content
      showCloseButton: true,
      width: 440.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.whiteGrey,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: CustomColors.green,
              size: 48.sp,
            ),
          ),
          context.verticalSpace(24),
          Text(
            "Status Updated Successfully",
            style: context.fonts.black20w600,
            textAlign: TextAlign.center,
          ),
          context.verticalSpace(12),
          Text(
            "The appointment status has been updated and the patient has been notified.",
            style: context.fonts.grey14w400,
            textAlign: TextAlign.center,
          ),
          context.verticalSpace(8),
        ],
      ),
      actions: [
        CustomPrimaryButton(
          onTap: () {
            context.pop();
            showDialog(
              context: context,
              builder: (context) => const PatientFollowUpAppointment(),
            );
          },
          label: "OK",
          width: double.infinity,
        ),
      ],
    );
  }
}
