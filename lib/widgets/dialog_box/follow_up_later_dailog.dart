import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import 'scheduled_next_appointment.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class FollowUpLater extends StatelessWidget {
  const FollowUpLater({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Follow-up Appointment",
      width: 440.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.asset(
              PngAssets.appointmentCalendar,
              height: 100.h,
              fit: BoxFit.contain,
            ),
          ),
          context.verticalSpace(24),
          Text(
            "Do you want to schedule a follow-up appointment now or do it later?",
            textAlign: TextAlign.center,
            style: context.fonts.black16w500,
          ),
        ],
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => context.pop(),
          label: "Later",
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () {
            context.pop();
            showDialog(
              context: context,
              builder: (context) => const ScheduledNextAppointment(),
            );
          },
          label: "Schedule Now",
          width: 160.w,
        ),
      ],
    );
  }
}
