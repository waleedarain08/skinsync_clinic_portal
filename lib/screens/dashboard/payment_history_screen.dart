import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/transcation_tile_widget.dart';

class PaymentHistoryScreen extends StatelessWidget {
  static const String routeName = '/payment-history';
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: context.r(20)),
                ),
                SizedBox(width: context.w(16)),
                Text("Transaction History", style: context.fonts.level2Heading),
              ],
            ),
            context.verticalSpace(32),
            const Divider(color: CustomColors.border),
            context.verticalSpace(32),
            searchAndFilter(context),
            context.verticalSpace(32),
            Text("Recent Transactions", style: context.fonts.subHeading),
            context.verticalSpace(24),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(15)),
                    child: const TranscationTileWidget(),
                  );
                },
              ),
            ],
          ),
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
