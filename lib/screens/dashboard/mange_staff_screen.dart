import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skinsync_clinic_portal/screens/create_staff_screen.dart';
import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Manage Staff", style: CustomFonts.black20w600),
                IconButton(
                  onPressed: () {
                    context.pushNamed(CreateStaffScreen.routeName);
                  },
                  icon: SvgPicture.asset(
                    SvgAssets.plus,
                    width: 30.h,
                    height: 30.h,
                  ),
                ),
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
        SizedBox(height: 19.h),
        medicalInfo(context: context),
        SizedBox(height: 19.h),
        calendarAndTimeOffTap(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget calendarAndTimeOffTap() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade300),
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
                            ? CustomFonts.black20w600
                            : CustomFonts.grey18w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Divider(
                      height: 2.h,
                      color: isSchedule ? Colors.black : Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
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
                            ? CustomFonts.black20w600
                            : CustomFonts.grey18w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Divider(
                      height: 2.h,
                      color: !isSchedule ? Colors.black : Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (isSchedule) scheduleTap(),
          if (!isSchedule) timeOffTap(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Save Schedule"),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget timeOffTap() {
    return Column(
      children: [
        Row(
          children: [
            Text("18 Dec, 2020", style: CustomFonts.black20w600),
            SizedBox(width: 24.w),
            Expanded(child: Divider(color: Colors.grey.shade300)),
            SizedBox(width: 9.w),
            Icon(
              Icons.delete_outline_rounded,
              size: 31.sp,
              color: CustomColors.border,
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => pickTime(isStart: true, isScheduleTab: false),
              child: Container(
                width: 182.w,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  timeOffStartDateTime == null
                      ? "Select Start Time"
                      : formatDateTime(timeOffStartDateTime),
                  style: timeOffStartDateTime == null
                      ? CustomFonts.grey18w400
                      : CustomFonts.black14w500,
                ),
              ),
            ),

            SizedBox(width: 10.w),

            GestureDetector(
              onTap: () => pickTime(isStart: false, isScheduleTab: false),
              child: Container(
                width: 182.w,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  timeOffEndDateTime == null
                      ? "Select End Time"
                      : formatDateTime(timeOffEndDateTime),
                  style: timeOffEndDateTime == null
                      ? CustomFonts.grey18w400
                      : CustomFonts.black14w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
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
              textTheme: Theme.of(
                context,
              ).textTheme.copyWith(bodyLarge: CustomFonts.black20w600),
              colorScheme: ColorScheme.light(
                primary: CustomColors.purple,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
              ),
            ),
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.80, // 🔥 trims bottom internal padding
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

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(getSelectedDayName(), style: CustomFonts.black20w600),
              SizedBox(height: 4.h),
              Divider(color: Colors.grey.shade300),
              SizedBox(height: 20.h),
              // START TIME
              GestureDetector(
                onTap: () => pickTime(isStart: true, isScheduleTab: true),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    scheduleStartDateTime == null
                        ? "Select Start Time"
                        : formatDateTime(scheduleStartDateTime),
                    style: scheduleStartDateTime == null
                        ? CustomFonts.grey18w400
                        : CustomFonts.black14w500,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              GestureDetector(
                onTap: () => pickTime(isStart: false, isScheduleTab: true),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    scheduleEndDateTime == null
                        ? "Select End Time"
                        : formatDateTime(scheduleEndDateTime),
                    style: scheduleEndDateTime == null
                        ? CustomFonts.grey18w400
                        : CustomFonts.black14w500,
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
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Services", style: CustomFonts.black20w600),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(7, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: CustomColors.softGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 👈 important
                  children: [
                    SvgPicture.asset(
                      SvgAssets.stethoscope,
                      height: 17.h,
                      width: 17.w,
                      color: Colors.black,
                    ),
                    SizedBox(width: 6.w),
                    Text("Laser Treatments", style: CustomFonts.black14w500),
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
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(PngAssets.person, height: 96.w, width: 96.w),
              ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Charmaine Arnaud", style: CustomFonts.black18w600),
                  Text("Doctor", style: CustomFonts.grey16w400),
                ],
              ),
              Spacer(),
              Text("Remove", style: CustomFonts.black14w600.copyWith(color: CustomColors.purple, decoration: TextDecoration.underline)),
            ],
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
            separatorBuilder: (context, index) => SizedBox(height: 15.h),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return PatientSelectionTile(title: "Sarah Johnson");
            },
          ),
        ],
      ),
    );
  }
}
