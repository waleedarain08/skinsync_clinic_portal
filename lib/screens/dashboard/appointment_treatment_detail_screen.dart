import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/string_utils.dart';
import '../../models/responses/appointment_treatment_detail_response.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_treatment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';

class AppointmentTreatmentDetailScreen extends ConsumerStatefulWidget {
  final int treatmentId;
  const AppointmentTreatmentDetailScreen({
    super.key,
    required this.treatmentId,
  });

  static const String routeName = '/appointment-treatment-detail';

  @override
  ConsumerState<AppointmentTreatmentDetailScreen> createState() =>
      _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState
    extends ConsumerState<AppointmentTreatmentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(
      () => ref
          .read(appointmentTreatmentProvider.notifier)
          .getTreatmentDetail(widget.treatmentId),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentTreatmentProvider);
    final detail = state.detail;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          detail?.treatmentName?.capitalize ?? 'Treatment Details',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Current Session'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: state.loading
          ? const Center(child: AppLoader())
          : detail == null
          ? const Center(child: Text('No details found'))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCurrentSessionTab(context, detail),
                _buildHistoryTab(context, detail),
              ],
            ),
    );
  }

  Widget _buildCurrentSessionTab(
    BuildContext context,
    AppointmentTreatmentDetailData detail,
  ) {
    final session = detail.currentSession;
    if (session == null) return const Center(child: Text('No ongoing session'));

    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSessionHeader(context, detail, session),
          context.verticalSpace(24),
          _buildConsentCard(context, session),
          context.verticalSpace(24),
          _buildProtocolsCard(context, session),
        ],
      ),
    );
  }

  Widget _buildSessionHeader(
    BuildContext context,
    AppointmentTreatmentDetailData detail,
    CurrentSession session,
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
              Icons.medical_services_outlined,
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
                  'Session #${session.sessionNumber}',
                  style: context.fonts.black26w700,
                ),
                context.verticalSpace(4),
                Text(
                  'Area: ${detail.areaName?.capitalize ?? "N/A"}',
                  style: context.fonts.grey14w400,
                ),
                context.verticalSpace(8),
                _statusBadge(context, detail.status ?? 'Pending'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCard(BuildContext context, CurrentSession session) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Consent Form', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
              context.horizontalSpace(16),
              Expanded(
                child: Text(
                  'Treatment_Consent_Form.pdf',
                  style: context.fonts.black14w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // View PDF Logic
                },
                child: const Text('VIEW PDF'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolsCard(BuildContext context, CurrentSession session) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clinical Protocols', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          if (session.protocols != null)
            ...session.protocols!.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: CustomColors.green,
                      size: 20,
                    ),
                    context.horizontalSpace(12),
                    Expanded(child: Text(p, style: context.fonts.black14w400)),
                  ],
                ),
              ),
            ),
          if (session.instructions != null) ...[
            const Divider(color: CustomColors.border, height: 32),
            Text('Instructions', style: context.fonts.grey12w600),
            context.verticalSpace(8),
            Text(session.instructions!, style: context.fonts.black14w400),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryTab(
    BuildContext context,
    AppointmentTreatmentDetailData detail,
  ) {
    final history = detail.history;
    if (history == null || history.isEmpty)
      return const Center(child: Text('No history found'));

    return ListView.builder(
      padding: context.appEdgeInsets(all: 24),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final historyDetails = ref
            .watch(appointmentTreatmentProvider)
            .historyDetails[item.id];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: BorderdContainerWidget(
            padding: EdgeInsets.zero,
            backgroundColor: CustomColors.white,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (expanded) {
                  if (expanded && historyDetails == null) {
                    ref
                        .read(appointmentTreatmentProvider.notifier)
                        .fetchHistoryDetail(item.id!);
                  }
                },
                leading: _historyTypeIcon(item.type ?? ''),
                title: Text(
                  (item.type ?? 'Event').capitalize,
                  style: context.fonts.black16w600,
                ),
                subtitle: Text(
                  item.date ?? 'N/A',
                  style: context.fonts.grey12w400,
                ),
                children: [
                  if (historyDetails == null)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: AppLoader()),
                    )
                  else
                    Padding(
                      padding: context.appEdgeInsets(
                        horizontal: 24,
                        bottom: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(color: CustomColors.border, height: 1),
                          context.verticalSpace(16),
                          ...historyDetails.entries
                              .where(
                                (e) => !['id', 'type', 'date'].contains(e.key),
                              )
                              .map((e) {
                                return _buildDetailRow(context, e.key, e.value);
                              }),
                        ],
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

  Widget _buildDetailRow(BuildContext context, String key, dynamic value) {
    if (value is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key.replaceAll('_', ' ').capitalize,
            style: context.fonts.grey11w600ls12,
          ),
          context.verticalSpace(4),
          ...value.entries.map(
            (inner) => Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                '${inner.key.toString().toUpperCase()}: ${inner.value}',
                style: context.fonts.black13w500,
              ),
            ),
          ),
          context.verticalSpace(12),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            key.replaceAll('_', ' ').capitalize,
            style: context.fonts.grey11w600ls12,
          ),
          context.verticalSpace(4),
          Text(value.toString(), style: context.fonts.black14w500),
        ],
      ),
    );
  }

  Widget _historyTypeIcon(String type) {
    IconData icon;
    Color color;
    switch (type.toLowerCase()) {
      case 'consultation':
        icon = Icons.chat_outlined;
        color = Colors.blue;
        break;
      case 'session':
        icon = Icons.medical_services_outlined;
        color = CustomColors.purple;
        break;
      case 'follow-up':
        icon = Icons.event_repeat_outlined;
        color = CustomColors.green;
        break;
      default:
        icon = Icons.event;
        color = CustomColors.grey;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _statusBadge(BuildContext context, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: CustomColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: context.fonts.grey10w700.copyWith(color: CustomColors.green),
      ),
    );
  }
}
