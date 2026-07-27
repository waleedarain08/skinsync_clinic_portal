import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/responses/filters_response.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/select_or_create_dropdown_widget.dart';
import '../create_appointment_screen.dart';
import '../../models/responses/appointment_response.dart' hide Material;
import '../../utils/date_time_utills.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_view_model.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/appointment_horizontal_tile_widget.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/calender_widget.dart';
import '../../widgets/dialog_box/appointment_ready_dailog.dart';
import '../../widgets/number_paginator.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  static const String routeName = '/appointment';

  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

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
              Consumer(
                builder: (context, ref, _) {
                  final list = appointmentState.appointmentList ?? [];
                  final loading = appointmentState.loading;
                  if (loading) {
                    return const SizedBox();
                  }

                  if (list.isEmpty) {
                    return _buildEmptyState();
                  }
                  return SizedBox(
                    height: context.h(800),
                    child: Material(
                      child: AppointmentsCalendar(appointments: list),
                    ),
                  );
                },
              ),
              SizedBox(height: context.h(15)),
              BorderdContainerWidget(
                child: Row(
             crossAxisAlignment:CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CupertinoSearchTextField(
                        controller: ref.read(appointmentProvider.notifier).searchController ,
                        onChanged: (_){ ref.read(appointmentProvider.notifier).getAppointments(initialCall: true,showEasyLoading:  true);},
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
                      child: Consumer(
                        builder: (context, ref, _) {
                          final appointmentState = ref.watch(
                            appointmentProvider,
                          );
                          final filters =
                              appointmentState.appointmentTypes ?? [];

                          return SelectOrCreateDropdown<String>(
                            label: 'Appointment',
                            hint: 'All Appointments',
                            value: appointmentState.filter?.name,
                            showAddIcon: false,
                            items: filters.map((e) => e.name ?? '').toList(),
                            itemLabel: (filter) => filter,
                            onChanged: (value) {
                              final selected = filters.firstWhere(
                                (f) => f.name == value,
                                orElse: () => Filters(),
                              );
                              ref
                                  .read(appointmentProvider.notifier)
                                  .setFilter(value == null ? null : selected);
                            },
                            onOpen: () => ref
                                .read(appointmentProvider.notifier)
                                .getAppointmentsTypes(),
                            onCreate: () {},
                          );
                        },
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Expanded(
                      flex: 2,
                      child: Consumer(
                        builder: (context, ref, _) {
                          final appointmentState = ref.watch(
                            appointmentProvider,
                          );
                          final statuses =
                              appointmentState.appointmentStatus ?? [];

                          return SelectOrCreateDropdown<String>(
                            label: 'Status',
                            hint: 'All Status',
                            value: appointmentState.status?.name,
                            showAddIcon: false,
                            items: statuses.map((e) => e.name ?? '').toList(),
                            itemLabel: (status) => status,
                            onChanged: (value) {
                              final selected = value == null
                                  ? null
                                  : statuses
                                        .where((s) => s.name == value)
                                        .firstOrNull;
                              ref
                                  .read(appointmentProvider.notifier)
                                  .setStatus(selected);
                            },
                            onOpen: () => ref
                                .read(appointmentProvider.notifier)
                                .getAppointmentsStatus(),
                            onCreate: () {},
                          );
                        },
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Expanded(
                      flex: 2,
                      child: CustomPrimaryButton(
                        onTap: () =>
                            context.push(CreateAppointmentScreen.routeName),
                        icon: Icons.add,
                        label: "New Appointment",
                        height: context.h(42),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(15)),
              Builder(
                builder: (context) {
                  final loading = appointmentState.loading;
                  if (loading) {
                    return const Center(child: AppLoader());
                  }

                  final list = appointmentState.appointmentList ?? [];

                  if (list.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildAppointmentsTable(list);
                },
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Consumer(
      builder: (context, ref, _) {
        final appointmentState = ref.watch(appointmentProvider);
        final totalPage = appointmentState.totalPage ?? 0;
        final page = appointmentState.page;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing Results $page-$totalPage',
              style: CustomFonts.grey14w400,
            ),
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

  Widget _buildAppointmentsTable(List<AppointmentListData> list) {
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
            const TableRow(
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _AppointmentHeaderCell("PATIENT"),
                _AppointmentHeaderCell("TREATMENT"),
                _AppointmentHeaderCell("DATE & TIME"),
                _AppointmentHeaderCell("CLINIC"),
                _AppointmentHeaderCell("AMOUNT"),
                _AppointmentHeaderCell("STATUS"),
                _AppointmentHeaderCell("ACTIONS"),
              ],
            ),
            ...list.map((a) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _appointmentPatientCell(a),
                  _appointmentTextCell(
                    a.appointmentType?.title ?? '-',
                    style: context.fonts.black14w600,
                  ),
                  _appointmentTextCell(
                    a.date?.formattedDate ?? '-',
                    style: context.fonts.grey14w400,
                  ),
                  _appointmentTextCell(
                    a.clinicName ?? '-',
                    style: context.fonts.grey14w400,
                  ),
                  _appointmentTextCell(
                    "\$${(a.treatmentTotal ?? 0).toStringAsFixed(0)}",
                    style: context.fonts.black14w600,
                  ),
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

  // Assumption: `date` = unix seconds, `start_time`/`end_time` = unix seconds too.
  // Swap to whatever encoding your API actually uses.

  Widget _appointmentPatientCell(AppointmentListData a) {
    final name = a.patientName ?? '-';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: CustomColors.palePurple,
            child: Text(
              name.isNotEmpty ? name[0] : "?",
              style: context.fonts.purple12w700,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              name,
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

  Widget _appointmentStatusBadgeCell(String? status) {
    final normalized = status?.toLowerCase() ?? '';
    Color badgeColor;
    switch (normalized) {
      case 'completed':
      case 'arrived':
        badgeColor = CustomColors.green;
        break;
      case 'ongoing':
        badgeColor = Colors.blue;
        break;
      case 'delayed':
        badgeColor = CustomColors.purple;
        break;
      case 'no_show':
      case 'no-show':
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
              status ?? '-',
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

  Widget _appointmentActionsCell(AppointmentListData a) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: IconButton(
        tooltip: "View Details",
        icon: Icon(
          Icons.visibility_outlined,
          color: CustomColors.grey,
          size: 20.sp,
        ),
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
              child: Icon(
                Icons.event_busy_rounded,
                size: context.sp(48),
                color: CustomColors.grey,
              ),
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
