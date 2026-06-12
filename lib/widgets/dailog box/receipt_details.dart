import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class ReceiptDialog extends StatelessWidget {
  const ReceiptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(374),
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: context.w(24)),
                Text(
                  "Receipt Details",
                  style: CustomFonts.black20w600,
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

            SizedBox(height: context.h(15)),
            Divider(color: CustomColors.border),
            SizedBox(height: context.h(15)),

            /// Receipt Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.r(20)),
                  topRight: Radius.circular(context.r(20)),
                ),
                color: CustomColors.lightPurple.withValues(alpha: 0.4),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.w(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Invoice ID #587456",
                          style: CustomFonts.black14w600,
                        ),
                        SizedBox(height: context.h(10)),
                        Text(
                          "25 Dec, 08:00PM",
                          style: CustomFonts.grey14w400,
                        ),
                        SizedBox(height: context.h(78)),
                        Text(
                          "Payment Details",
                          style: CustomFonts.black14w600,
                        ),
                        SizedBox(height: context.h(16)),
                        _row("Botox", "\$ 58.96"),
                        SizedBox(height: context.h(16)),
                        _row("Subtotal", "\$ 58.96"),
                        SizedBox(height: context.h(16)),
                        _row("Platform Fee", "\$ 58.96"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(18),
                vertical: context.h(16),
              ),
              decoration: BoxDecoration(
                color: CustomColors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(context.r(20)),
                  bottomRight: Radius.circular(context.r(20)),
                ),
              ),
              child: _row(
                "Total",
                "\$ 58.96",
                isBold: true,
              ),
            ),
            SizedBox(height: context.h(10)),
          ],
        ),
      ),
    );
  }

  Widget _row(String left, String right, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: isBold
              ? CustomFonts.white14w600
              : CustomFonts.black14w400,
        ),
        Text(
          right,
          style: isBold
              ? CustomFonts.white14w600
              : CustomFonts.black14w400,
        ),
      ],
    );
  }
}
