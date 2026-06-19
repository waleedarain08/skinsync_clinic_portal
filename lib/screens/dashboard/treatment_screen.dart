import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/theme.dart';
import '../../view_models/treatment_view_model.dart';
import '../../models/treatment_model.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/number_paginator.dart';
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
  String _searchQuery = '';
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentViewModelProvider.notifier).getTreatments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(treatmentViewModelProvider);
    final viewModel = ref.read(treatmentViewModelProvider.notifier);

    // Filter treatments dynamically based on search controller query
    final filteredTreatments = state.treatments.where((t) {
      final query = _searchQuery.toLowerCase();
      return query.isEmpty ||
          (t.name?.toLowerCase().contains(query) ?? false) ||
          (t.description?.toLowerCase().contains(query) ?? false);
    }).toList();

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildQuickInsights(state),
            context.verticalSpace(32),
            _buildFilters(context),
            context.verticalSpace(24),
            _buildTreatmentTable(filteredTreatments, viewModel),
            context.verticalSpace(24),
            _buildFooterPaginator(),
          ],
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

  Widget _buildFilters(BuildContext context) {
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
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
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
                  _statusBadgeCell(),
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
            child: const Center(
              child: Icon(Icons.vaccines_outlined, color: CustomColors.purple),
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

  Widget _statusBadgeCell() {
    Color badgeColor = CustomColors.green;
    String label = 'Active';

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
            onPressed: () {
              context.push(TreatmentDetailScreen.routeName, extra: t);
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
                    setState(() {
                      _searchQuery = '';
                    });
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

  Widget _buildFooterPaginator() {
    return Center(
      child: NumberPaginator(
        totalPages: 1,
        currentPage: _currentPage,
        onPageChanged: (pageIndex) {
          setState(() {
            _currentPage = pageIndex;
          });
        },
      ),
    );
  }
}
