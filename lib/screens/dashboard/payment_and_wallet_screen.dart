import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/payment_history_screen.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/payment_withdrawal_dailog_box.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';

import '../../utils/assets.dart';
import '../../utils/theme.dart';
import '../../widgets/transcation_tile_widget.dart';

class PaymentAndWalletScreen extends StatelessWidget {
  static const String routeName = '/payment-and-wallet';
  const PaymentAndWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(20)),
            Text('Payment and Wallet', style: context.fonts.black20w600),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(20)),
            walletInfo(context),
            SizedBox(height: context.h(10)),
            Text(
              "Payments are processed securely through Stripe. All transactions are encrypted and compliant with PCI DSS and HIPAA standards.",
              style: context.fonts.grey14w400,
            ),
            SizedBox(height: context.h(20)),
            totalEarnings(context),
            SizedBox(height: context.h(20)),
            searchAndFilter(context),
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transactions",
                  style: context.fonts.black20w600,
                ),
                GestureDetector(
                  onTap: () {
                    context.go(PaymentHistoryScreen.routeName);
                  },
                  child: Text(
                    "View All",
                    style: context.fonts.purple14w600.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(20)),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: context.h(15));
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const TranscationTileWidget();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget walletInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(24),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(15)),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0C3987), Color(0xFF6B0DAE)],
        ),
      ),
      child: AdaptiveLayoutRowColumn(
        alignment: MainAxisAlignment.spaceBetween,
        widthBetween: 0,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Available Balance",
                style: context.fonts.white16w400.copyWith(
                  fontSize: context.sp(22),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "AED 228,565",
                style: context.fonts.black40w700.copyWith(
                  color: CustomColors.white,
                  fontSize: context.sp(40),
                ),
              ),
            ],
          ),
          context.isLandscape ? const Spacer() : const SizedBox.shrink(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.arrowtriangle_up_fill,
                size: context.r(14),
                color: CustomColors.green,
              ),
              SizedBox(width: context.w(10)),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "AED 20,600 ",
                      style: context.fonts.green14w600.copyWith(
                        fontSize: context.sp(16),
                      ),
                    ),
                    TextSpan(
                      text: "Last Week ",
                      style: context.fonts.white14w600.copyWith(
                        fontSize: context.sp(16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: context.w(20)),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const PaymentWithDrawalDailogBox(),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(14),
                vertical: context.h(8),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(8)),
                color: CustomColors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    SvgAssets.withdraw,
                    colorFilter: const ColorFilter.mode(
                      CustomColors.purple,
                      BlendMode.srcIn,
                    ),
                    height: context.h(14),
                    width: context.w(16.5),
                  ),
                  SizedBox(width: context.w(8)),
                  Center(
                    child: Text(
                      "Withdraw Balance",
                      style: context.fonts.purple14w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget totalEarnings(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(15),
        vertical: context.h(15),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(15)),
        color: CustomColors.palePurple,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("AED 4,500", style: context.fonts.black30w600),
              Text("Today’s Earnings", style: context.fonts.grey14w500),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Next Deposit Will Be", style: context.fonts.grey14w500),
              Text("Added After 12:00 am", style: context.fonts.grey14w500),
            ],
          ),
        ],
      ),
    );
  }

  Widget searchAndFilter(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: CupertinoSearchTextField(backgroundColor: CustomColors.softGrey),
        ),
        SizedBox(width: context.w(8)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(15),
            vertical: context.h(15),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(10)),
            color: CustomColors.white,
            border: Border.all(color: CustomColors.border),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                SvgAssets.filter,
                height: context.h(13),
                width: context.w(13),
                colorFilter: const ColorFilter.mode(
                  CustomColors.grey,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.w(10)),
              Text("All Status", style: context.fonts.grey14w500),
              SizedBox(width: context.w(10)),
              Icon(
                CupertinoIcons.chevron_down,
                size: context.r(16),
                color: CustomColors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
