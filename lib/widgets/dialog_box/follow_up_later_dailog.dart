import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import 'scheduled_next_appointment.dart';

import '../../utils/theme.dart';

class FollowUpLater extends StatelessWidget {
  const FollowUpLater({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(360),
        padding: EdgeInsets.symmetric(
          vertical: context.h(30),
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
              child: Image.asset(
                PngAssets.appointmentCalendar,
                height: context.h(66),
                width: context.w(60),
              ),
            ),
            SizedBox(height: context.h(30)),
            Center(
              child: Text(
                "Do you want to schedule follow-up appointment now or do it later ?",
                textAlign: TextAlign.center,
                style: CustomFonts.black16w500,
              ),
            ),
            SizedBox(height: context.h(30)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                      showDialog(
                        context: context,
                        builder: (context) => const ScheduledNextAppointment(),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: context.h(13)),
                      decoration: BoxDecoration(
                        color: CustomColors.black,
                        borderRadius: BorderRadius.circular(context.r(30)),
                      ),
                      child: Text("Yes", style: CustomFonts.white14w600),
                    ),
                  ),
                ),
                SizedBox(width: context.w(10)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: context.h(13)),
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomColors.border),
                        borderRadius: BorderRadius.circular(context.r(30)),
                      ),
                      child: Text("No", style: CustomFonts.black14w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
