import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skinsync_clinic_portal/screens/create_staff_screen.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/patient_selection_tile.dart';

import '../../../utils/assets.dart';

class ManageStaffScreen extends StatefulWidget {
  static const String routeName = '/manage-staff';

  const ManageStaffScreen({super.key});

  @override
  State<ManageStaffScreen> createState() => _ManageStaffScreenState();
}

class _ManageStaffScreenState extends State<ManageStaffScreen> {
  bool isSchedule = true;

  DateTime? scheduleStartDateTime;
  DateTime? scheduleEndDateTime;

  DateTime? timeOffStartDateTime;
  DateTime? timeOffEndDateTime;

  DateTime selectedDate = DateTime.now();

  String getSelectedDayName() {
    return DateFormat('EEEE').format(selectedDate);
  } // from calendar

  String formatDateTime(DateTime? dt) {
    if (dt == null) return "";
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  Future<void> pickTime({
    required bool isStart,
    required bool isScheduleTab,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final combined = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );

      setState(() {
        if (isScheduleTab) {
          if (isStart) {
            scheduleStartDateTime = combined;
          } else {
            scheduleEndDateTime = combined;
          }
        } else {
          if (isStart) {
            timeOffStartDateTime = combined;
          } else {
            timeOffEndDateTime = combined;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Manage Staff", style: context.fonts.black20w600),
                IconButton(
                  onPressed: () {
                    context.pushNamed(CreateStaffScreen.routeName);
                  },
                  icon: SvgPicture.asset(
                    SvgAssets.plus,
                    width: context.h(30),
                    height: context.h(30),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                patientSelection(),
                SizedBox(width: context.w(24)),
                Expanded(child: rightSideContent()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSideContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        patientInfo(context: context),
        SizedBox(height: context.h(20)),
        medicalInfo(context: context),
        SizedBox(height: context.h(20)),
        calendarAndTimeOffTap(),
        SizedBox(height: context.h(20)),
      ],
    );
  }

  Widget calendarAndTimeOffTap() {
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSchedule = true;
                        });
                      },
                      child: Text(
                        "Schedule",
                        style: isSchedule
                            ? context.fonts.black20w600
                            : context.fonts.grey18w400,
                      ),
                    ),
                    SizedBox(height: context.h(4)),
                    Divider(
                      height: context.h(2),
                      color: isSchedule ? CustomColors.black : CustomColors.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.w(20)),
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSchedule = false;
                        });
                      },
                      child: Text(
                        "Time Off",
                        style: !isSchedule
                            ? context.fonts.black20w600
                            : context.fonts.grey18w400,
                      ),
                    ),
                    SizedBox(height: context.h(4)),
                    Divider(
                      height: context.h(2),
                      color: !isSchedule ? CustomColors.black : CustomColors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          if (isSchedule) scheduleTap(),
          if (!isSchedule) timeOffTap(),
          CustomPrimaryButton(
            onTap: () {},
            label: "Save Schedule",
            width: double.infinity,
          ),
          SizedBox(height: context.h(20)),
        ],
      ),
    );
  }

  Widget timeOffTap() {
    return Column(
      children: [
        Row(
          children: [
            Text("18 Dec, 2020", style: context.fonts.black20w600),
            SizedBox(width: context.w(24)),
            const Expanded(child: Divider(color: CustomColors.border)),
            SizedBox(width: context.w(9)),
            Icon(
              Icons.delete_outline_rounded,
              size: context.sp(31),
              color: CustomColors.red,
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => pickTime(isStart: true, isScheduleTab: false),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(18),
                    vertical: context.h(14),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(10)),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    timeOffStartDateTime == null
                        ? "Select Start Time"
                        : formatDateTime(timeOffStartDateTime),
                    style: timeOffStartDateTime == null
                        ? context.fonts.grey18w400
                        : context.fonts.black14w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.w(10)),
            Expanded(
              child: GestureDetector(
                onTap: () => pickTime(isStart: false, isScheduleTab: false),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(18),
                    vertical: context.h(14),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(10)),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    timeOffEndDateTime == null
                        ? "Select End Time"
                        : formatDateTime(timeOffEndDateTime),
                    style: timeOffEndDateTime == null
                        ? context.fonts.grey18w400
                        : context.fonts.black14w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(20)),
      ],
    );
  }

  Widget scheduleTap() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.copyWith(
                    bodyLarge: context.fonts.black20w600,
                  ),
              colorScheme: const ColorScheme.light(
                primary: CustomColors.purple,
                onPrimary: CustomColors.white,
                onSurface: CustomColors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: CustomColors.black),
              ),
            ),
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.80,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  onDateChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                  currentDate: DateTime.now(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: context.w(20)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(getSelectedDayName(), style: context.fonts.black20w600),
              SizedBox(height: context.h(4)),
              const Divider(color: CustomColors.border),
              SizedBox(height: context.h(20)),
              // START TIME
              GestureDetector(
                onTap: () => pickTime(isStart: true, isScheduleTab: true),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(18),
                    vertical: context.h(14),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(10)),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    scheduleStartDateTime == null
                        ? "Select Start Time"
                        : formatDateTime(scheduleStartDateTime),
                    style: scheduleStartDateTime == null
                        ? context.fonts.grey18w400
                        : context.fonts.black14w500,
                  ),
                ),
              ),
              SizedBox(height: context.h(10)),
              GestureDetector(
                onTap: () => pickTime(isStart: false, isScheduleTab: true),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(18),
                    vertical: context.h(14),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(10)),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    scheduleEndDateTime == null
                        ? "Select End Time"
                        : formatDateTime(scheduleEndDateTime),
                    style: scheduleEndDateTime == null
                        ? context.fonts.grey18w400
                        : context.fonts.black14w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          Text("Services", style: context.fonts.black20w600),
          SizedBox(height: context.h(20)),
          Wrap(
            spacing: context.w(10),
            runSpacing: context.h(10),
            children: List.generate(7, (index) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(12),
                  vertical: context.h(10),
                ),
                decoration: BoxDecoration(
                  color: CustomColors.softGrey,
                  borderRadius: BorderRadius.circular(context.r(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      SvgAssets.stethoscope,
                      height: context.h(17),
                      width: context.w(17),
                      colorFilter: const ColorFilter.mode(
                        CustomColors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: context.w(6)),
                    Text("Laser Treatments", style: context.fonts.black14w500),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
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
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              PngAssets.person,
              height: context.r(80),
              width: context.r(80),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.w(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Charmaine Arnaud", style: context.fonts.black18w600),
                SizedBox(height: context.h(4)),
                Text("Doctor", style: context.fonts.grey14w400),
              ],
            ),
          ),
          Text(
            "Remove",
            style: context.fonts.black14w600.copyWith(
              color: CustomColors.purple,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget patientSelection() {
    return SizedBox(
      width: context.w(386),
      child: Column(
        children: [
          const CupertinoSearchTextField(backgroundColor: CustomColors.softGrey),
          SizedBox(height: context.h(20)),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: context.h(12)),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return const PatientSelectionTile(title: "Sarah Johnson");
            },
          ),
        ],
      ),
    );
  }
}
