import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import 'show_success_dailog.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class SelectTimeSlotDialog extends StatelessWidget {
  const SelectTimeSlotDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Select Time Slot",
      width: 600.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "We’ll notify you in advance so you’re always prepared. Your journey to glowing skin is just a tap away!",
            style: context.fonts.black14w400,
          ),
          context.verticalSpace(24),
          Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 400.h),
              child: Image.asset(DemoAssets.selectSlot, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: "Cancel",
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () {
            context.pop();
            showDialog(
              context: context,
              builder: (context) => const SuccessDialog(),
            );
          },
          label: "Confirm Appointment",
          width: 220.w,
        ),
      ],
    );
  }
}
