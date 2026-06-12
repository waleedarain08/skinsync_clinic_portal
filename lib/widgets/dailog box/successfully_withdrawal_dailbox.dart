import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class SuccessfullyWithdrawalDailogBox extends StatelessWidget {
  const SuccessfullyWithdrawalDailogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.w(360)),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: context.h(24),
              horizontal: context.w(24),
            ),
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.circular(context.r(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
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
                ),
                ClipOval(
                  child: Container(
                    height: context.w(125),
                    width: context.w(125),
                    color: CustomColors.softGrey,
                    child: const Icon(
                      Icons.check,
                      color: CustomColors.green,
                      size: 60,
                    ),
                  ),
                ),
                SizedBox(height: context.h(20)),
                Text(
                  "Successfully Withdrawal!",
                  style: CustomFonts.black30w600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.h(10)),
                Text(
                  "Lorem ipsum dolor sit amet consectetur. Ut consectetur mauris tellus ultricies.",
                  style: CustomFonts.black16w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.h(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
