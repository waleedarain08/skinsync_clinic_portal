import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../utils/theme.dart';
import '../../view_models/treatment_view_model.dart';
import '../../models/treatment_model.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/number_paginator.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/dialog_box/edit_treatment_dailogbox.dart';
import 'treatment_detail_screen.dart';

class TreatmentScreen extends ConsumerStatefulWidget {
  const TreatmentScreen({super.key});

  static const String routeName = '/treatment';

  @override
  ConsumerState<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends ConsumerState<TreatmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentViewModelProvider.notifier).getTreatments(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(treatmentViewModelProvider.notifier).getTreatments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);

    return GradientScaffold(
      body: RefreshIndicator(
        color: CustomColors.purple,
        onRefresh: () async {
          await ref.read(treatmentViewModelProvider.notifier).getTreatments(isRefresh: true);
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              context.verticalSpace(32),
              _buildQuickInsights(state),
              context.verticalSpace(32),
              _buildFilters(context, state),
              context.verticalSpace(24),
              if (state.loading && state.treatments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(color: CustomColors.purple),
                  ),
                )
              else if (state.error != null && state.treatments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: CustomColors.red, size: 48),
                        context.verticalSpace(16),
                        Text(
                          state.error!,
                          style: context.fonts.black16w600,
                          textAlign: TextAlign.center,
                        ),
                        context.verticalSpace(16),
                        CustomOutlinedButton(
                          onTap: () => viewModel.getTreatments(isRefresh: true),
                          label: "Retry",
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                _buildTreatmentTable(state.treatments, viewModel),
                if (state.loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(color: CustomColors.purple),
                    ),
                  ),
                context.verticalSpace(24),
                _buildFooterPaginator(state),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Treatment Library', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Manage clinic medical aesthetic procedures, pricing structures, and anatomical areas.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {
            context.push('/clinic-add-treatment');
          },
          icon: Icons.add_rounded,
          label: 'Add Treatment',
          width: context.w(180),
        ),
      ],
    );
  }

  Widget _buildQuickInsights(TreatmentState state) {
    final totalTreatments = state.treatments.length;
    final activeTreatments = state.treatments.length; // In-memory are all active
    final totalSubAreas = state.treatments.fold<int>(0, (sum, t) => sum + (t.sideAreas?.length ?? 0));
    final anatomicalCount = state.treatments.where((t) => t.isArea == true).length;

    return Row(
      children: [
        _buildStatCard(
          'Total Treatments',
          '$totalTreatments',
          Icons.layers_outlined,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Active Treatments',
          '$activeTreatments',
          Icons.check_circle_outline_rounded,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Total Sub-Areas',
          '$totalSubAreas',
          Icons.location_on_outlined,
          CustomColors.blue,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Anatomical Types',
          '$anatomicalCount',
          Icons.auto_awesome_outlined,
          CustomColors.amber,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(20)),
            ),
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: context.fonts.black18w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  context.verticalSpace(2),
                  Text(
                    title,
                    style: context.fonts.grey11w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, TreatmentState state) {
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              style: context.fonts.black14w400,
              decoration: AppDecorations.input(
                context,
                hint: "Search treatments by keyword or name...",
                prefixIcon: const Icon(Icons.search_rounded, color: CustomColors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: CustomColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          viewModel.onSearchChanged('');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {});
                viewModel.onSearchChanged(val);
              },
            ),
          ),
          context.horizontalSpace(16),
          SizedBox(
            width: context.w(180),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text("All Status", style: context.fonts.grey14w400),
                value: state.status.isEmpty ? null : state.status,
                items: ["", "active", "inactive", "draft"].map((val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(
                      val.isEmpty ? "All Status" : val.toUpperCase(),
                      style: context.fonts.black14w400,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    viewModel.onStatusChanged(val);
                  }
                },
                buttonStyleData: ButtonStyleData(
                  height: context.h(48),
                  padding: context.appEdgeInsets(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.appBorderRadius(all: 8),
                    border: Border.all(color: CustomColors.border),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.appBorderRadius(all: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentTable(
    List<TreatmentModel> treatments,
    TreamententViewModel viewModel,
  ) {
    if (treatments.isEmpty) {
      return _buildEmptyState(context);
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Treatment Name / Category
            1: FlexColumnWidth(2), // Price
            2: FlexColumnWidth(2.5), // Anatomical Sub-areas
            3: FlexColumnWidth(2), // Status
            4: FlexColumnWidth(2), // Actions
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _tableHeaderCell('TREATMENT NAME'),
                _tableHeaderCell('BASE PRICE'),
                _tableHeaderCell('ANATOMICAL AREAS'),
                _tableHeaderCell('STATUS'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...treatments.map((t) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _treatmentNameCell(t),
                  _tableTextCell(
                    'AED ${t.price ?? 0}',
                    style: context.fonts.black14w600,
                  ),
                  _tableTextCell(
                    t.isArea == true
                        ? '${t.sideAreas?.length ?? 0} Sub-areas'
                        : 'Single Standard Area',
                    style: context.fonts.grey14w400,
                  ),
                  _statusBadgeCell(t.status),
                  _actionsCell(t, viewModel),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String label) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }

  Widget _treatmentNameCell(TreatmentModel treatment) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: context.w(48),
            height: context.w(48),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 8),
            ),
            child: ClipRRect(
              borderRadius: context.appBorderRadius(all: 8),
              child: (treatment.image != null && treatment.image!.isNotEmpty)
                  ? AppNetworkImage(imageUrl: treatment.image!, fit: BoxFit.cover)
                  : (treatment.icon != null && treatment.icon!.isNotEmpty)
                      ? AppNetworkImage(imageUrl: treatment.icon!, fit: BoxFit.cover)
                      : const Center(
                          child: Icon(Icons.vaccines_outlined, color: CustomColors.purple),
                        ),
            ),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  treatment.name ?? 'N/A',
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(2),
                if (treatment.globalSku != null && treatment.globalSku!.isNotEmpty)
                  Text(
                    'SKU: ${treatment.globalSku}',
                    style: context.fonts.grey11w400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    treatment.isArea == true ? 'Anatomical Structure' : 'Standard Procedure',
                    style: context.fonts.purple12w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableTextCell(String text, {required TextStyle style}) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _statusBadgeCell(String? status) {
    final s = (status ?? 'Active').toLowerCase();
    Color badgeColor = CustomColors.green;
    if (s == 'draft') {
      badgeColor = Colors.orange;
    } else if (s == 'inactive') {
      badgeColor = CustomColors.grey;
    }
    String label = status ?? 'Active';

    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: context.appEdgeInsets(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: context.appBorderRadius(all: 20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: context.fonts.grey12w600.copyWith(
                color: badgeColor,
                fontSize: context.sp(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsCell(TreatmentModel t, TreamententViewModel viewModel) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Details',
            icon: const Icon(
              Icons.visibility_outlined,
              color: CustomColors.grey,
              size: 20,
            ),
            onPressed: () async {
                if (t.id != null) {
                try {
                  await ref
                      .read(treatmentViewModelProvider.notifier)
                      .fetchTreatmentDetail(t.id!);
                  if (mounted) {
                    await context.push(TreatmentDetailScreen.routeName);
                  }
                } catch (e) {
                  // Error handled gracefully by runSafely wrapper
                }
              }
             // context.push(TreatmentDetailScreen.routeName, );
            },
          ),
          IconButton(
            tooltip: 'Edit Treatment',
            icon: const Icon(
              Icons.edit_outlined,
              color: CustomColors.purple,
              size: 20,
            ),
            onPressed: () {
              viewModel.setTreatment(t.id!);
              showDialog(
                context: context,
                builder: (context) => const EditTreatmentDialog(),
              );
            },
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: CustomColors.red,
              size: 20,
            ),
            onPressed: () {
              viewModel.deleteTreatment(treatmentId: t.id!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final viewModel = ref.read(treatmentViewModelProvider.notifier);
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: CustomColors.grey,
              ),
            ),
            context.verticalSpace(24),
            Text(
              'No treatments match your search refinement',
              style: context.fonts.black18w600,
            ),
            context.verticalSpace(8),
            Text(
              'Try clearing your search keyword, resetting the filter, or add a brand new treatment profile.',
              style: context.fonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            context.verticalSpace(24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOutlinedButton(
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                    viewModel.onSearchChanged('');
                  },
                  label: 'Clear Search Filter',
                ),
                context.horizontalSpace(16),
                CustomPrimaryButton(
                  onTap: () {
                    context.push('/clinic-add-treatment');
                  },
                  icon: Icons.add_rounded,
                  label: 'Add Treatment',
                  width: context.w(180),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterPaginator(TreatmentState state) {
    if (state.totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing Results ${((state.page - 2) * 10 + 1).clamp(1, double.infinity).toInt()}-${((state.page - 2) * 10 + state.treatments.length).clamp(0, double.infinity).toInt()}',
          style: context.fonts.grey14w400,
        ),
        NumberPaginator(
          totalPages: state.totalPages,
          currentPage: (state.page - 2).clamp(0, state.totalPages - 1),
          onPageChanged: (pageIndex) {
            ref.read(treatmentViewModelProvider.notifier).setPage(pageIndex + 1);
          },
        ),
      ],
    );
  }
}
