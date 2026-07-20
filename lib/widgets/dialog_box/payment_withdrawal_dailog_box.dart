import 'package:flutter/material.dart';
import '../custom_primary_button.dart';
import 'successfully_withdrawal_dailbox.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class PaymentWithDrawalDailogBox extends StatelessWidget {
  const PaymentWithDrawalDailogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Withdraw Balance",
      width: 520.w,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: CustomColors.border),
            context.verticalSpace(30),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text("\$", style: context.fonts.black50w600),
                    context.horizontalSpace(8),
                    IntrinsicWidth(
                      child: TextFormField(
                        style: context.fonts.black50w600,
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: "0",
                          hintStyle: context.fonts.black50w600.copyWith(
                            color: CustomColors.lightGrey,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                        ),
                      ),
                    ),
                    context.horizontalSpace(8),
                    Text("USD", style: context.fonts.black30w600),
                  ],
                ),
                context.verticalSpace(40),
                const Divider(color: CustomColors.border),
                context.verticalSpace(24),
                _buildInfoRow(context, "Available to withdraw", "\$226,565"),
                context.verticalSpace(12),
                _buildInfoRow(context, "Service Charges", "\$2"),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CustomPrimaryButton(
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => const SuccessfullyWithdrawalDailogBox(),
            );
          },
          label: "Withdraw Funds",
          width: 200.w,
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.fonts.grey13w500),
          Text(value, style: context.fonts.black14w600),
        ],
      ),
    );
  }
}
