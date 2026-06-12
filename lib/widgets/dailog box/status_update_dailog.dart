import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/patient_follow_up_appointment.dart';

import '../../utils/theme.dart';

class StatusUpdateDailog extends StatelessWidget {
  const StatusUpdateDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(354),
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Icon(
                Icons.check_circle_rounded,
                color: CustomColors.green,
                size: context.r(70),
              ),
            ),
            SizedBox(height: context.h(30)),
            Center(
              child: Text(
                "Status has been updated successfully",
                textAlign: TextAlign.center,
                style: CustomFonts.grey18w400,
              ),
            ),
            SizedBox(height: context.h(30)),
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
        ),
      ),
    );
  }
}
