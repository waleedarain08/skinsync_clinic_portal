import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;

  const SuccessDialog({
    super.key,
    this.title = 'Successfully Booked',
    this.description =
        'Lorem ipsum dolor sit amet consectetur Ut consectetur mauris tellus ultricies.',
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
            description ??
            'Lorem ipsum dolor sit amet consectetur Ut consectetur mauris tellus ultricies.',
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.3,
        padding: EdgeInsets.symmetric(
          vertical: context.h(28),
          horizontal: context.w(24),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Close button
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
                  child: Icon(Icons.close, size: context.r(16), color: CustomColors.grey),
                ),
              ),
            ),
            SizedBox(height: context.h(8)),

            /// Icon
            Container(
              width: context.w(90),
              height: context.w(90),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.softGrey,
              ),
              child: icon ??
                  Icon(
                    Icons.calendar_month_rounded,
                    size: context.r(48),
                    color: CustomColors.blue,
                  ),
            ),
            SizedBox(height: context.h(20)),

            /// Title
            Text(
              title,
              style: CustomFonts.black20w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(10)),

            /// Description
            Text(
              description,
              style: CustomFonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(8)),
          ],
        ),
      ),
    );
  }
}
