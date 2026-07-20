import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class ReceiptDialog extends StatelessWidget {
  const ReceiptDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Receipt Details",
      width: 440.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: context.appBorderRadius(all: 16),
              color: CustomColors.whiteGrey,
              border: Border.all(color: CustomColors.border),
            ),
            child: Column(
              children: [
                Padding(
                  padding: context.appEdgeInsets(all: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Invoice ID #587456",
                            style: context.fonts.black14w600,
                          ),
                          Text(
                            "25 Dec, 08:00PM",
                            style: context.fonts.grey13w500,
                          ),
                        ],
                      ),
                      context.verticalSpace(24),
                      Text("Payment Summary", style: context.fonts.black16w600),
                      context.verticalSpace(16),
                      _row(context, "Botox", "AED 58.96"),
                      context.verticalSpace(12),
                      _row(context, "Subtotal", "AED 58.96"),
                      context.verticalSpace(12),
                      _row(context, "Platform Fee", "AED 1.00"),
                    ],
                  ),
                ),
                Container(
                  padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.purple,
                    borderRadius: context.appBorderRadius(
                      bottomLeft: 16,
                      bottomRight: 16,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: context.fonts.white14w600),
                      Text("AED 59.96", style: context.fonts.white14w600),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left, style: context.fonts.grey13w500),
        Text(right, style: context.fonts.black14w600),
      ],
    );
  }
}
