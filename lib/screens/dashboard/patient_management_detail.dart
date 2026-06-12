import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/patient_management.dart';
import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/widgets/pateint_treatment_selection_tile.dart';

import '../../utils/assets.dart';

class PatientManagementDetailScreen extends StatelessWidget {
  static const String path = 'details';
  static const String routeName =
      '${PatientManagementScreen.routeName}/details';
  const PatientManagementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.arrow_back, size: 24.sp),
                ),
                SizedBox(width: 10.w),
                Text("Patient Management", style: CustomFonts.black20w600),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                patientSelection(),
                SizedBox(width: 28.9.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      treamentInfo(context: context),
                      SizedBox(height: 19.h),
                      // Replace the old container with the new stepper
                      TreatmentJourneyStepper(steps: _getTreatmentSteps()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to provide treatment steps data
  List<TreatmentStep> _getTreatmentSteps() {
    return [
      TreatmentStep(
        title: "Botox Treatment",
        description:
            "Mild swelling or redness is normal. Follow aftercare tips for best results.",
        date: "02 Feb 2025",
        imageAsset: PngAssets.treatmentImage,
        isCompleted: true,
      ),
      TreatmentStep(
        title: "Botox Treatment",
        description:
            "Mild swelling or redness is normal. Follow aftercare tips for best results.",
        date: "02 Feb 2025",
        imageAsset: PngAssets.treatmentImage,
        isCompleted: true,
      ),
      TreatmentStep(
        title: "Botox Treatment",
        description:
            "Mild swelling or redness is normal. Follow aftercare tips for best results.",
        date: "02 Feb 2025",
        imageAsset: PngAssets.treatmentImage,
        isCompleted: true,
      ),
      TreatmentStep(
        title: "Botox Treatment",
        description:
            "Mild swelling or redness is normal. Follow aftercare tips for best results.",
        date: "02 Feb 2025",
        imageAsset: PngAssets.treatmentImage,
        isCompleted: true,
      ),
    ];
  }

  Widget treamentInfo({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 248.w,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(PngAssets.treatmentImage),
              ),
            ),
          ),
          SizedBox(height: 19.h),
          Text("Derma Fillers - Cheeks", style: CustomFonts.black30w600),
          Text("Glow Skin Clinic", style: CustomFonts.black20w500),
          SizedBox(height: 11.h),
          Text(
            "Enhance your natural beauty by adding volume, smoothing wrinkles, and contouring areas like cheeks, lips, and under-eyes for a youthful, refreshed look.",
            style: CustomFonts.black16w400,
          ),
        ],
      ),
    );
  }

  Widget patientSelection() {
    return SizedBox(
      width: 386.w,
      child: Column(
        children: [
          CupertinoSearchTextField(backgroundColor: Color(0xFFF3F3F5)),
          SizedBox(height: 14.h),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return PatientTreatmentSelectionTile();
            },
          ),
        ],
      ),
    );
  }
}

// Data Model
class TreatmentStep {
  final String title;
  final String description;
  final String date;
  final String imageAsset;
  final bool isCompleted;

  TreatmentStep({
    required this.title,
    required this.description,
    required this.date,
    required this.imageAsset,
    this.isCompleted = true,
  });
}

// Stepper Widget
class TreatmentJourneyStepper extends StatelessWidget {
  final List<TreatmentStep> steps;

  const TreatmentJourneyStepper({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Treatment Journey", style: CustomFonts.black20w600),
          SizedBox(height: 20.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final isLast = index == steps.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stepper indicator column
                  Column(
                    children: [
                      Container(
                        width: 27.w,
                        height: 27.h,
                        decoration: BoxDecoration(
                          color: steps[index].isCompleted
                              ? CustomColors.purple
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 14.w,
                          color: Colors.white,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          height: 148.h,
                          width: 1.w,
                          color: Colors.grey.shade400,
                        ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  // Content
                  Expanded(
                    child: Column(
                      children: [
                        TreatmentCard(step: steps[index]),
                        if (!isLast) SizedBox(height: 18.h),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Treatment Card Widget
class TreatmentCard extends StatelessWidget {
  final TreatmentStep step;

  const TreatmentCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffDEF8FF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),
                  Text(step.title, style: CustomFonts.black18w600),
                  SizedBox(height: 11.h),
                  Text(step.description, style: CustomFonts.black16w400),
                  SizedBox(height: 34.h),
                  Text(step.date, style: CustomFonts.black16w500),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: 144.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                step.imageAsset,
                height: 144.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
