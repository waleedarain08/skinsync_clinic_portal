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
                  if (appointmentState.appointmentList == null ||
                      appointmentState.appointmentList!.isEmpty) {
                    return Center(
                      child: Text(
                        "No appointments found",
                        style: CustomFonts.black14w600,
                      ),
                    );
                  }

                  // Use filtered list size to map index safely to actual UI items
                  final filteredList = _getFilteredAppointments(appointmentState.filter);
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final appointment = filteredList[index];

                      return AppointmentTileWidget(
                        appointment: appointment,
                        onTap: () {
                          ref
                              .read(authViewModelProvider.notifier)
                              .navigateDailogIndexToNext(0);

                          showDialog(
                            context: context,
                            builder: (_) => const AppointmentReadyDailog(),
                          );
                        },
                      );
                    },
                  );
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
        if (totalPage == 0) {
          return const SizedBox.shrink();
        }
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
