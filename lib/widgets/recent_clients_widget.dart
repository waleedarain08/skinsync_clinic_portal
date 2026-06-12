import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import '../utils/theme.dart';
import 'client_item_widget.dart';

class RecentClientsWidget extends StatelessWidget {
  const RecentClientsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.12),
            blurRadius: context.r(8),
            offset: Offset(0, context.h(2)),
          ),
        ],
        borderRadius: BorderRadius.circular(context.r(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Clients",
                style: CustomFonts.black20w600,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: CustomFonts.black14w500,
                    ),
                    SizedBox(width: context.w(6)),
                    Icon(
                      CupertinoIcons.arrow_right,
                      size: context.r(14),
                      color: CustomColors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(18)),
          AdaptiveLayoutList(
            isScrollVertical: false,
            spaceHeight: context.h(20),
            spaceWidth: context.w(20),
            horizontalHeight: context.r(80),
            children: const [
              ClientItemWidget(),
              ClientItemWidget(),
              ClientItemWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
