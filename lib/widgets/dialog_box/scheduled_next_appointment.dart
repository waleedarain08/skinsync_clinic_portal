import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import 'select_time_slot_dailog.dart';

import '../../utils/theme.dart';

class ScheduledNextAppointment extends StatelessWidget {
  const ScheduledNextAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.6,
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              children: [
                Container(
                  height: context.h(48),
                  width: context.w(48),
                  padding: EdgeInsets.all(context.w(12)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.lightPurple.withValues(alpha: 0.15),
                  ),
                  child: SvgPicture.asset(
                    SvgAssets.appointment,
                    colorFilter: const ColorFilter.mode(
                      CustomColors.purple,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: context.w(15)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scheduled Next Appointment",
                        style: CustomFonts.black16w600,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet consectetur.",
                        style: CustomFonts.black14w400,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: context.w(32),
                    width: context.w(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Icon(
                      Icons.close,
                      size: context.r(18),
                      color: CustomColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(20)),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: Image.asset(
                DemoAssets.scheduledNextAppointment,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: context.h(20)),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                        showDialog(
                          context: context,
                          builder: (context) => const SelectTimeSlotDialog(),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(12),
                          vertical: context.h(16),
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.black,
                          borderRadius: BorderRadius.circular(context.r(8)),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm Appointment",
                            style: CustomFonts.white14w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(15)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(12),
                          vertical: context.h(16),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomColors.border),
                          borderRadius: BorderRadius.circular(context.r(8)),
                        ),
                        child: Center(
                          child: Text("Cancel", style: CustomFonts.black14w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
