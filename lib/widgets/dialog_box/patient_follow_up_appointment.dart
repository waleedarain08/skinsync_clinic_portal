import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'follow_up_later_dailog.dart';

import '../../utils/theme.dart';

class PatientFollowUpAppointment extends StatelessWidget {
  const PatientFollowUpAppointment({super.key});

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
              child: SvgPicture.asset(
                SvgAssets.alert,
                height: context.h(66),
                width: context.w(66),
              ),
            ),
            SizedBox(height: context.h(30)),
            Center(
              child: Text(
                "Do patient need follow-up appointment ?",
                textAlign: TextAlign.center,
                style: CustomFonts.black16w500,
              ),
            ),
            SizedBox(height: context.h(30)),
            Row(
              children: [
                Expanded(
                  child: CustomPrimaryButton(
                    onTap: () {
                      context.pop();
                      showDialog(
                        context: context,
                        builder: (context) => const FollowUpLater(),
                      );
                    },
                    label: "Yes",
                  ),
                ),
                SizedBox(width: context.w(10)),
                Expanded(
                  child: CustomOutlinedButton(
                    onTap: () {
                      context.pop();
                    },
                    label: "No",
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
