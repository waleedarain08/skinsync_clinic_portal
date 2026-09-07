import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/responses/appointment_list_response.dart';
import '../utils/theme.dart';
import '../view_models/appointment_view_model.dart';
import 'borderd_container_widget.dart';
import 'custom_primary_button.dart';
import 'dialog_box/standard_dialog.dart';

class LeaveRecord {
  final String dateRange;
  final String reason;
  final String status;

  LeaveRecord({
    required this.dateRange,
    required this.reason,
    required this.status,
  });
}

class ProviderLeaveCalendarWidget extends ConsumerStatefulWidget {
  final int? practitionerId;

  const ProviderLeaveCalendarWidget({super.key, this.practitionerId});

  @override
  ConsumerState<ProviderLeaveCalendarWidget> createState() =>
      _ProviderLeaveCalendarWidgetState();
}

class _ProviderLeaveCalendarWidgetState
    extends ConsumerState<ProviderLeaveCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  final List<LeaveRecord> _leaves = [
    LeaveRecord(
      dateRange: 'Oct 15 - Oct 18, 2025',
      reason: 'Annual Leave',
      status: 'Approved',
    ),
    LeaveRecord(
      dateRange: 'Nov 02, 2025',
      reason: 'Sick Leave',
      status: 'Approved',
    ),
  ];

  List<AppointmentData> get _dummyAppointments {
    final now = DateTime.now();
    return [
      AppointmentData(
        id: 101,
        appointmentKey: 'APT-1001',
        appointmentType: 'Botox Treatment',
        patientName: 'Sarah Wilson',
        status: 'Confirmed',
        start: DateTime(now.year, now.month, now.day + 2, 10, 0),
        end: DateTime(now.year, now.month, now.day + 2, 11, 0),
        date: DateTime(now.year, now.month, now.day + 2),
      ),
      AppointmentData(
        id: 102,
        appointmentKey: 'APT-1002',
        appointmentType: 'Dermal Filler',
        patientName: 'Michael Smith',
        status: 'Confirmed',
        start: DateTime(now.year, now.month, now.day + 5, 14, 0),
        end: DateTime(now.year, now.month, now.day + 5, 15, 0),
        date: DateTime(now.year, now.month, now.day + 5),
      ),
    ];
  }

  void _markLeaveForSelectedRange() {
    if (_rangeStart == null && _selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date(s) on the calendar first'),
        ),
      );
      return;
    }

    final formatter = DateFormat('MMM dd, yyyy');
    String rangeStr;

    if (_rangeStart != null) {
      final start = _rangeStart!;
      final end = _rangeEnd ?? _rangeStart!;
      rangeStr = start.isAtSameMomentAs(end)
          ? formatter.format(start)
          : '${formatter.format(start)} - ${formatter.format(end)}';
    } else {
      rangeStr = formatter.format(_selectedDay!);
    }

    setState(() {
      _leaves.insert(
        0,
        LeaveRecord(
          dateRange: rangeStr,
          reason: 'Annual Leave',
          status: 'Approved',
        ),
      );
      _rangeStart = null;
      _rangeEnd = null;
      _selectedDay = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Leave successfully marked for $rangeStr')),
    );
  }

  void _showRescheduleDialog(AppointmentData appt) {
    DateTime newDate = appt.start ?? DateTime.now();
    showDialog(
      context: context,
      builder: (context) {
        return StandardDialog(
          title: 'Reschedule Appointment (${appt.appointmentKey})',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Patient: ${appt.patientName}', style: context.fonts.black14w600),
              context.verticalSpace(8),
              Text(
                'Service: ${appt.appointmentType ?? "Consultation"}',
                style: context.fonts.grey13w500,
              ),
              context.verticalSpace(16),
              Text('Select New Date', style: context.fonts.black14w600),
              context.verticalSpace(8),
              SizedBox(
                width: 420,
                height: 280,
                child: CalendarDatePicker(
                  initialDate: newDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (d) => newDate = d,
                ),
              ),
            ],
          ),
          actions: [
            CustomPrimaryButton(
              label: 'Confirm Reschedule',
              onTap: () {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Appointment ${appt.appointmentKey} rescheduled to ${DateFormat('MMM dd, yyyy').format(newDate)}',
                    ),
                  ),
                );
              },
              width: 170,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final apiAppointments = appointmentState.appointmentList ?? [];
    final allAppointments = [...apiAppointments, ..._dummyAppointments];

    List<AppointmentData> getAppointmentsForDay(DateTime day) {
      return allAppointments.where((a) {
        final date = a.date ?? a.start;
        return isSameDay(date, day);
      }).toList();
    }

    final activeTargetDay = _selectedDay ?? _rangeStart ?? DateTime.now();
    final selectedDayAppointments = getAppointmentsForDay(activeTargetDay);

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Calendar & Leaves', style: context.fonts.subHeading),
                  context.verticalSpace(2),
                  Text(
                    'Tap/drag dates on calendar to select leave range',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
              CustomPrimaryButton(
                onTap: _markLeaveForSelectedRange,
                label: 'Mark Leave',
                icon: Icons.event_busy_outlined,
                height: context.h(36),
                width: context.w(165),
              ),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),

          // Inline TableCalendar with range selection & appointment markers
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: CustomColors.border),
              borderRadius: BorderRadius.circular(context.r(12)),
            ),
            child: TableCalendar<AppointmentData>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              eventLoader: getAppointmentsForDay,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: CustomColors.purple,
                  shape: BoxShape.circle,
                ),
                rangeStartDecoration: const BoxDecoration(
                  color: CustomColors.purple,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: const BoxDecoration(
                  color: CustomColors.purple,
                  shape: BoxShape.circle,
                ),
                rangeHighlightColor: CustomColors.lightPurple,
                markerDecoration: const BoxDecoration(
                  color: CustomColors.green,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = selectedDay;
                  _rangeEnd = null;
                });
              },
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _rangeStart = start;
                  _rangeEnd = end;
                  _focusedDay = focusedDay;
                  _selectedDay = null;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),

          context.verticalSpace(20),

          // Selected Day Appointments & Reschedule
          if (selectedDayAppointments.isNotEmpty) ...[
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.lightPurple.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(
                  color: CustomColors.purple.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.event_note,
                        color: CustomColors.purple,
                        size: 20,
                      ),
                      context.horizontalSpace(8),
                      Text(
                        'Appointments on ${DateFormat('MMM dd, yyyy').format(activeTargetDay)}',
                        style: context.fonts.black14w600.copyWith(
                          color: CustomColors.purple,
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(12),
                  ...selectedDayAppointments.map(
                    (appt) => Container(
                      margin: EdgeInsets.only(bottom: context.h(8)),
                      padding: context.appEdgeInsets(all: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(context.r(8)),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.patientName ?? 'Patient',
                                  style: context.fonts.black14w600,
                                ),
                                context.verticalSpace(2),
                                Text(
                                  'Service: ${appt.appointmentType ?? "Consultation"} (${appt.appointmentKey ?? appt.id})',
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.purple,
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(12),
                                vertical: context.h(8),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(context.r(8)),
                              ),
                            ),
                            onPressed: () => _showRescheduleDialog(appt),
                            child: const Text(
                              'Reschedule',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            context.verticalSpace(20),
          ],

          Text('Recorded Leaves', style: context.fonts.black14w600),
          context.verticalSpace(12),
          if (_leaves.isEmpty)
            Text('No leaves recorded.', style: context.fonts.grey14w400)
          else
            ..._leaves.map(
              (leave) => Padding(
                padding: EdgeInsets.only(bottom: context.h(12)),
                child: Row(
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 10),
                      decoration: BoxDecoration(
                        color: CustomColors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.r(8)),
                      ),
                      child: const Icon(
                        Icons.event_busy,
                        color: CustomColors.amber,
                        size: 20,
                      ),
                    ),
                    context.horizontalSpace(14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(leave.reason, style: context.fonts.black14w600),
                          context.verticalSpace(2),
                          Text(
                            leave.dateRange,
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(10),
                        vertical: context.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.r(12)),
                      ),
                      child: Text(
                        leave.status,
                        style: context.fonts.green10w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
