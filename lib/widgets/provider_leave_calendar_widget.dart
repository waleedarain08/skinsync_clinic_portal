import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/responses/appointment_list_response.dart';
import '../screens/dashboard/appointment_detail_screen.dart';
import '../utils/theme.dart';
import '../view_models/appointment_view_model.dart';
import 'borderd_container_widget.dart';
import 'custom_primary_button.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentProvider.notifier).getAppointments();
    });
  }

  void _showMarkLeaveDialog(BuildContext context, DateTime startDate) {
    final dateController = TextEditingController(
      text: DateFormat('MMM dd, yyyy').format(startDate),
    );
    String leaveType = 'Annual Leave';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Mark Provider Leave', style: context.fonts.black18w600),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leave Type', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  DropdownButtonFormField<String>(
                    value: leaveType,
                    decoration: AppDecorations.input(context),
                    items: ['Annual Leave', 'Sick Leave', 'Personal Leave', 'Unpaid Leave']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type, style: context.fonts.black14w400),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => leaveType = val);
                      }
                    },
                  ),
                  context.verticalSpace(16),
                  Text('Selected Date', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  TextField(
                    controller: dateController,
                    style: context.fonts.black14w400,
                    decoration: AppDecorations.input(
                      context,
                      hint: 'Date',
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text('Cancel', style: context.fonts.grey13w500),
                ),
                CustomPrimaryButton(
                  label: 'Mark Leave',
                  onTap: () {
                    if (dateController.text.trim().isEmpty) return;
                    setState(() {
                      _leaves.insert(
                        0,
                        LeaveRecord(
                          dateRange: dateController.text.trim(),
                          reason: leaveType,
                          status: 'Approved',
                        ),
                      );
                    });
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Leave marked successfully')),
                    );
                  },
                  width: 165,
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);
    final appointments = appointmentState.appointmentList ?? [];

    List<AppointmentData> getAppointmentsForDay(DateTime day) {
      return appointments.where((a) {
        final date = a.date ?? a.start;
        return isSameDay(date, day);
      }).toList();
    }

    final selectedDayAppointments = _selectedDay != null
        ? getAppointmentsForDay(_selectedDay!)
        : <AppointmentData>[];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Calendar & Leaves', style: context.fonts.subHeading),
              CustomPrimaryButton(
                onTap: () => _showMarkLeaveDialog(
                  context,
                  _selectedDay ?? DateTime.now(),
                ),
                label: 'Mark Leave',
                icon: Icons.event_busy_outlined,
                height: context.h(36),
                width: context.w(165),
              ),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),

          // Inline TableCalendar with appointment markers
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
            Text(
              'Appointments on ${DateFormat('MMM dd, yyyy').format(_selectedDay!)}',
              style: context.fonts.black14w600,
            ),
            context.verticalSpace(12),
            ...selectedDayAppointments.map((appt) => Container(
                  margin: EdgeInsets.only(bottom: context.h(12)),
                  padding: context.appEdgeInsets(all: 12),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
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
                              'Ref: ${appt.appointmentKey ?? appt.id}',
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
                            borderRadius: BorderRadius.circular(context.r(8)),
                          ),
                        ),
                        onPressed: () async {
                          if (appt.id != null) {
                            await ref
                                .read(appointmentProvider.notifier)
                                .getAppointmentsDetail(id: appt.id!);
                            if (context.mounted) {
                              context.push(AppointmentDetailScreen.routeName);
                            }
                          }
                        },
                        child: const Text(
                          'Reschedule / View',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                )),
            context.verticalSpace(16),
          ],

          Text('Recorded Leaves', style: context.fonts.black14w600),
          context.verticalSpace(12),
          if (_leaves.isEmpty)
            Text('No leaves recorded.', style: context.fonts.grey14w400)
          else
            ..._leaves.map((leave) => Padding(
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
                            Text(leave.dateRange, style: context.fonts.grey12w400),
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
                )),
        ],
      ),
    );
  }
}
