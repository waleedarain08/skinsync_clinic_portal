import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;

  const SuccessDialog({
    super.key,
    this.title = 'Successfully Booked',
    this.description =
        'Your appointment has been successfully scheduled. We have sent a confirmation to your email.',
    this.icon,
  });

  static void show(
    BuildContext context, {
    String? title,
    String? description,
    Widget? icon,
  }) {
    showDialog(
      context: context,
      builder: (_) => SuccessDialog(
        title: title ?? 'Successfully Booked',
        description:
            description ?? 'Your appointment has been successfully scheduled.',
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title:
          "", // Empty title as we use custom center alignment for success state
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
            child:
                icon ??
                Icon(
                  Icons.check_circle_rounded,
                  size: 48.sp,
                  color: CustomColors.green,
                ),
          ),
          context.verticalSpace(24),
          Text(
            title,
            style: context.fonts.black20w600,
            textAlign: TextAlign.center,
          ),
          context.verticalSpace(12),
          Text(
            description,
            style: context.fonts.grey14w400,
            textAlign: TextAlign.center,
          ),
          context.verticalSpace(8),
        ],
      ),
    );
  }
}
