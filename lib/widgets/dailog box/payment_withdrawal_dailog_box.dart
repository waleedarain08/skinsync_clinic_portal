import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/successfully_withdrawal_dailbox.dart';

import '../../utils/theme.dart';

class PaymentWithDrawalDailogBox extends StatelessWidget {
  const PaymentWithDrawalDailogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(520),
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Withdraw Balance", style: CustomFonts.black30w600),
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

              SizedBox(height: context.h(30)),
              Divider(color: CustomColors.border),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(16),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: context.h(80)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("\$", style: CustomFonts.black50w600),
                        IntrinsicWidth(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 10,
                              maxWidth: context.w(310),
                            ),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                TextFormField(
                                  maxLines: null,
                                  minLines: 1,
                                  textAlign: TextAlign.left,
                                  style: CustomFonts.black50w600,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintText: '0',
                                    hintStyle: CustomFonts.black50w600.copyWith(
                                      color: CustomColors.lightGrey,
                                    ),
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(5)),
                        Text(
                          "USD",
                          textAlign: TextAlign.end,
                          style: CustomFonts.black30w600,
                        )
                      ],
                    ),
                    SizedBox(height: context.h(80)),
                    Divider(color: CustomColors.border),
                    SizedBox(height: context.w(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Available to withdraw",
                            style: CustomFonts.black18w600,
                          ),
                          Text(
                            "\$226,565",
                            style: CustomFonts.black18w600,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: context.w(10)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Service Charges",
                            style: CustomFonts.black18w600,
                          ),
                          Text(
                            "\$2",
                            style: CustomFonts.black18w600,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: context.h(75)),

                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.w(50)),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const SuccessfullyWithdrawalDailogBox(),
                            );
                          },
                          child: const Text("Withdraw Funds"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.h(20)),
            ],
          ),
        ),
      ),
    );
  }
}
