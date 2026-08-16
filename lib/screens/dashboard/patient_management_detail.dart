import 'package:before_after/before_after.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/responses/patient_detail_response.dart';
import '../../models/responses/patient_treatment_request_response.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';
import '../../view_models/patient_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';
import 'patient_management.dart';

class PatientManagementDetailScreen extends ConsumerStatefulWidget {
  static const String path = 'details';
  static const String routeName =
      '${PatientManagementScreen.routeName}/details';
  final int? patientId;
  const PatientManagementDetailScreen({super.key, this.patientId});

  @override
  ConsumerState<PatientManagementDetailScreen> createState() =>
      _PatientManagementDetailScreenState();
}

class _PatientManagementDetailScreenState
    extends ConsumerState<PatientManagementDetailScreen> {
  final Map<String, double> _sliderValues = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(patientProvider.notifier)
          .getPatientTreatmentRequests(initialCall: true, patientId: widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientState = ref.watch(patientProvider);
    final patient = patientState.patientDetail;
    if (patient == null) {
      return const GradientScaffold(body: Center(child: AppLoader()));
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Patient Details', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, patient),
            context.verticalSpace(24),
            _buildInfoSection(context, patient),
            context.verticalSpace(24),
            _buildTreatmentRequestsSection(context, patientState),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, PatientDetailData p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Row(
        children: [
          _buildAvatar(context, p.image, 40),
          context.horizontalSpace(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.patientName, style: context.fonts.black26w700),
                context.verticalSpace(4),
                Container(
                  padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  child: Text(
                    'Active Patient',
                    style: context.fonts.purple12w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, PatientDetailData p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.email_outlined, 'Email Address', p.email),
          _infoRow(
            context,
            Icons.phone_outlined,
            'Phone Number',
            p.phoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentRequestsSection(
    BuildContext context,
    PatientState state,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Treatment Requests', style: context.fonts.black18w600),
              if (state.treatmentLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          if (state.treatmentRequests.isEmpty && !state.treatmentLoading)
            Padding(
              padding: context.appEdgeInsets(vertical: 20),
              child: Center(
                child: Text(
                  'No treatment requests found',
                  style: context.fonts.grey14w400,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.treatmentRequests.length,
              separatorBuilder: (context, index) =>
                  const Divider(color: CustomColors.border, height: 32),
              itemBuilder: (context, index) {
                final request = state.treatmentRequests[index];
                return _buildTreatmentRequestItem(context, request);
              },
            ),
          if (state.treatmentTotalPage != null &&
              state.treatmentTotalPage! > 1) ...[
            context.verticalSpace(24),
            _buildPagination(context, state),
          ],
        ],
      ),
    );
  }

  Widget _buildTreatmentRequestItem(
    BuildContext context,
    PatientTreatmentRequestData request,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.assignment_outlined,
              size: 22,
              color: CustomColors.purple,
            ),
            context.horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(request.name, style: context.fonts.black18w600),
                  Text(
                    'Request Date: ${request.createdAt?.substring(0, 10) ?? ""}',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
          ],
        ),
        context.verticalSpace(16),
        _buildImageComparison(context, request),
        context.verticalSpace(16),
        ...request.treatments.map(
          (treatment) => _buildTreatmentDetail(context, treatment),
        ),
      ],
    );
  }

  Widget _buildImageComparison(
    BuildContext context,
    PatientTreatmentRequestData request,
  ) {
    final images = [
      if (request.frontImageBefore != null || request.frontImageAfter != null)
        ('Front View', request.frontImageBefore, request.frontImageAfter),
      if (request.leftImageBefore != null || request.leftImageAfter != null)
        ('Left Profile', request.leftImageBefore, request.leftImageAfter),
      if (request.rightImageBefore != null || request.rightImageAfter != null)
        ('Right Profile', request.rightImageBefore, request.rightImageAfter),
    ];

    if (images.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Before & After Photos', style: context.fonts.black14w600),
        context.verticalSpace(12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(images.length, (index) {
              final (label, before, after) = images[index];
              final isLast = index == images.length - 1;

              Widget item;
              if (before != null && after != null) {
                final key = '${request.id}_$label';
                _sliderValues.putIfAbsent(key, () => 0.5);

                item = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.fonts.grey12w600),
                    context.verticalSpace(8),
                    Container(
                      height: context.h(326),
                      width: context.w(300),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(20)),
                        border: Border.all(color: CustomColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          BeforeAfter(
                            value: _sliderValues[key]!,
                            onValueChanged: (value) =>
                                setState(() => _sliderValues[key] = value),
                            before: _buildComparisonImageOnly(
                              context,
                              before,
                              'Before',
                            ),
                            after: _buildComparisonImageOnly(
                              context,
                              after,
                              'After',
                            ),
                            trackColor: Colors.white,
                            trackWidth: context.w(2),
                            thumbDecoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(PngAssets.customMarker),
                                fit: BoxFit.contain,
                              ),
                            ),
                            thumbWidth: context.w(32),
                            thumbHeight: context.w(32),
                          ),
                          Positioned(
                            top: context.h(12),
                            left: context.w(12),
                            child: _buildBadge(
                              "BEFORE",
                              Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          Positioned(
                            top: context.h(12),
                            right: context.w(12),
                            child: _buildBadge(
                              "AFTER",
                              Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                item = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.fonts.grey12w600),
                    context.verticalSpace(8),
                    SizedBox(
                      width: context.w(300),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildComparisonImage(
                              context,
                              before,
                              'Before',
                            ),
                          ),
                          context.horizontalSpace(8),
                          Expanded(
                            child: _buildComparisonImage(
                              context,
                              after,
                              'After',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : context.w(16)),
                child: item,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonImageOnly(
    BuildContext context,
    String? url,
    String label,
  ) {
    return url != null
        ? (url.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, size: 24),
                )
              : Image.asset(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 24),
                ))
        : Center(child: Text(label, style: context.fonts.grey12w400));
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(10),
        vertical: context.h(4),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.r(4)),
      ),
      child: Text(
        text,
        style: context.fonts.white12w700.copyWith(
          letterSpacing: 0.8,
          fontSize: context.sp(10),
        ),
      ),
    );
  }

  Widget _buildComparisonImage(
    BuildContext context,
    String? url,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: context.h(180),
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomColors.softGrey,
            borderRadius: BorderRadius.circular(context.r(12)),
            border: Border.all(color: CustomColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: url != null
                ? (url.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image, size: 24),
                        )
                      : Image.asset(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 24),
                        ))
                : Center(child: Text(label, style: context.fonts.grey12w400)),
          ),
        ),
        context.verticalSpace(4),
        Center(
          child: Text(
            label,
            style: context.fonts.black12w600.copyWith(
              color: label == 'Before' ? CustomColors.red : CustomColors.green,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentDetail(
    BuildContext context,
    PatientTreatmentData treatment,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(16)),
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.softGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.medical_services_outlined,
                size: 18,
                color: CustomColors.purple,
              ),
              context.horizontalSpace(8),
              Text(treatment.treatmentName, style: context.fonts.black16w600),
            ],
          ),
          const Divider(height: 24),
          ...treatment.areas.map(
            (area) => Padding(
              padding: EdgeInsets.only(bottom: context.h(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    area.areaName,
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.purple,
                    ),
                  ),
                  context.verticalSpace(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: area.materials
                        .map(
                          (m) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(context.r(6)),
                              border: Border.all(color: CustomColors.border),
                            ),
                            child: Text(
                              '${m.name} x ${m.selectedQuantity}',
                              style: context.fonts.black12w600,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(BuildContext context, PatientState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: state.treatmentPage > 1
              ? () => ref
                    .read(patientProvider.notifier)
                    .setTreatmentPageNumber(state.treatmentPage - 1)
              : null,
          icon: const Icon(Icons.arrow_back_ios, size: 16),
        ),
        Text(
          'Page ${state.treatmentPage} of ${state.treatmentTotalPage}',
          style: context.fonts.black14w600,
        ),
        IconButton(
          onPressed: state.treatmentPage < (state.treatmentTotalPage ?? 1)
              ? () => ref
                    .read(patientProvider.notifier)
                    .setTreatmentPageNumber(state.treatmentPage + 1)
              : null,
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ],
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomColors.purple),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.fonts.grey12w400),
                context.verticalSpace(4),
                Text(value, style: context.fonts.black14w600, softWrap: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? imageUrl, double radius) {
    return ClipOval(
      child: imageUrl != null && imageUrl.isNotEmpty
          ? (imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: context.r(radius * 2),
                    width: context.r(radius * 2),
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        _buildDefaultAvatar(context, radius),
                  )
                : Image.asset(
                    imageUrl,
                    height: context.r(radius * 2),
                    width: context.r(radius * 2),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultAvatar(context, radius),
                  ))
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
