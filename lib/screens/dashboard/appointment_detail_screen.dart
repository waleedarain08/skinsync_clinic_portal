import 'package:cached_network_image/cached_network_image.dart';
import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/string_utils.dart';
import '../../models/responses/appointment_detail_response.dart';
import '../../utils/date_time_utills.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';
import 'appointment_treatment_detail_screen.dart';

class AppointmentDetailScreen extends ConsumerWidget {
  static const String routeName = '/appointment-detail';

  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentProvider).appointmentDetail;

    if (appointment == null) {
      return const GradientScaffold(body: Center(child: AppLoader()));
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Appointment Details', style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewHeader(context, appointment),
            context.verticalSpace(24),
            _buildSection(
              context,
              title: 'Patient Information',
              children: [_buildPatientInfo(context, appointment)],
            ),
            context.verticalSpace(24),
            _buildSection(
              context,
              title: 'Appointment Schedule',
              children: [_buildScheduleInfo(context, appointment)],
            ),
            if (appointment.treatments != null &&
                appointment.treatments!.isNotEmpty) ...[
              context.verticalSpace(24),
              _buildSection(
                context,
                title: 'Assigned Treatments',
                children: [_buildTreatmentsList(context, appointment)],
              ),
            ],
            if (appointment.simulations != null) ...[
              context.verticalSpace(24),
              _buildSection(
                context,
                title: 'Simulations',
                children: [_buildSimulationsGrid(context, appointment)],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewHeader(
    BuildContext context,
    AppointmentDetailData appointment,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available,
              color: CustomColors.purple,
              size: 32,
            ),
          ),
          context.horizontalSpace(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment #${appointment.appointmentKey ?? ""}',
                  style: context.fonts.level2Heading,
                ),
                context.verticalSpace(4),
                Container(
                  padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  child: Text(
                    appointment.appointmentType?.title?.capitalize ??
                        'Consultation',
                    style: context.fonts.purple12w700,
                  ),
                ),
                context.verticalSpace(12),
                Row(
                  children: [
                    _statusIndicator(appointment.status),
                    context.horizontalSpace(8),
                    Text(
                      (appointment.status ?? "pending").toUpperCase(),
                      style: context.fonts.black12w600.copyWith(
                        color: _getStatusColor(appointment.status),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusIndicator(String? status) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStatusColor(status),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    final normalized = status?.toLowerCase() ?? '';
    switch (normalized) {
      case 'completed':
      case 'arrived':
        return CustomColors.green;
      case 'ongoing':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'delayed':
        return CustomColors.purple;
      case 'no_show':
      case 'no-show':
        return CustomColors.red;
      default:
        return CustomColors.grey;
    }
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.subHeading),
          const Divider(color: CustomColors.border, height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPatientInfo(
    BuildContext context,
    AppointmentDetailData appointment,
  ) {
    final p = appointment.patient;
    return Row(
      children: [
        _buildAvatar(context, p?.profileImageUrl, 30),
        context.horizontalSpace(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p?.name?.capitalize ?? 'N/A',
                style: context.fonts.black16w600,
              ),
              context.verticalSpace(4),
              _infoRow(
                context,
                Icons.email_outlined,
                'Email',
                p?.email ?? 'N/A',
                marginBottom: 8,
              ),
              _infoRow(
                context,
                Icons.phone_outlined,
                'Phone',
                p?.phoneNumber ?? 'N/A',
                marginBottom: 0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfo(
    BuildContext context,
    AppointmentDetailData appointment,
  ) {
    final dateStr = appointment.date != null
        ? DateTimeUtils.formatTimestampToDayDate(appointment.date!)
        : 'N/A';
    final startTimeStr = appointment.startTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.startTime!)
        : 'N/A';
    final endTimeStr = appointment.endTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.endTime!)
        : 'N/A';

    return Column(
      children: [
        _infoRow(context, Icons.calendar_today_outlined, 'Date', dateStr),
        _infoRow(
          context,
          Icons.access_time_outlined,
          'Time Slot',
          '$startTimeStr - $endTimeStr',
        ),
        _infoRow(
          context,
          Icons.person_outline_rounded,
          'Assigned Provider',
          appointment.doctor?.name != null &&
                  appointment.doctor!.name!.isNotEmpty
              ? '${appointment.doctor?.title?.capitalize ?? ""} ${appointment.doctor?.name?.capitalize ?? ""}'
              : 'Not Assigned',
        ),
        _infoRow(
          context,
          Icons.payment_outlined,
          'Payment Status',
          appointment.paymentType?.status?.toUpperCase() ?? 'N/A',
          marginBottom: 0,
        ),
      ],
    );
  }

  Widget _buildTreatmentsList(
    BuildContext context,
    AppointmentDetailData appointment,
  ) {
    return Column(
      children: [
        ...appointment.treatments!.map((t) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                if (t.treatmentId != null) {
                  context.push(
                    AppointmentTreatmentDetailScreen.routeName,
                    extra: t.treatmentId,
                  );
                }
              },
              borderRadius: BorderRadius.circular(context.r(8)),
              child: Container(
                padding: context.appEdgeInsets(all: 12),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: BorderRadius.circular(context.r(8)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.treatmentName?.capitalize ?? 'Treatment',
                          style: context.fonts.black14w600,
                        ),
                        context.verticalSpace(2),
                        Text(
                          'Area: ${t.areaName?.capitalize ?? "N/A"}',
                          style: context.fonts.grey12w400,
                        ),
                      ],
                    ),
                    Text(
                      '\$${t.treatmentCost?.toStringAsFixed(2) ?? "0.00"}',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const Divider(height: 24, color: CustomColors.border),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Amount', style: context.fonts.black16w700),
            Text(
              '\$${appointment.treatmentTotal?.toStringAsFixed(2) ?? "0.00"}',
              style: context.fonts.black18w600,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSimulationsGrid(
    BuildContext context,
    AppointmentDetailData appointment,
  ) {
    if (appointment.simulations == null) return const SizedBox();
    return _AppointmentSimulationsWidget(simulations: appointment.simulations!);
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    double marginBottom = 20,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(marginBottom)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomColors.purple),
          context.horizontalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.fonts.grey12w400),
              context.verticalSpace(4),
              Text(value, style: context.fonts.black14w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? imageUrl, double radius) {
    return ClipOval(
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: context.r(radius * 2),
              width: context.r(radius * 2),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  _buildDefaultAvatar(context, radius),
            )
          : _buildDefaultAvatar(context, radius),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, double radius) {
    return CircleAvatar(
      radius: context.r(radius),
      backgroundColor: CustomColors.softGrey,
      child: Icon(
        Icons.person,
        size: context.r(radius),
        color: CustomColors.grey,
      ),
    );
  }
}

class _AppointmentSimulationsWidget extends StatefulWidget {
  final Simulations simulations;

  const _AppointmentSimulationsWidget({required this.simulations});

  @override
  State<_AppointmentSimulationsWidget> createState() =>
      _AppointmentSimulationsWidgetState();
}

class _AppointmentSimulationsWidgetState
    extends State<_AppointmentSimulationsWidget> {
  final Map<String, double> _sliderValues = {};

  @override
  Widget build(BuildContext context) {
    final views = [
      if (widget.simulations.frontImageBefore != null ||
          widget.simulations.frontImageAfter != null)
        (
          'Front View',
          widget.simulations.frontImageBefore,
          widget.simulations.frontImageAfter
        ),
      if (widget.simulations.leftImageBefore != null ||
          widget.simulations.leftImageAfter != null)
        (
          'Left Profile',
          widget.simulations.leftImageBefore,
          widget.simulations.leftImageAfter
        ),
      if (widget.simulations.rightImageBefore != null ||
          widget.simulations.rightImageAfter != null)
        (
          'Right Profile',
          widget.simulations.rightImageBefore,
          widget.simulations.rightImageAfter
        ),
    ];

    if (views.isEmpty) {
      return Container(
        height: context.h(120),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColors.softGrey,
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Center(
          child: Text(
            'No simulation images available',
            style: context.fonts.grey14w400,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: views.map((view) {
          final (label, before, after) = view;
          _sliderValues.putIfAbsent(label, () => 0.5);

          return Padding(
            padding: EdgeInsets.only(right: context.w(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.fonts.grey12w600),
                context.verticalSpace(8),
                Container(
                  height: context.h(260),
                  width: context.w(260),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: BorderRadius.circular(context.r(16)),
                    border: Border.all(color: CustomColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: before != null && after != null
                      ? Stack(
                          children: [
                            BeforeAfter(
                              value: _sliderValues[label]!,
                              onValueChanged: (val) =>
                                  setState(() => _sliderValues[label] = val),
                              before: CachedNetworkImage(
                                imageUrl: before,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: context.h(260),
                                placeholder: (context, url) =>
                                    Container(color: CustomColors.softGrey),
                                errorWidget: (context, url, error) =>
                                    Container(color: CustomColors.softGrey),
                              ),
                              after: CachedNetworkImage(
                                imageUrl: after,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: context.h(260),
                                placeholder: (context, url) =>
                                    Container(color: CustomColors.softGrey),
                                errorWidget: (context, url, error) =>
                                    Container(color: CustomColors.softGrey),
                              ),
                            ),
                            Positioned(
                              top: context.h(10),
                              left: context.w(10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(8),
                                  vertical: context.h(3),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(context.r(6)),
                                ),
                                child: Text(
                                  'BEFORE',
                                  style: context.fonts.white10w700,
                                ),
                              ),
                            ),
                            Positioned(
                              top: context.h(10),
                              right: context.w(10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(8),
                                  vertical: context.h(3),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(context.r(6)),
                                ),
                                child: Text(
                                  'AFTER',
                                  style: context.fonts.white10w700,
                                ),
                              ),
                            ),
                          ],
                        )
                      : CachedNetworkImage(
                          imageUrl: before ?? after ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: context.h(260),
                          placeholder: (context, url) =>
                              Container(color: CustomColors.softGrey),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
