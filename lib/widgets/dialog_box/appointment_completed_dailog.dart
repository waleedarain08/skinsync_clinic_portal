import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class AppointmentCompletedDailog extends StatelessWidget {
  const AppointmentCompletedDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Appointment Completed",
      width: 600.w,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Treatment Appointment is Completed",
              style: context.fonts.black18w600.copyWith(
                color: CustomColors.purple,
              ),
            ),
            context.verticalSpace(16),
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: context.appBorderRadius(all: 8),
                    child: Image.asset(
                      PngAssets.image,
                      fit: BoxFit.cover,
                      height: 80.h,
                      width: 120.w,
                    ),
                  ),
                  context.horizontalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monday, Feb 03 - 11:00 AM",
                          style: context.fonts.grey13w500,
                        ),
                        Text(
                          "Derma Fillers - Cheeks",
                          style: context.fonts.black14w600,
                        ),
                        Text(
                          "Glow Skin Clinic",
                          style: context.fonts.black13w400,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_file,
                              size: 14.sp,
                              color: CustomColors.grey,
                            ),
                            context.horizontalSpace(4),
                            Expanded(
                              child: Text(
                                "Derma Fillers Cheeks Model",
                                style: context.fonts.black13w400.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: CustomColors.blue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            context.verticalSpace(24),
            Text("Patient Details", style: context.fonts.black16w600),
            context.verticalSpace(12),
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      PngAssets.person,
                      height: 48.w,
                      width: 48.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  context.horizontalSpace(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tiana Botosh", style: context.fonts.black14w600),
                        Text("@tianabotosh", style: context.fonts.grey13w500),
                      ],
                    ),
                  ),
                  Container(
                    padding: context.appEdgeInsets(all: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: CustomColors.white,
                    ),
                    child: SvgPicture.asset(
                      SvgAssets.scan,
                      height: 20.h,
                      width: 20.h,
                      colorFilter: const ColorFilter.mode(
                        CustomColors.purple,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            context.verticalSpace(24),
            Text("Payment Details", style: context.fonts.black16w600),
            context.verticalSpace(12),
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        PngAssets.masterLogo,
                        height: 32.h,
                        width: 48.w,
                      ),
                      context.horizontalSpace(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Master Card", style: context.fonts.black13w600),
                          Text(
                            "**** **** **** 9658",
                            style: context.fonts.grey13w500,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: context.appEdgeInsets(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.green.withValues(alpha: 0.1),
                          borderRadius: context.appBorderRadius(all: 20),
                        ),
                        child: Text("Paid", style: context.fonts.green13w600),
                      ),
                    ],
                  ),
                  context.verticalSpace(16),
                  const Divider(color: CustomColors.border),
                  context.verticalSpace(16),
                  _buildSummaryRow(context, "Subtotal", "AED 65.00"),
                  context.verticalSpace(8),
                  _buildSummaryRow(context, "Platform Fee", "AED 1.00"),
                  context.verticalSpace(12),
                  const Divider(color: CustomColors.border),
                  context.verticalSpace(12),
                  _buildSummaryRow(
                    context,
                    "Total Amount",
                    "AED 61.45",
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? context.fonts.black14w600 : context.fonts.grey13w500,
        ),
        Text(
          value,
          style: isTotal
              ? context.fonts.black16w600.copyWith(color: CustomColors.purple)
              : context.fonts.black14w600,
        ),
      ],
    );
  }
}
