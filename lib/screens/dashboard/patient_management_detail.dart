import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/string_utils.dart';
import '../../models/responses/patient_detail_response.dart';
import '../../utils/theme.dart';
import '../../view_models/patient_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/patient_simulations_widget.dart';
import '../../widgets/patient_treatment_history_widget.dart';

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
    extends ConsumerState<PatientManagementDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, patient),
            context.verticalSpace(24),
            _buildInfoSection(context, patient),
            context.verticalSpace(24),
            BorderdContainerWidget(
              padding: EdgeInsets.zero,
              backgroundColor: CustomColors.white,
              borderRadius: context.r(12),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Treatment History'),
                  Tab(text: 'Simulations'),
                ],
              ),
            ),
            context.verticalSpace(16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  SingleChildScrollView(child: PatientTreatmentHistoryWidget()),
                  SingleChildScrollView(child: PatientSimulationsWidget()),
                ],
              ),
            ),
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
                Text(
                  p.patientName.capitalize,
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
          if (p.phoneNumber != '')
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
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: context.r(radius * 2),
              width: context.r(radius * 2),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => _buildDefaultAvatar(context, radius),
            )
          : _buildDefaultAvatar(context, radius),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, double radius) {
    return CircleAvatar(
      radius: context.r(radius),
      backgroundColor: CustomColors.softGrey,
      child: Icon(Icons.person, size: context.r(radius), color: CustomColors.grey),
    );
  }
}
