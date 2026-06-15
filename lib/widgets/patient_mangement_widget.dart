import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../screens/dashboard/appointment_screen.dart';
import '../screens/dashboard/patient_management_detail.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import '../view_models/auth_view_model.dart';
import 'appointment_tile_widget.dart';
import 'dialog_box/appointment_ready_dailog.dart';
import 'dialog_box/chat_dailog.dart';
import 'dialog_box/notes_dailog.dart';
import 'dialog_box/simulations_detail_dailog_box.dart';
import 'pateint_treatment_selection_tile.dart';
import 'signpad_widget.dart';

class PatientMangementWidget extends StatefulWidget {
  const PatientMangementWidget({super.key});

  @override
  State<PatientMangementWidget> createState() => _PatientMangementWidgetState();
}

class _PatientMangementWidgetState extends State<PatientMangementWidget> {
  bool isTreatmentSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        patientInfo(context: context),
        SizedBox(height: context.h(20)),
        selectionButtons(),
        SizedBox(height: context.h(20)),
        if (isTreatmentSelected) treatmentContent(),
        if (!isTreatmentSelected) simulationContent(),
        SizedBox(height: context.h(20)),
        allergies(),
        SizedBox(height: context.h(20)),
        photosSection(),
        SizedBox(height: context.h(20)),
        appointmentContent(),
        SizedBox(height: context.h(20)),
        medicalInfo(context: context),
        SizedBox(height: context.h(20)),
      ],
    );
  }

  Widget photosSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Photos", style: CustomFonts.black20w600),
          SizedBox(height: context.h(20)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: context.w(10)),
                  child: Container(
                    height: context.h(100),
                    width: context.w(104),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(16)),
                      image: const DecorationImage(
                        image: AssetImage(PngAssets.treatmentImage2),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget selectionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isTreatmentSelected = true;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: context.h(16)),
              decoration: BoxDecoration(
                color: isTreatmentSelected
                    ? CustomColors.black
                    : CustomColors.softGrey,
                borderRadius: BorderRadius.circular(context.r(10)),
              ),
              child: Center(
                child: Text(
                  "Treatments",
                  style: isTreatmentSelected
                      ? CustomFonts.white14w600
                      : CustomFonts.black14w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: context.w(12)),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isTreatmentSelected = false;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: context.h(16)),
              decoration: BoxDecoration(
                color: !isTreatmentSelected
                    ? CustomColors.black
                    : CustomColors.softGrey,
                borderRadius: BorderRadius.circular(context.r(10)),
              ),
              child: Center(
                child: Text(
                  "AI Simulations",
                  style: !isTreatmentSelected
                      ? CustomFonts.white14w600
                      : CustomFonts.black14w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget allergies() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Allergies", style: CustomFonts.black20w600),
          SizedBox(height: context.h(20)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(12),
              vertical: context.h(6),
            ),
            decoration: BoxDecoration(
              color: CustomColors.black,
              borderRadius: BorderRadius.circular(context.r(10)),
            ),
            child: Text("New", style: CustomFonts.white14w600),
          ),
        ],
      ),
    );
  }

  Widget simulationContent() {
    return Container(
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: context.w(15),
          mainAxisSpacing: context.h(15),
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const SimulationDetailDaillogBox(),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.r(10)),
                    child: Image.asset(
                      PngAssets.simulation,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: context.h(8)),
                Text(
                  "Simulation ${index + 1}",
                  style: CustomFonts.black16w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text("Treatment Name", style: CustomFonts.grey14w400),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget treatmentContent() {
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
          Text("Treatment History", style: CustomFonts.black20w600),
          SizedBox(height: context.h(20)),
          const CupertinoSearchTextField(
            backgroundColor: CustomColors.softGrey,
          ),
          SizedBox(height: context.h(20)),
          ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(height: context.h(15)),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return PatientTreatmentSelectionTile(
                onTap: () {
                  context.go(PatientManagementDetailScreen.routeName);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget appointmentContent() {
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
          Text("Appointments", style: CustomFonts.black20w600),
          SizedBox(height: context.h(20)),
          ListView.separated(
            separatorBuilder: (context, index) =>
                SizedBox(height: context.h(15)),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Consumer(
                builder: (context, ref, _) {
                  return AppointmentTileWidget(
                    appointment: dummyAppointments[index],
                    onTap: () {
                      ref
                          .read(authViewModelProvider.notifier)
                          .navigateDailogIndexToNext(0);
                      showDialog(
                        context: context,
                        builder: (_) => const AppointmentReadyDailog(),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget medicalInfo({required BuildContext context}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Medical Information", style: CustomFonts.black20w600),
          SizedBox(height: context.h(20)),
          Text("Allergies", style: CustomFonts.grey14w600),
          SizedBox(height: context.h(10)),
          Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: CustomColors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.r(10)),
            ),
            child: Text("Latex", style: CustomFonts.red14w600),
          ),
          SizedBox(height: context.h(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notes", style: CustomFonts.grey14w600),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const NotesDailog(),
                  );
                },
                child: Text("+ Add New Note", style: CustomFonts.purple16w600),
              ),
            ],
          ),
          SizedBox(height: context.h(15)),
          ...List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: context.h(10)),
              child: Text(
                "Prefers natural-looking results",
                style: CustomFonts.grey14w400,
              ),
            ),
          ),
          SizedBox(height: context.h(10)),
          for (int i = 0; i < 2; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.h(8)),
              child: intakeFormTile(context),
            ),
        ],
      ),
    );
  }

  Widget intakeFormTile(BuildContext context) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: CustomColors.border),
        borderRadius: BorderRadius.circular(context.r(16)),
      ),
      collapsedShape: RoundedRectangleBorder(
        side: const BorderSide(color: CustomColors.border),
        borderRadius: BorderRadius.circular(context.r(16)),
      ),
      clipBehavior: Clip.antiAlias,
      leading: Image.asset(
        PngAssets.pdf,
        height: context.h(33),
        width: context.w(44),
      ),
      title: Text("Client Intake Form.pdf", style: CustomFonts.black14w600),
      subtitle: Text(
        "867 Kb    14 Feb 2022 at 11:30 am",
        style: CustomFonts.grey12w400,
      ),
      trailing: SvgPicture.asset(
        SvgAssets.downloadIcon,
        height: context.w(20),
        width: context.w(20),
      ),
      childrenPadding: EdgeInsets.symmetric(
        horizontal: context.w(15),
        vertical: context.h(15),
      ),
      children: [
        const Divider(color: CustomColors.border),
        SizedBox(height: context.h(10)),
        ...List.generate(
          3,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: context.h(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Text Field ${index + 1}", style: CustomFonts.grey14w400),
                Text("Client Input", style: CustomFonts.black14w400),
              ],
            ),
          ),
        ),
        SizedBox(height: context.h(15)),
        signatureSection(context),
      ],
    );
  }

  Widget signatureSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: context.h(40),
              width: context.w(100),
              child: Image.asset(PngAssets.signature, fit: BoxFit.contain),
            ),
            Container(
              width: context.w(105),
              height: 1,
              color: CustomColors.black,
            ),
            Text("Patient Signature", style: CustomFonts.black12w400),
          ],
        ),
        Consumer(
          builder: (context, ref, _) {
            final signature = ref.watch(authViewModelProvider).signature;
            if (signature != null) {
              return RawImage(
                image: signature,
                height: context.h(50),
                fit: BoxFit.contain,
              );
            }
            return GestureDetector(
              onTap: () async {
                final ui.Image? sig = await ESignatureDialog.show(context);
                if (sig != null) {
                  ref.read(authViewModelProvider.notifier).saveSignature(sig);
                }
              },
              child: Container(
                padding: EdgeInsets.all(context.w(8)),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.purple),
                  borderRadius: BorderRadius.circular(context.r(8)),
                  color: CustomColors.softGrey,
                ),
                child: Text(
                  "+ Draw Signature",
                  style: CustomFonts.purple14w600,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget patientInfo({required BuildContext context}) {
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
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  PngAssets.person,
                  height: context.r(80),
                  width: context.r(80),
                ),
              ),
              SizedBox(width: context.w(15)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sarah Johnson", style: CustomFonts.black18w600),
                    Text("Patient ID: 1", style: CustomFonts.grey14w400),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ChatDailog(),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(context.r(12)),
                  decoration: const BoxDecoration(
                    color: CustomColors.softGrey,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    SvgAssets.message,
                    height: context.w(20),
                    width: context.w(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          Row(
            children: [
              Expanded(
                child: infoContainer(
                  title: "Email",
                  info: "sarah.j@email.com",
                  icon: Icons.email_outlined,
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: infoContainer(
                  title: "Phone",
                  info: "+1 555 123 4567",
                  icon: Icons.call_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(12)),
          Row(
            children: [
              Expanded(
                child: infoContainer(
                  title: "Last Visit",
                  info: "Oct 29, 2025",
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              SizedBox(width: context.w(12)),
              Expanded(
                child: infoContainer(
                  title: "Next Appt",
                  info: "Nov 5, 2025",
                  icon: Icons.calendar_month_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoContainer({
    required String title,
    required String info,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(context.r(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: CustomFonts.grey12w400,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.h(6)),
          Row(
            children: [
              Icon(icon, size: context.sp(14), color: CustomColors.lightGrey),
              SizedBox(width: context.w(6)),
              Expanded(
                child: Text(
                  info,
                  style: CustomFonts.black14w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
