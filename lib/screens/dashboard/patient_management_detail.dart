import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/patient_management.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(Icons.arrow_back, size: context.r(24)),
                ),
                SizedBox(width: context.w(10)),
                Text("Patient Management", style: context.fonts.black20w600),
              ],
            ),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                patientSelection(context),
                SizedBox(width: context.w(24)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      treamentInfo(context: context),
                      SizedBox(height: context.h(20)),
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
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: context.h(248),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.r(10)),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(PngAssets.treatmentImage),
              ),
            ),
          ),
          SizedBox(height: context.h(20)),
          Text("Derma Fillers - Cheeks", style: context.fonts.black30w600),
          Text("Glow Skin Clinic", style: context.fonts.black20w500),
          SizedBox(height: context.h(12)),
          Text(
            "Enhance your natural beauty by adding volume, smoothing wrinkles, and contouring areas like cheeks, lips, and under-eyes for a youthful, refreshed look.",
            style: context.fonts.black16w400,
          ),
        ],
      ),
    );
  }

  Widget patientSelection(BuildContext context) {
    return SizedBox(
      width: context.w(386),
      child: Column(
        children: [
          const CupertinoSearchTextField(backgroundColor: CustomColors.softGrey),
          SizedBox(height: context.h(14)),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: context.h(12)),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return const PatientTreatmentSelectionTile();
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
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Treatment Journey", style: context.fonts.black20w600),
          SizedBox(height: context.h(20)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                        width: context.w(27),
                        height: context.w(27),
                        decoration: BoxDecoration(
                          color: steps[index].isCompleted
                              ? CustomColors.purple
                              : CustomColors.softGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: context.r(14),
                          color: CustomColors.white,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          height: context.h(148),
                          width: 1,
                          color: CustomColors.border,
                        ),
                    ],
                  ),
                  SizedBox(width: context.w(16)),
                  // Content
                  Expanded(
                    child: Column(
                      children: [
                        TreatmentCard(step: steps[index]),
                        if (!isLast) SizedBox(height: context.h(18)),
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
        color: const Color(0xffDEF8FF),
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: context.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.h(14)),
                  Text(step.title, style: context.fonts.black18w600),
                  SizedBox(height: context.h(11)),
                  Text(step.description, style: context.fonts.black16w400),
                  SizedBox(height: context.h(34)),
                  Text(step.date, style: context.fonts.black16w500),
                  SizedBox(height: context.h(14)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              height: context.h(144),
              width: context.w(144),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(12)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.r(12)),
                child: Image.asset(
                  step.imageAsset,
                  height: context.h(144),
                  width: context.w(144),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
