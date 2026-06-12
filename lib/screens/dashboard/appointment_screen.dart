import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_clinic_portal/utils/enums.dart';
import 'package:skinsync_clinic_portal/view_models/appointment_view_model.dart';
import 'package:skinsync_clinic_portal/view_models/auth_view_model.dart';
import 'package:skinsync_clinic_portal/widgets/appointment_tile_widget.dart';
import 'package:skinsync_clinic_portal/widgets/borderd_container_widget.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/appointment_ready_dailog.dart';
import 'package:skinsync_clinic_portal/widgets/number_paginator.dart';

import '../../utils/theme.dart';
import '../../widgets/appointment_horizontal_tile_widget.dart';
import '../../widgets/calender_widget.dart';
import '../../widgets/custom_dropdown_widget.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  static const String routeName = '/appointment';

  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

final List<AppointmentModel> dummyAppointments = [
  const AppointmentModel(
    patientName: 'Sarah Johnson',
    treatment: 'Botox',
    date: '10/29/2025',
    time: '10:00 AM',
    doctor: 'Dr. Smith',
    amount: 350,
    status: AppointmentStatus.arrived,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'Emma Davis',
    treatment: 'Filler',
    date: '10/30/2025',
    time: '11:00 AM',
    doctor: 'Dr. Lee',
    amount: 450,
    status: AppointmentStatus.ongoing,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'James Brown',
    treatment: 'Laser',
    date: '04/16/2026',
    time: '09:00 AM',
    doctor: 'Dr. Smith',
    amount: 600,
    status: AppointmentStatus.delayed,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Olivia White',
    treatment: 'Hydrafacial',
    date: '04/16/2026',
    time: '02:00 PM',
    doctor: 'Dr. Adams',
    amount: 250,
    status: AppointmentStatus.noShow,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Liam Wilson',
    treatment: 'Microneedling',
    date: '04/17/2026',
    time: '03:00 PM',
    doctor: 'Dr. Lee',
    amount: 300,
    status: AppointmentStatus.completed,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'Sophia Moore',
    treatment: 'Chemical Peel',
    date: '04/15/2026',
    time: '01:00 PM',
    doctor: 'Dr. Adams',
    amount: 200,
    status: AppointmentStatus.ongoing,
    isToday: false,
  ),
];

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentProvider.notifier).getAppointments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentProvider);

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(20)),
              Row(
                children: [
                  Text('Appointments', style: CustomFonts.black20w600),
                  SizedBox(width: context.w(36)),
                  Expanded(
                    child: SizedBox(
                      height: context.h(45),
                      child: ListView.builder(
                        itemCount: 6,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Consumer(
                            builder: (context, ref, _) {
                              return AppointmentHorizontalTileWidget(
                                index: index,
                                selected: index == 0,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(14)),
              const Divider(color: CustomColors.border),
              SizedBox(height: context.h(14)),
              SizedBox(
                height: context.h(800),
                child: const AppointmentsCalendar(),
              ),
              SizedBox(height: context.h(15)),
              BorderdContainerWidget(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: CupertinoSearchTextField(
                        style: context.fonts.black14w400,
                        placeholderStyle: context.fonts.grey14w400,
                        backgroundColor: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(10)),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(12),
                          vertical: context.h(10),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Expanded(
                      flex: 3,
                      child: CustomDropdown<String>(
                        hint: "All Appointments",
                        value: appointmentState.filter?.label,
                        items: AppointmentFilter.values
                            .map((e) => e.label)
                            .toList(),
                        height: context.h(42),
                        onChanged: (value) {
                          ref.read(appointmentProvider.notifier).setFilter(
                                AppointmentFilter.fromLabel(
                                  value ?? 'All Appointments',
                                ),
                              );
                        },
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Expanded(
                      flex: 2,
                      child: CustomDropdown<String>(
                        hint: "Status",
                        value: appointmentState.status?.label,
                        items: AppointmentStatus.values
                            .map((e) => e.label)
                            .toList(),
                        height: context.h(42),
                        onChanged: (value) {
                          ref.read(appointmentProvider.notifier).setStatus(
                                AppointmentStatus.fromLabel(
                                  value ?? 'All Status',
                                ),
                              );
                        },
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.r(10)),
                          color: CustomColors.black,
                        ),
                        padding: EdgeInsets.all(context.w(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              color: CustomColors.white,
                              size: context.r(16),
                            ),
                            SizedBox(width: context.w(5)),
                            Text(
                              "New Appointment",
                              style: CustomFonts.white12w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(15)),
              Consumer(
  builder: (context, ref, _) {
    final loading = appointmentState.loading;
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: CustomColors.purple,
        ),
      );
    }

    final filteredList = _getFilteredAppointments(appointmentState.filter);

    if (filteredList.isEmpty) {
      return _buildEmptyState();
    }

    return _buildAppointmentsTable(filteredList);
  },
),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  

  List<AppointmentModel> _getFilteredAppointments(AppointmentFilter? filter) {
    switch (filter) {
      case AppointmentFilter.today:
        return dummyAppointments.where((a) => a.isToday).toList();
      case AppointmentFilter.past:
        return dummyAppointments
            .where((a) =>
                a.status == AppointmentStatus.completed ||
                a.status == AppointmentStatus.noShow)
            .toList();
      default:
        return dummyAppointments;
    }
  }

  Widget _buildFooter() {
    return Consumer(
      builder: (context, ref, _) {
        final appointmentState = ref.watch(appointmentProvider);
        final totalPage = appointmentState.totalPage ?? 0;
        final page = appointmentState.page;
        // if (totalPage == 0) {
        //   return const SizedBox.shrink();
        // }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Showing Results $page-$totalPage', style: CustomFonts.grey14w400),
            NumberPaginator(
              totalPages: totalPage,
              currentPage: page,
              onPageChanged: (page) {
                ref.read(appointmentProvider.notifier).setPageNumber(page);
              },
            ),
          ],
        );
      },
    );
  }

Widget _buildAppointmentsTable(List<AppointmentModel> list) {
  return BorderdContainerWidget(
    padding: EdgeInsets.zero,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3), // Patient
          1: FlexColumnWidth(2), // Treatment
          2: FlexColumnWidth(2), // Date & Time
          3: FlexColumnWidth(2), // Doctor
          4: FlexColumnWidth(2), // Amount
          5: FlexColumnWidth(2), // Status
          6: FlexColumnWidth(1), // Actions
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Header Row
          TableRow(
            decoration: const BoxDecoration(
              color: CustomColors.whiteGrey,
              border: Border(bottom: BorderSide(color: CustomColors.border)),
            ),
            children: const [
              _AppointmentHeaderCell("PATIENT"),
              _AppointmentHeaderCell("TREATMENT"),
              _AppointmentHeaderCell("DATE & TIME"),
              _AppointmentHeaderCell("DOCTOR"),
              _AppointmentHeaderCell("AMOUNT"),
              _AppointmentHeaderCell("STATUS"),
              _AppointmentHeaderCell("ACTIONS"),
            ],
          ),
          // Data Rows
          ...list.map((a) {
            return TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _appointmentPatientCell(a),
                _appointmentTextCell(a.treatment, style: context.fonts.black14w600),
                _appointmentTextCell("${a.date}\n${a.time}", style: context.fonts.grey14w400),
                _appointmentTextCell(a.doctor, style: context.fonts.grey14w400),
                _appointmentTextCell("\$${a.amount.toStringAsFixed(0)}", style: context.fonts.black14w600),
                _appointmentStatusBadgeCell(a.status),
                _appointmentActionsCell(a),
              ],
            );
          }),
        ],
      ),
    ),
  );
}

Widget _appointmentPatientCell(AppointmentModel a) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Row(
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundColor: CustomColors.palePurple,
          child: Text(
            a.patientName.isNotEmpty ? a.patientName[0] : "?",
            style: context.fonts.purple12w700,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            a.patientName,
            style: context.fonts.black14w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _appointmentTextCell(String text, {required TextStyle style}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Text(
      text,
      style: style,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _appointmentStatusBadgeCell(AppointmentStatus status) {
  Color badgeColor;
  switch (status) {
    case AppointmentStatus.completed:
    case AppointmentStatus.arrived:
      badgeColor = CustomColors.green;
      break;
    case AppointmentStatus.ongoing:
      badgeColor = Colors.blue;
      break;
    case AppointmentStatus.delayed:
      badgeColor = CustomColors.purple;
      break;
    case AppointmentStatus.noShow:
      badgeColor = CustomColors.red;
      break;
    default:
      badgeColor = CustomColors.grey;
  }

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
          ),
          child: Text(
            status.label,
            style: context.fonts.grey12w600.copyWith(
              color: badgeColor,
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _appointmentActionsCell(AppointmentModel a) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
    child: IconButton(
      tooltip: "View Details",
      icon: Icon(Icons.visibility_outlined, color: CustomColors.grey, size: 20.sp),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        ref.read(authViewModelProvider.notifier).navigateDailogIndexToNext(0);
        showDialog(
          context: context,
          builder: (_) => const AppointmentReadyDailog(),
        );
      },
    ),
  );
}
Widget _buildEmptyState() {
  return BorderdContainerWidget(
    padding: EdgeInsets.all(context.w(48)),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(context.w(20)),
            decoration: const BoxDecoration(
              color: CustomColors.whiteGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_busy_rounded, size: context.sp(48), color: CustomColors.grey),
          ),
          SizedBox(height: context.h(24)),
          Text("No appointments found", style: context.fonts.black18w600),
          SizedBox(height: context.h(8)),
          Text(
            "Try changing your filters or search keyword.",
            style: context.fonts.grey14w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

}

class _AppointmentHeaderCell extends StatelessWidget {
  final String label;
  const _AppointmentHeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }
}

class AppointmentModel {
  final String patientName;
  final String treatment;
  final String date;
  final String time;
  final String doctor;
  final double amount;
  final AppointmentStatus status;
  final bool isToday;

  const AppointmentModel({
    required this.patientName,
    required this.treatment,
    required this.date,
    required this.time,
    required this.doctor,
    required this.amount,
    required this.status,
    required this.isToday,
  });
}
