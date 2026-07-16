import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/requests/register_doctor_request.dart';
import '../../view_models/doctor_view_model.dart';
import '../../utils/theme.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';

class AddSlotDialog extends StatefulWidget {
  const AddSlotDialog({super.key});

  @override
  State<AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<AddSlotDialog> {
  List<String> selectedDays = [];
  Duration _selectedDuration = const Duration(minutes: 30);
  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) {
      return;
    }
    if (endTime != null) {
      if (picked.hour > endTime!.hour ||
          (picked.hour == endTime!.hour && picked.minute >= endTime!.minute)) {
        EasyLoading.showError('Start time should be before end time');
        return;
      }
    }
    setState(() {
      startTime = picked;
    });
  }

  Future<void> pickEndTime() async {
    if (startTime == null) {
      EasyLoading.showError('Select start time first!');
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) {
      return;
    }
    if (picked.hour < startTime!.hour ||
        (picked.hour == startTime!.hour &&
            picked.minute <= startTime!.minute)) {
      EasyLoading.showError('End time should be after start time');
      return;
    }

    setState(() {
      endTime = picked;
    });
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return Dialog(
      backgroundColor: CustomColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Container(
        width: screenWidth > 600 ? context.w(600) : screenWidth * 0.9,
        padding: EdgeInsets.all(context.r(20)),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            Text("Add Slot", style: context.fonts.black18w600),

            SizedBox(height: context.h(20)),

            /// Time Row
            Row(
              children: [
                /// Start Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start Time", style: context.fonts.black14w400),
                      SizedBox(height: context.h(5)),
                      GestureDetector(
                        onTap: pickStartTime,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(18),
                            vertical: context.h(10),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(context.r(10)),
                            border: Border.all(color: CustomColors.border),
                          ),
                          child: Text(
                            startTime == null
                                ? "Select Start Time"
                                : formatTime(startTime),
                            style: startTime == null
                                ? context.fonts.grey18w400
                                : context.fonts.black16w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: context.w(10)),

                /// End Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("End Time", style: context.fonts.black14w400),
                      SizedBox(height: context.h(5)),
                      GestureDetector(
                        onTap: pickEndTime,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.w(18),
                            vertical: context.h(10),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(context.r(10)),
                            border: Border.all(color: CustomColors.border),
                          ),
                          child: Text(
                            endTime == null
                                ? "Select End Time"
                                : formatTime(endTime),
                            style: endTime == null
                                ? context.fonts.grey18w400
                                : context.fonts.black16w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gap Between Appointment',
                  style: context.fonts.black14w500,
                ),
                SizedBox(height: context.h(8)),
                InkWell(
                  onTap: () async {
                    final Duration? picked = await showDurationPicker(
                      context: context,
                      initialTime: _selectedDuration,
                      lowerBound: const Duration(minutes: 5),
                      upperBound: const Duration(hours: 3),
                    );

                    if (picked == null) return;

                    // Extra validation (optional)
                    if (picked < const Duration(minutes: 5)) {
                      EasyLoading.showError(
                        'Duration must be at least 5 minutes!',
                      );
                      return;
                    }

                    if (picked > const Duration(hours: 3)) {
                      EasyLoading.showError('Duration cannot exceed 3 hours!');
                      return;
                    }

                    setState(() {
                      _selectedDuration = picked;
                    });
                  },

                  child: Container(
                    height: context.h(48),
                    padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(8)),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_selectedDuration),
                          style: context.fonts.black14w500,
                        ),
                        Icon(
                          Icons.timer_outlined,
                          size: context.r(20),
                          color: CustomColors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(20)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: List.generate(daysOfWeek.length, (index) {
                final day = daysOfWeek[index];
                final isSelected = selectedDays.contains(day);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedDays.remove(day);
                      } else {
                        selectedDays.add(day);
                      }
                    });
                  },
                  child: Chip(
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.r(50)),
                      side: BorderSide.none,
                    ),
                    backgroundColor: isSelected
                        ? CustomColors.lightPurple
                        : CustomColors.softGrey,
                    label: Text(
                      day,
                      style: TextStyle(
                        color: isSelected
                            ? CustomColors.purple
                            : CustomColors.black,
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: context.h(25)),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomOutlinedButton(
                  onTap: () => Navigator.pop(context),
                  label: "Cancel",
                  width: context.w(100),
                  height: context.h(42),
                ),
                SizedBox(width: context.w(10)),
                Consumer(
                  builder: (_, ref, _) {
                    return CustomPrimaryButton(
                      onTap: () {
                        if (startTime == null || endTime == null) {
                          EasyLoading.showError('Select start and end time!');
                          return;
                        }
                        final format = DateFormat('hh:mm a');
                        final startDate = format.parse(
                          startTime!.format(context),
                        );
                        final endDate = format.parse(endTime!.format(context));
                        final duration = endDate.difference(startDate);
                        if (duration.inHours < 1) {
                          EasyLoading.showError(
                            'Duration must be greater than 1 hour!',
                          );
                          return;
                        }
                        if (selectedDays.isEmpty) {
                          EasyLoading.showError('Select at least one day!');
                          return;
                        }
                        final state = ref.read(doctorProvider);
                        for (final a in state.availability) {
                          for (final day in a.days) {
                            if (selectedDays.contains(day)) {
                              EasyLoading.showError(
                                '$day is already selected!',
                              );
                              return;
                            }
                          }
                        }
                        final availability = Availability(
                          startTime: startTime!,
                          endTime: endTime!,
                          days: selectedDays,
                          nextSlotAfter: _formatDuration(_selectedDuration),
                        );
                        Navigator.pop(context, availability);
                      },
                      label: "Save",
                      width: context.w(100),
                      height: context.h(42),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
