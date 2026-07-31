import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timetable/timetable.dart';

import '../models/responses/appointment_list_response.dart';
import '../utils/date_time_utills.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../view_models/auth_view_model.dart';
import 'dialog_box/appointment_ready_dailog.dart';

enum CalendarViewMode { month, week, day }

// class Appointment extends Event {
//   final String clinic;
//   final String service;
//   final String time;
//   final bool highlighted;

//   Appointment({
//     required this.clinic,
//     required this.service,
//     required this.time,
//     required super.start,
//     required super.end,
//     this.highlighted = false,
//   });

//   Appointment toUtc() {
//     return Appointment(
//       clinic: clinic,
//       service: service,
//       time: time,
//       start: start.copyWith(isUtc: true),
//       end: end.copyWith(isUtc: true),
//     );
//   }
// }

class AppointmentsCalendar extends StatefulWidget {
  final List<AppointmentData> appointments;
  const AppointmentsCalendar({super.key, required this.appointments});

  @override
  State<AppointmentsCalendar> createState() => _AppointmentsCalendarState();
}

class _AppointmentsCalendarState extends State<AppointmentsCalendar>
    with TickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  CalendarViewMode _viewMode = CalendarViewMode.month;
  late final _dateController = DateController(
    initialDate: _focusedDay.atStartOfDay.copyWith(isUtc: true),
    visibleRange: VisibleDateRange.week(),
  );

  // final Map<DateTime, List<AppointmentData>> _appointments = widget.appointmentList;
  List<AppointmentData> _getEvents(DateTime day) {
    // final key = DateTime(day.year, day.month, day.day);
    // return _appointments[key] ?? [];

    return widget.appointments.where((appointment) {
      final aDate = appointment.date;
      if (aDate == null) {
        return false;
      }
      return day.day == aDate.day && day.month == aDate.month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: context.h(16)),
        if (_viewMode == CalendarViewMode.month) ...[
          _weekHeader(),
          SizedBox(height: context.h(8)),
          Expanded(child: _calendar()),
        ] else
          Expanded(child: _timetable()),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SizedBox(height: context.h(19)),
        Container(
          margin: EdgeInsets.only(right: context.w(24)),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.purple, width: 0.5),
            color: CustomColors.lightPurple.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.w(19),
            vertical: context.h(9),
          ),
          child: Text(
            _monthLabel(_focusedDay),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              if (_viewMode == CalendarViewMode.day) {
                _focusedDay = _focusedDay.subtract(const Duration(days: 1));
                _dateController.animateTo(
                  _focusedDay.copyWith(isUtc: true),
                  vsync: this,
                );
              } else if (_viewMode == CalendarViewMode.week) {
                _focusedDay = _focusedDay.subtract(const Duration(days: 7));
                _dateController.animateTo(
                  _focusedDay.copyWith(isUtc: true),
                  vsync: this,
                );
              } else {
                _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month - 1,
                  1,
                );
              }
              setState(() {});
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              if (_viewMode == CalendarViewMode.day) {
                _focusedDay = _focusedDay.add(const Duration(days: 1));
                _dateController.animateTo(
                  _focusedDay.copyWith(isUtc: true),
                  vsync: this,
                );
              } else if (_viewMode == CalendarViewMode.week) {
                _focusedDay = _focusedDay.add(const Duration(days: 7));
                _dateController.animateTo(
                  _focusedDay.copyWith(isUtc: true),
                  vsync: this,
                );
              } else {
                _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month + 1,
                  1,
                );
              }
              setState(() {});
            });
          },
        ),
        const Spacer(),
        SegmentedButton<CalendarViewMode>(
          segments: [
            ButtonSegment(
              value: CalendarViewMode.month,
              label: Text('Month', style: TextStyle(fontSize: context.sp(12))),
            ),
            ButtonSegment(
              value: CalendarViewMode.week,
              label: Text('Week', style: TextStyle(fontSize: context.sp(12))),
            ),
            ButtonSegment(
              value: CalendarViewMode.day,
              label: Text('Day', style: TextStyle(fontSize: context.sp(12))),
            ),
          ],
          selected: {_viewMode},
          // onSelectionChanged: (Set<CalendarViewMode> newSelection) {
          //   setState(() {
          //     _viewMode = newSelection.first;
          //   });
          //   if (_viewMode == CalendarViewMode.day) {
          //     _dateController.visibleRange = VisibleDateRange.days(1);
          //   } else {
          //     _dateController.visibleRange = VisibleDateRange.week();
          //   }
          // },
          onSelectionChanged: (Set<CalendarViewMode> newSelection) {
            final selected = newSelection.first;
            setState(() {
              _viewMode = selected;
              if (selected == CalendarViewMode.day) {
                _dateController.visibleRange = VisibleDateRange.days(1);
              } else {
                _dateController.visibleRange = VisibleDateRange.week();
              }
            });
          },
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _weekHeader() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _calendar() {
    return TableCalendar(
      shouldFillViewport: true,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      headerVisible: false,
      daysOfWeekVisible: false,
      eventLoader: _getEvents,
      calendarStyle: const CalendarStyle(
        cellMargin: EdgeInsets.symmetric(horizontal: 4),
        markerSize: 0.0,
        cellPadding: EdgeInsets.zero,
        outsideDaysVisible: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _dayCell(day, _getEvents(day));
        },
        todayBuilder: (context, day, focusedDay) {
          return _dayCell(day, _getEvents(day), isToday: true);
        },
        outsideBuilder: (context, day, focusedDay) {
          return _dayCell(day, const [], isOutside: true);
        },
      ),
      onPageChanged: (day) {
        setState(() {
          _focusedDay = day;
        });
      },
    );
  }

  Widget _timetable() {
    return TimetableConfig<AppointmentData>(
      dateController: _dateController,
      eventBuilder: (context, event) => _appointmentCard(event),
      eventProvider: eventProviderFromFixedList(
        widget.appointments
            .map(
              (appointment) => appointment.copyWith(
                start: appointment.start.toUtc(),
                end: appointment.end.toUtc(),
              ),
            )
            .toList(),
      ),
      theme: TimetableThemeData(
        context,
        // Hour divider lines color
        dateDividersStyle: DateDividersStyle(
          context,
          color: CustomColors.border,
        ),
        hourDividersStyle: HourDividersStyle(
          context,
          color: CustomColors.border,
        ),
      ),
      child: MultiDateTimetable<AppointmentData>(),
    );
  }

  Widget _dayCell(
    DateTime day,
    List<AppointmentData> events, {
    bool isToday = false,
    bool isOutside = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.w(8)),
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFFE8FBF4) : CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isOutside ? Colors.grey : CustomColors.black,
            ),
          ),
          SizedBox(height: context.h(6)),
          ...events.map(_appointmentCard),
        ],
      ),
    );
  }

  Widget _appointmentCard(AppointmentData a) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () {
            ref
                .read(authViewModelProvider.notifier)
                .navigateDailogIndexToNext(0);
            showDialog(
              context: context,
              builder: (_) => const AppointmentReadyDailog(),
            );
          },
          child: Container(
            height: 95.h,
            padding: EdgeInsets.all(context.w(8)),
            decoration: BoxDecoration(
              color: a.date?.isToday ?? false
                  ? const Color(0xFFA7F3D0)
                  : CustomColors.softGrey,
              borderRadius: BorderRadius.circular(context.r(8)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.appointmentType?.capitalize ?? 'N/A',
                    style: TextStyle(
                      fontSize: context.sp(10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: context.h(4)),
                  Text(
                    a.doctorName?.capitalize ?? 'N/A',
                    style: TextStyle(
                      fontSize: context.sp(9),
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '${a.start.formattedTime} - ${a.end.formattedTime}',
                    style: TextStyle(
                      fontSize: context.sp(9),
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
