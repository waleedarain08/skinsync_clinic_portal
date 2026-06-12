import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';
import 'package:skinsync_clinic_portal/view_models/auth_view_model.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/add_notes_dailog.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/create_invoice_dailog.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/patient_detail_dailog.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/status_update_dailog.dart';
import 'package:skinsync_clinic_portal/widgets/pdf_expansiontile_.dart';

import '../../utils/theme.dart';

class AppointmentReadyDailog extends ConsumerStatefulWidget {
  const AppointmentReadyDailog({super.key});

  @override
  ConsumerState<AppointmentReadyDailog> createState() =>
      _AppointmentReadyDailogState();
}

class _AppointmentReadyDailogState
    extends ConsumerState<AppointmentReadyDailog> {
  @override
  Widget build(BuildContext context) {
    final navigateDailogIndex = ref.watch(authViewModelProvider).navigateDailogIndex;

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
              GestureDetector(
                onTap: () {
                  ref
                      .read(authViewModelProvider.notifier)
                      .navigateDailogIndexToNext(0);
                  showDialog(
                    context: context,
                    builder: (_) => const PatientDetailDailog(),
                  );
                },
                child: Container(
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
              ),
              SizedBox(height: context.h(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Details", style: CustomFonts.black20w600),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const CreateInvoiceDialog(invoiceNumber: '#SSA5002'),
                      );
                    },
                    child: Text(
                      "Add New Invoice",
                      style: CustomFonts.purple14w600.copyWith(
                        color: CustomColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
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
              SizedBox(height: context.h(20)),
              Text("Additional Invoice", style: CustomFonts.black20w600),
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
                        Icon(
                          Icons.receipt_outlined,
                          size: context.r(20),
                          color: CustomColors.black,
                        ),
                        SizedBox(width: context.w(12)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Invoice", style: CustomFonts.black14w600),
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

              SizedBox(height: context.h(20)),
              const PDFExpansionTile(),
              SizedBox(height: context.h(20)),
              navigateDailogIndex == 0
                  ? const SizedBox()
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(15),
                        vertical: context.h(15),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.r(15)),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upload Images", style: CustomFonts.black20w600),
                          SizedBox(height: context.h(20)),
                          Row(
                            children: List.generate(3, (_) {
                              return Padding(
                                padding: EdgeInsets.only(right: context.w(10)),
                                child: Container(
                                  height: context.h(100),
                                  width: context.w(104),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(context.r(16)),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        PngAssets.treatmentImage2,
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: context.h(20)),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(17),
                              vertical: context.h(13),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(context.r(15)),
                              color: CustomColors.black,
                            ),
                            child: Text(
                              "Upload Images",
                              style: CustomFonts.white14w600,
                            ),
                          ),
                        ],
                      ),
                    ),
              navigateDailogIndex == 0
                  ? const SizedBox()
                  : SizedBox(height: context.h(20)),
              navigateDailogIndex == 0
                  ? const SizedBox()
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(15),
                        vertical: context.h(15),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(context.r(15)),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Treatment Notes",
                            style: CustomFonts.black20w600,
                          ),
                          SizedBox(height: context.h(20)),
                          Row(
                            children: [
                              Text(
                                "Note Type: ",
                                style: CustomFonts.black14w600,
                              ),
                              Expanded(
                                child: Text(
                                  "Prefers natural-looking results",
                                  style: CustomFonts.grey14w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.h(20)),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => const AddNotesDailog(),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(17),
                                vertical: context.h(13),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(context.r(15)),
                                border: Border.all(color: CustomColors.border),
                                color: CustomColors.white,
                              ),
                              child: Text(
                                "Add Treatment Note",
                                style: CustomFonts.black14w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              navigateDailogIndex == 0
                  ? const SizedBox()
                  : SizedBox(height: context.h(30)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (navigateDailogIndex == 1) {
                          context.pop();
                          showDialog(
                            context: context,
                            builder: (context) => const StatusUpdateDailog(),
                          );
                        } else {
                          ref
                              .read(authViewModelProvider.notifier)
                              .navigateDailogIndexToNext(1);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(17),
                          vertical: context.h(13),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.r(15)),
                          color: CustomColors.black,
                        ),
                        child: Text(
                          navigateDailogIndex == 0
                              ? "Start Appointment"
                              : "End Appointment",
                          style: CustomFonts.white14w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(15)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(17),
                          vertical: context.h(13),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.r(15)),
                          border: Border.all(color: CustomColors.border),
                          color: CustomColors.white,
                        ),
                        child: Text("Cancel", style: CustomFonts.black14w600),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(30)),
            ],
          ),
        ),
      ),
    );
  }
}
