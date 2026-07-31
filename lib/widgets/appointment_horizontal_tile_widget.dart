import 'package:flutter/material.dart';

import '../models/responses/practitioner_list_response.dart';
import '../utils/theme.dart';
import 'app_network_image.dart';

class AppointmentHorizontalTileWidget extends StatelessWidget {
  const AppointmentHorizontalTileWidget({
    super.key,
    this.practitioner,
    required this.selected,
    this.onTap,
  });

  final PractitionerListItem? practitioner;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isAll = practitioner == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.r(20)),
      child: Container(
        margin: EdgeInsets.only(right: context.w(24)),
        padding: EdgeInsets.symmetric(horizontal: context.w(12)),
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
        child: Center(
          child: isAll
              ? Text("All Appointments", style: CustomFonts.black14w600)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: AppNetworkImage(
                        imageUrl: practitioner?.image ?? '',
                        width: context.w(32),
                        height: context.w(32),
                        fit: BoxFit.cover,
                        errorIcon: Icons.person,
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Text(
                      practitioner!.name,
                      style: CustomFonts.black14w600,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
