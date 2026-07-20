import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import 'show_success_dailog.dart';

import '../../utils/theme.dart';

class SelectTimeSlotDialog extends StatelessWidget {
  const SelectTimeSlotDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
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
                Text("Select Time Slot", style: CustomFonts.black20w600),
                const Spacer(),
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
            SizedBox(height: context.h(10)),
            Text(
              "we’ll notify you in advance so you’re always prepared. Your journey to glowing skin is just a tap away!",
              style: CustomFonts.black14w400,
            ),
            SizedBox(height: context.h(20)),

            SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: Image.asset(DemoAssets.selectSlot, fit: BoxFit.contain),
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
                          builder: (context) => const SuccessDialog(),
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
