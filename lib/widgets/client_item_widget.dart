import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

class ClientItemWidget extends StatelessWidget {
  const ClientItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(10),
      ),
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: context.r(45),
            backgroundImage: const AssetImage(PngAssets.person),
          ),
          SizedBox(width: context.w(8)),
          Text(
            "John Smith",
            style: CustomFonts.black16w600,
          ),
        ],
      ),
    );
  }
}
