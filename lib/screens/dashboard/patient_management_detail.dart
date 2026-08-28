import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/responses/patient_detail_response.dart';
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
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref
  //         .read(patientProvider.notifier)
  //         .getPatientTreatmentRequests(initialCall: true, patientId: widget.patientId);
  //   });
  // }

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
           // context.verticalSpace(24),
           // _buildTreatmentRequestsSection(context, patientState),
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
                Text(p.patientName, style: context.fonts.level2Heading),
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
          Text('Contact Information', style: context.fonts.subHeading),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.email_outlined, 'Email Address', p.email),
          if(p.phoneNumber != '')
          _infoRow(context, Icons.phone_outlined, 'Phone Number', p.phoneNumber),
        ],
      ),
    );
  }

  // Widget _buildTreatmentRequestsSection(
  //   BuildContext context,
  //   PatientState state,
  // ) {
  //   return BorderdContainerWidget(
  //     padding: context.appEdgeInsets(all: 24),
  //     backgroundColor: CustomColors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Treatment Requests', style: context.fonts.subHeading),
  //             if (state.treatmentLoading)
  //               const SizedBox(
  //                 width: 16,
  //                 height: 16,
  //                 child: CircularProgressIndicator(strokeWidth: 2),
  //               ),
  //           ],
  //         ),
  //         const Divider(color: CustomColors.border, height: 32),
  //         if (state.treatmentRequests.isEmpty && !state.treatmentLoading)
  //           Padding(
  //             padding: context.appEdgeInsets(vertical: 20),
  //             child: Center(
  //               child: Text(
  //                 'No treatment requests found',
  //                 style: context.fonts.grey14w400,
  //               ),
  //             ),
  //           )
  //         else
  //           ListView.builder(
  //             shrinkWrap: true,
  //             physics: const NeverScrollableScrollPhysics(),
  //             itemCount: state.treatmentRequests.length,
  //             itemBuilder: (context, index) {
  //               final request = state.treatmentRequests[index];
  //               return SimulationTreatmentRequestCard(
  //                 request: request,
  //                 onTreatmentTap: (treatmentId) async {
  //                  await ref
  //                     .read(treatmentViewModelProvider.notifier)
  //                     .fetchTreatmentDetail(treatmentId);
  //                 if (mounted) {
  //                   await context.push(TreatmentDetailScreen.routeName);
  //                 }
  //                 },
  //               );
  //             },
  //           ),
  //         if (state.treatmentTotalPage != null &&
  //             state.treatmentTotalPage! > 1) ...[
  //           context.verticalSpace(24),
  //           _buildPagination(context, state),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPagination(BuildContext context, PatientState state) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       IconButton(
  //         onPressed: state.treatmentPage > 1
  //             ? () => ref
  //                   .read(patientProvider.notifier)
  //                   .setTreatmentPageNumber(state.treatmentPage - 1)
  //             : null,
  //         icon: const Icon(Icons.arrow_back_ios, size: 16),
  //       ),
  //       Text(
  //         'Page ${state.treatmentPage} of ${state.treatmentTotalPage}',
  //         style: context.fonts.black14w600,
  //       ),
  //       IconButton(
  //         onPressed: state.treatmentPage < (state.treatmentTotalPage ?? 1)
  //             ? () => ref
  //                   .read(patientProvider.notifier)
  //                   .setTreatmentPageNumber(state.treatmentPage + 1)
  //             : null,
  //         icon: const Icon(Icons.arrow_forward_ios, size: 16),
  //       ),
  //     ],
  //   );
  // }

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