import 'package:flutter/material.dart';

import '../utils/assets.dart';
import '../utils/theme.dart';

class AppointmentHorizontalTileWidget extends StatelessWidget {
  const AppointmentHorizontalTileWidget({
    super.key,
    required this.index,
    this.selected = false,
  });

  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: context.w(24)),
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? CustomColors.purple : CustomColors.border,
          width: 0.5,
        ),
        color: selected
            ? CustomColors.purple.withValues(alpha: 0.3)
            : CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: context.w(12)),
      child: Center(
        child: index == 0
            ? Text(
                "All Appointments",
                style: CustomFonts.black14w600,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      DemoAssets.person,
                      height: context.w(32),
                      width: context.w(32),
                    ),
                  ),
                  SizedBox(width: context.w(10)),
                  Text(
                    "Nolan Aminoff",
                    style: CustomFonts.black14w600,
                  ),
                ],
              ),
      ),
    );
  }
}
