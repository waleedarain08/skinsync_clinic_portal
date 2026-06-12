import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/utils/string_utils.dart';
import 'package:skinsync_clinic_portal/widgets/empty_widget.dart';
import 'package:skinsync_clinic_portal/widgets/patient_selection_tile.dart';

import '../../../utils/assets.dart';
import '../../models/requests/register_doctor_request.dart';
import '../../models/responses/register_doctor_response.dart';
import '../../view_models/doctor_view_model.dart';
import '../add_doctor_injector_screen.dart';

class MangeDoctorsInjectorsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/manage-doctors-injectors';

  const MangeDoctorsInjectorsScreen({super.key});

  @override
  ConsumerState<MangeDoctorsInjectorsScreen> createState() =>
      _MangeDoctorsInjectorsScreenState();
}

class _MangeDoctorsInjectorsScreenState
    extends ConsumerState<MangeDoctorsInjectorsScreen> {
  bool isSchedule = true;

  DateTime? scheduleStartDateTime;
  DateTime? scheduleEndDateTime;

  DateTime? timeOffStartDateTime;
  DateTime? timeOffEndDateTime;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(doctorProvider.notifier).getDoctors(),
    );
  }

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Doctors / Injectors",
                  style: CustomFonts.black20w600,
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.push(AddDoctorInjectorScreen.routeName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.add, color: Colors.white, size: 20.r),
                  label: Text(
                    'Add Doctor / Injector',
                    style: CustomFonts.white14w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 50.h),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(doctorProvider);
                  if (state.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.doctors.isEmpty) {
                    return Center(
                      child: EmptyWidget(height: 300.h, width: 300.h),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorSelection(state),
                      SizedBox(width: 28.9.w),
                      Expanded(child: rightSideContent(state.selectedDoctor)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSideContent(Doctor? selectedDoctor) {
    if (selectedDoctor == null) {
      return SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          patientInfo(context: context, selectedDoctor: selectedDoctor),
          SizedBox(height: 19.h),
          medicalInfo(context: context, selectedDoctor: selectedDoctor),
          SizedBox(height: 19.h),
          //    calendarAndTimeOffTap(),
          SizedBox(height: 20.h),
        ],
      ),
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

  Widget medicalInfo({
    required BuildContext context,
    required Doctor selectedDoctor,
  }) {
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
            children: List.generate(selectedDoctor.treatments?.length ?? 0, (
              index,
            ) {
              final Treatment? treatment = selectedDoctor.treatments?[index];
              return Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      treatment?.treatmentName ?? "",
                      style: CustomFonts.black18w600,
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: List.generate(
                        treatment?.sideAreas?.length ?? 0,
                        (index) {
                          final SideArea? sideArea =
                              treatment?.sideAreas?[index];

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.softGrey,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.stethoscope,
                                  height: 17.h,
                                  width: 17.w,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  sideArea?.sideAreaName ?? "",
                                  style: CustomFonts.black14w500,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
              //  Container(
              //   padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 14.h),
              //   decoration: BoxDecoration(
              //     color: CustomColors.iconColor,
              //     borderRadius: BorderRadius.circular(10.r),
              //   ),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       SvgPicture.asset(
              //         SvgAssets.stethoscope,
              //         height: 17.h,
              //         width: 17.w,
              //         color: Colors.black,
              //       ),
              //       SizedBox(width: 6.w),
              //       Text("Laser Treatments", style: CustomFonts.black14w500),
              //     ],
              //   ),
              // );
            }),
          ),
          if (selectedDoctor.availability?.isNotEmpty ?? false) ...{
            SizedBox(height: 20.h),
            Text("Availability", style: CustomFonts.black20w600),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  for (Availability availability
                      in selectedDoctor.availability ?? [])
                    for (final day in availability.days)
                      Row(
                        spacing: 20.w,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 9.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.softGrey,
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Text(day, style: CustomFonts.black14w500),
                          ),
                          Text(
                            '${availability.startTime.format(context)} to ${availability.endTime.format(context)}',
                            style: CustomFonts.black14w600,
                          ),
                        ],
                      ),
                ],
              ),
            ),
          },
        ],
      ),
    );
  }

  Widget patientInfo({
    required BuildContext context,
    required Doctor selectedDoctor,
  }) {
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
              if (selectedDoctor.image != null)
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: selectedDoctor.image!,
                    height: 96.w,
                    width: 96.w,
                    errorWidget: (_, _, _) {
                      return CircleAvatar(
                        radius: 96.w / 2,
                        child: Icon(Icons.person, size: 30.sp),
                      );
                    },
                  ),
                )
              else
                CircleAvatar(
                  radius: 96.w / 2,
                  child: Icon(Icons.person, size: 30.sp),
                ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedDoctor.name ?? 'N/A',
                    style: CustomFonts.black18w600,
                  ),
                  Text(
                    selectedDoctor.role?.name.capitalize ?? 'N/A',
                    style: CustomFonts.grey16w400,
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  context.push(
                    AddDoctorInjectorScreen.routeName,
                    extra: selectedDoctor,
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: CustomColors.purple,
                      size: 20.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text("Edit", style: CustomFonts.black14w600.copyWith(color: CustomColors.purple, decoration: TextDecoration.underline)),
                  ],
                ),
              ),

              //    Text("Edit", style: CustomFonts.pinkunderlined20w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSelection(DoctorState state) {
    return SizedBox(
      width: 386.w,
      child: Column(
        children: [
          CupertinoSearchTextField(backgroundColor: Color(0xFFF3F3F5)),
          SizedBox(height: 14.h),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemCount: state.doctors.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(15.r),
                  onTap: () => ref
                      .read(doctorProvider.notifier)
                      .setSelectedDoctor(state.doctors[index]),
                  child: PatientSelectionTile(
                    title: state.doctors[index].name ?? 'N/A',
                    subTitle: state.doctors[index].email ?? 'N/A',
                    imageUrl: state.doctors[index].image,
                    isSelected: state.selectedDoctor == state.doctors[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
