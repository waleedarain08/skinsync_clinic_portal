import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../models/requests/register_practitioner_request.dart';
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
  Duration _nextSlotAfter = const Duration(minutes: 30);
  int _slotDuration = 30;
  int _bufferTime = 10;

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
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    setState(() => startTime = picked);
  }

  Future<void> pickEndTime() async {
    if (startTime == null) {
      EasyLoading.showError('Select start time first!');
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );
    if (picked == null) return;
    setState(() => endTime = picked);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "";
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    return Dialog(
      backgroundColor: CustomColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(12))),
      child: SingleChildScrollView(
        child: Container(
          width: screenWidth > 600 ? context.w(600) : screenWidth * 0.9,
          padding: EdgeInsets.all(context.r(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Add Slot", style: context.fonts.black18w600),
              SizedBox(height: context.h(20)),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(label: "Start Time", time: startTime, onTap: pickStartTime),
                  ),
                  SizedBox(width: context.w(10)),
                  Expanded(
                    child: _buildTimePicker(label: "End Time", time: endTime, onTap: pickEndTime),
                  ),
                ],
              ),
              SizedBox(height: context.h(20)),
              _buildDurationPicker(
                label: 'Next Slot After (Minutes)',
                value: _nextSlotAfter.inMinutes,
                onTap: () async {
                  final picked = await showDurationPicker(
                    context: context,
                    initialTime: _nextSlotAfter,
                  );
                  if (picked != null) {
                    setState(() => _nextSlotAfter = picked);
                  }
                },
              ),
              SizedBox(height: context.h(20)),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInput(
                      label: 'Slot Duration (Min)',
                      value: _slotDuration.toString(),
                      onChanged: (val) => _slotDuration = int.tryParse(val) ?? 30,
                    ),
                  ),
                  SizedBox(width: context.w(10)),
                  Expanded(
                    child: _buildNumberInput(
                      label: 'Buffer Time (Min)',
                      value: _bufferTime.toString(),
                      onChanged: (val) => _bufferTime = int.tryParse(val) ?? 10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(20)),
              Text('Select Days', style: context.fonts.black14w500),
              SizedBox(height: context.h(8)),
              Wrap(
                spacing: context.w(8),
                runSpacing: context.h(8),
                children: daysOfWeek.map((day) {
                  final isSelected = selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: context.h(25)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomOutlinedButton(onTap: () => Navigator.pop(context), label: "Cancel", width: context.w(100), height: context.h(42)),
                  SizedBox(width: context.w(10)),
                  CustomPrimaryButton(
                    onTap: () {
                      if (startTime == null || endTime == null) {
                        EasyLoading.showError('Select start and end time!');
                        return;
                      }
                      if (selectedDays.isEmpty) {
                        EasyLoading.showError('Select at least one day!');
                        return;
                      }
                      final now = DateTime.now();
                      final startDateTime = DateTime(now.year, now.month, now.day, startTime!.hour, startTime!.minute);
                      final endDateTime = DateTime(now.year, now.month, now.day, endTime!.hour, endTime!.minute);

                      final availability = Availability(
                        startTime: startDateTime.millisecondsSinceEpoch,
                        endTime: endDateTime.millisecondsSinceEpoch,
                        days: selectedDays,
                        nextSlotAfter: _nextSlotAfter.inMinutes,
                        slotDurationMinutes: _slotDuration,
                        bufferTimeMinutes: _bufferTime,
                      );
                      Navigator.pop(context, availability);
                    },
                    label: "Save", width: context.w(100), height: context.h(42),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({required String label, required TimeOfDay? time, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w400),
        SizedBox(height: context.h(5)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: context.w(18), vertical: context.h(10)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(context.r(10)), border: Border.all(color: CustomColors.border)),
            child: Text(time == null ? "Select" : time.format(context), style: time == null ? context.fonts.grey18w400 : context.fonts.black16w500),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationPicker({required String label, required int value, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w500),
        SizedBox(height: context.h(8)),
        InkWell(
          onTap: onTap,
          child: Container(
            height: context.h(48), padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(context.r(8)), border: Border.all(color: CustomColors.border)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(value.toString(), style: context.fonts.black14w500), Icon(Icons.timer_outlined, size: context.r(20), color: CustomColors.grey)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInput({required String label, required String value, required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w400),
        SizedBox(height: context.h(5)),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(context.r(10))),
            contentPadding: EdgeInsets.symmetric(horizontal: context.w(18), vertical: context.h(10)),
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          controller: TextEditingController(text: value)..selection = TextSelection.collapsed(offset: value.length),
        ),
      ],
    );
  }
}
