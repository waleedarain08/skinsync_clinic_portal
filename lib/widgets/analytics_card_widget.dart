import 'package:flutter/material.dart';

import '../utils/theme.dart';

class AnalyticsCardWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String value;
  final String label;

  const AnalyticsCardWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(16),
      ),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: context.w(44),
            width: context.w(44),
            padding: EdgeInsets.symmetric(
              horizontal: context.w(10),
              vertical: context.h(10),
            ),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: context.r(23)),
          ),
          SizedBox(width: context.w(12)),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: CustomFonts.black20w600,
                ),
                SizedBox(height: context.h(4)),
                Text(
                  label,
                  style: CustomFonts.grey16w400,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
