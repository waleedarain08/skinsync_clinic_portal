
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/responsive.dart';
import '../../utils/theme.dart';

import '../../view_models/auth_view_model.dart';
import '../../widgets/frequently_conversion.widget.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/analytics_grid_widget.dart';
import '../../widgets/appointment_status_pie_chart.dart';
import '../../widgets/revenue_generated_chart_widget.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../services/locator.dart';
import '../../services/storage_service.dart';
import '../../widgets/recent_treatment_row_widget.dart';
import '../../widgets/today_appointments_row_widget.dart';
import '../../widgets/today_checkin_tile.dart';
import '../../widgets/treatment_list_widget.dart';
import '../business_info_screen.dart';
import 'appointment_screen.dart';
import 'shared_treatment_request_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    ref.read(authViewModelProvider.notifier).callGetMe();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isCompleted = ref.read(authViewModelProvider).isCompletedProfile;

      if (!isCompleted && mounted) {
        _showIncompleteProfileDialog(context);
      }
    });
    super.initState();
  }

  void _showIncompleteProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(16)),
          ),
          child: SizedBox(
            width: context.w(360),
            child: Padding(
              padding: EdgeInsets.all(context.w(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        color: CustomColors.purple,
                        size: context.sp(22),
                      ),
                      SizedBox(width: context.w(8)),
                      Expanded(
                        child: Text(
                          'Complete Your Profile',
                          style: CustomFonts.black16w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  Text(
                    'Your clinic profile is incomplete. Update your business information to access all portal features.',
                    style: CustomFonts.grey13w500,
                  ),
                  SizedBox(height: context.h(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Remind Me Later',
                          style: CustomFonts.grey13w500,
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.r(8)),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await ref
                              .read(authViewModelProvider.notifier)
                              .getClinicDetail();
                          context.pushNamed(
                            BusinessInformationScreen.routeName,
                          );
                        },
                        child: const Text(
                          'Update Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: locator<SecureStorageService>().getUser(),
                    builder: (context, snapshot) {
                      final name = snapshot.data?.name ?? 'Alex';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, $name',
                            style: context.fonts.level1Heading,
                          ),
                          context.verticalSpace(6),
                          Text(
                            "Here's a summary of your MedSpa clinic performance.",
                            style: context.fonts.grey13w500,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            context.verticalSpace(32),

            // Analytics Section
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Analytics", style: context.fonts.black18w600),
                  context.verticalSpace(24),
                  const AnalyticsGridWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            // Revenue Generated Chart
            const RevenueGeneratedChartWidget(),
            context.verticalSpace(32),

            // Appointment Status Breakdown Pie Chart
            const AppointmentStatusPieChart(),
            context.verticalSpace(32),

            // Today's Check-in Section
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptiveLayoutRowColumn(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Check-in",
                        style: context.fonts.black18w600,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  Consumer(
                    builder: (context, ref, child) {
                      final checkIns =
                          ref
                              .watch(authViewModelProvider)
                              .dashboard
                              ?.todaysCheckin ??
                          [];

                      if (checkIns.isEmpty) {
                        return Center(
                          child: Container(
                            height: context.h(101),
                            width: context.w(400),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                context.r(24),
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  CustomColors.lightPurple,
                                  CustomColors.purpleColor,
                                ],
                              ),
                              border: Border.all(
                                color: CustomColors.lightPurple.withValues(
                                  alpha: 0.4,
                                ),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.r(22),
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.w(16),
                                      vertical: context.h(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: context.w(44),
                                          width: context.w(44),
                                          decoration: BoxDecoration(
                                            color: CustomColors.purpleColor
                                                .withValues(alpha: 0.12),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: CustomColors.purpleColor
                                                  .withValues(alpha: 0.15),
                                              width: context.w(1),
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.login_outlined,
                                              color: CustomColors.purpleColor,
                                              size: context.sp(20),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: context.w(12)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "No Check-ins Today",
                                                style: CustomFonts.black14w700,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: context.h(2)),
                                              Text(
                                                "There are no patient check-ins for today.",
                                                style: CustomFonts.grey12w400,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: context.h(140),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: checkIns.length,
                          separatorBuilder: (context, index) =>
                              context.horizontalSpace(12),
                          itemBuilder: (context, index) {
                            final checkIn = checkIns[index];
                            return SizedBox(
                              width: context.w(300),
                              child: TodaysCheckInTile(
                                patientImage: checkIn.patientImage ?? '',
                                name: checkIn.patientName ?? 'Unknown patient',
                                email: checkIn.patientEmail ?? '',
                                appointmentRef:
                                    checkIn.appointmentReference ?? '-',
                                appointmentId: checkIn.appointmentId!,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            context.verticalSpace(32),

            // Today Treatments Request Section
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptiveLayoutRowColumn(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Treatment Requests",
                        style: context.fonts.black18w600,
                      ),
                      TextButton(
                        onPressed: () {
                           context.push(SharedTreatmentRequestScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TreatmentRequestRowWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            // Today's Appointments Section
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptiveLayoutRowColumn(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Appointments",
                        style: context.fonts.black18w600,
                      ),
                      TextButton(
                        onPressed: () {
                          context.push(AppointmentScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TodayAppointmentsRowWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptiveLayoutRowColumn(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Frequently Conversions",
                        style: context.fonts.black18w600,
                      ),

                      // TextButton(
                      //   onPressed: () {},
                      //   style: TextButton.styleFrom(
                      //     padding: EdgeInsets.zero,
                      //     minimumSize: Size.zero,
                      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Text("View All", style: context.fonts.purple14w600),
                      //       context.horizontalSpace(6),
                      //       const Icon(
                      //         Icons.arrow_forward_ios_rounded,
                      //         size: 14,
                      //         color: CustomColors.purple,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  context.verticalSpace(24),
                  Consumer(
                    builder: (context, ref, child) {
                      // Dummy data for Frequently Conversion
                      final dummyConversions = [
                        {
                          'patientImage': '',
                          'name': 'James Anderson',
                          'email': 'james.anderson@example.com',
                          'phoneNumber': '+1 (555) 234-5678',
                          'appointmentRef': 'APT-1001',
                          'appointmentId': 101,
                          'conversionCount': 12,
                        },
                        {
                          'patientImage': '',
                          'name': 'Sarah Wilson',
                          'email': 'sarah.wilson@example.com',
                          'phoneNumber': '+1 (555) 876-5432',
                          'appointmentRef': 'APT-1002',
                          'appointmentId': 102,
                          'conversionCount': 8,
                        },
                        {
                          'patientImage': '',
                          'name': 'Michael Smith',
                          'email': 'michael.smith@example.com',
                          'phoneNumber': '+1 (555) 345-6789',
                          'appointmentRef': 'APT-1003',
                          'appointmentId': 103,
                          'conversionCount': 15,
                        },
                        {
                          'patientImage': '',
                          'name': 'Emily Johnson',
                          'email': 'emily.johnson@example.com',
                          'phoneNumber': '+1 (555) 987-6543',
                          'appointmentRef': 'APT-1004',
                          'appointmentId': 104,
                          'conversionCount': 6,
                        },
                      ];
                      return SizedBox(
                        height: context.h(160),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: dummyConversions.length,
                          separatorBuilder: (context, index) =>
                              context.horizontalSpace(12),
                          itemBuilder: (context, index) {
                            final conversion = dummyConversions[index];

                            return SizedBox(
                              width: context.w(300),
                              child: FrequentlyConversionTile(
                                patientImage:
                                    conversion['patientImage'] as String,
                                name: conversion['name'] as String,
                                email: conversion['email'] as String,
                                appointmentRef:
                                    conversion['appointmentRef'] as String,
                                appointmentId:
                                    conversion['appointmentId'] as int,
                                conversionCount:
                                    conversion['conversionCount'] as int,
                                    phoneNumber:  conversion['phoneNumber'] as String, 
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            context.verticalSpace(32),
            //  Treatments Section
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Frequently Use Treatments",
                          style: context.fonts.black18w600,
                        ),
                      ),
                      context.horizontalSpace(20),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TreatmentListWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),
          ],
        ),
      ),
    );
  }
}
