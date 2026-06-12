import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';

import '../../utils/theme.dart';

class AppointmentCompletedDailog extends StatefulWidget {
  const AppointmentCompletedDailog({super.key});

  @override
  State<AppointmentCompletedDailog> createState() =>
      _AppointmentCompletedDailogState();
}

class _AppointmentCompletedDailogState
    extends State<AppointmentCompletedDailog> {
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
            children: [
              SizedBox(height: context.h(10)),
              Text(
                "Your Treatment Appointment is Completed",
                style: CustomFonts.black30w600,
              ),
              SizedBox(height: context.h(12)),
              Container(
                padding: EdgeInsets.all(context.w(6)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(15)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      PngAssets.image,
                      fit: BoxFit.fill,
                      height: context.h(105),
                      width: context.w(151),
                    ),
                    SizedBox(width: context.w(21)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Monday, Feb 03 - 11:00 AM",
                            style: CustomFonts.black14w500,
                          ),
                          Text(
                            "Derma Fillers - Cheeks",
                            style: CustomFonts.black14w600,
                          ),
                          Text(
                            "Glow Skin Clinic",
                            style: CustomFonts.black14w400,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                size: context.r(12),
                                color: CustomColors.grey,
                              ),
                              Expanded(
                                child: Text(
                                  " Derma Fillers Cheeks Model",
                                  style: CustomFonts.black14w400.copyWith(
                                    decoration: TextDecoration.underline,
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
              SizedBox(height: context.h(20)),
              Divider(height: 0, color: CustomColors.border),
              SizedBox(height: context.h(20)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(18),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(16)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        PngAssets.person,
                        height: context.w(60),
                        width: context.w(60),
                      ),
                    ),
                    SizedBox(width: context.w(18)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tiana Botosh", style: CustomFonts.black20w600),
                          Text("@tianabotosh", style: CustomFonts.grey16w400),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(context.r(10)),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.softGrey,
                      ),
                      child: SvgPicture.asset(
                        SvgAssets.scan,
                        height: context.h(20),
                        width: context.w(24),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(20)),
              Text("Payment Details", style: CustomFonts.black20w600),
              SizedBox(height: context.h(20)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(17),
                  vertical: context.h(18),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(15)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          PngAssets.masterLogo,
                          height: context.h(62),
                          width: context.w(62),
                        ),
                        SizedBox(width: context.w(12)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Master Card", style: CustomFonts.black14w600),
                            SizedBox(height: context.h(4)),
                            Text(
                              "5689470025899658",
                              style: CustomFonts.black14w600,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(24),
                            vertical: context.h(6),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(context.r(50)),
                            color: CustomColors.green.withValues(alpha: 0.2),
                          ),
                          child: Text(
                            "Paid",
                            style: CustomFonts.purple14w600.copyWith(
                              color: CustomColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(22)),
                    Divider(height: 0, color: CustomColors.border),
                    SizedBox(height: context.h(22)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal", style: CustomFonts.grey14w500),
                        Text("AED 65.00", style: CustomFonts.black14w500),
                      ],
                    ),
                    SizedBox(height: context.h(22)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Platform Fee", style: CustomFonts.grey14w500),
                        Text("AED 1.00", style: CustomFonts.black14w500),
                      ],
                    ),
                    SizedBox(height: context.h(9)),
                    Divider(height: 0, color: CustomColors.border),
                    SizedBox(height: context.h(14)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Amount", style: CustomFonts.black20w600),
                        Text("AED 61.45", style: CustomFonts.black20w600),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}
