import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/responses/admin_treatment_response.dart';
import '../models/responses/area_list_response.dart';
import '../utils/theme.dart';
import '../view_models/area_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/dialog_box/standard_dialog.dart';
import '../widgets/number_paginator.dart';

class AddTreatmentScreen extends ConsumerStatefulWidget {
  const AddTreatmentScreen({super.key});

  static const String routeName = '/clinic-add-treatment';

  @override
  ConsumerState<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends ConsumerState<AddTreatmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  // treatmentId -> (areaId -> AreaModel)
  final Map<int, Map<int, AreaModel>> _selectedTemplateAreas = {};

  // Accordion controllers, keyed by treatment id so expand state survives rebuilds.
  final Map<int, ExpansionTileController> _tileControllers = {};

  List<AdminTreatment> _treatments = [];
  bool _loadingTemplates = false;
  String? _templatesError;

  int? _expandedTreatmentId;
  int? _loadingAreasForId;

  int _currentPage = 1;
  final int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _fetchTemplates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _fetchTemplates({String? search}) async {
    setState(() {
      _loadingTemplates = true;
      _templatesError = null;
    });
    try {
      final result = await ref
          .read(treatmentViewModelProvider.notifier)
          .getAdminTreatments(search);
      setState(() {
        _treatments = result;
        _currentPage = 1;
        _loadingTemplates = false;
      });
    } catch (e) {
      setState(() {
        _templatesError = e.toString().replaceAll('Exception:', '').trim();
        _loadingTemplates = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _fetchTemplates(search: query.isEmpty ? null : query);
    });
    setState(() {}); // refresh clear button
  }

Future<void> _onTileExpanded(AdminTreatment template) async {
  // Collapse whatever else is open (accordion behavior).
  if (_expandedTreatmentId != null && _expandedTreatmentId != template.id) {
    _tileControllers[_expandedTreatmentId]?.collapse();
  }

  setState(() {
    _expandedTreatmentId = template.id;
    _loadingAreasForId = template.id;
  });

  try {
    await ref
        .read(areaViewModelProvider.notifier)
        .fetchAreas(treatmentId: template.id, showLoading: false);
  } finally {
    if (mounted) {
      setState(() => _loadingAreasForId = null);
    }
  }
}
  void _toggleAreaSelection(int templateId, AreaModel area) {
    setState(() {
      final areas = _selectedTemplateAreas.putIfAbsent(templateId, () => {});
      if (areas.containsKey(area.id)) {
        areas.remove(area.id);
        if (areas.isEmpty) _selectedTemplateAreas.remove(templateId);
      } else {
        areas[area.id] = area;
      }
    });
  }

  void _clearTreatment(int templateId) {
    setState(() {
      _selectedTemplateAreas.remove(templateId);
    });
  }

  Widget _buildTreatmentTile(BuildContext context, AdminTreatment template) {
    final selectedAreas = _selectedTemplateAreas[template.id] ?? {};
    final isAnyAreaSelected = selectedAreas.isNotEmpty;
    final isExpanded = _expandedTreatmentId == template.id;
    final isLoadingAreas = _loadingAreasForId == template.id;

    final controller = _tileControllers.putIfAbsent(
      template.id,
      () => ExpansionTileController(),
    );

    return BorderdContainerWidget(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.zero,
      borderRadius: 12,
      borderColor: isAnyAreaSelected ? CustomColors.purple : CustomColors.border,
      borderWidth: isAnyAreaSelected ? 1.5 : 1.0,
      backgroundColor: CustomColors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey(template.id),
          controller: controller,
          tilePadding: context.appEdgeInsets(horizontal: 12, vertical: 4),
          childrenPadding: context.appEdgeInsets(horizontal: 12, bottom: 12),
          onExpansionChanged: (expanded) {
            if (expanded) _onTileExpanded(template);
          },
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isAnyAreaSelected
                  ? CustomColors.purple.withValues(alpha: 0.1)
                  : CustomColors.whiteGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.spa_outlined,
              color: isAnyAreaSelected ? CustomColors.purple : CustomColors.grey,
              size: 18,
            ),
          ),
          title: Text(
            template.name,
            style: isAnyAreaSelected
                ? context.fonts.purple13w700
                : context.fonts.black13w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            isAnyAreaSelected
                ? '${selectedAreas.length} Areas Selected'
                : template.shortDescription,
            style: context.fonts.grey11w400,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          children: [
            const Divider(height: 1, color: CustomColors.border),
            context.verticalSpace(12),
            Row(
              children: [
                const Icon(Icons.layers_outlined, size: 12, color: CustomColors.purple),
                context.horizontalSpace(6),
                Text('Select Target Areas:', style: context.fonts.black11w600),
              ],
            ),
            context.verticalSpace(8),
            if (isLoadingAreas)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (isExpanded)
              Consumer(
                builder: (context, ref, _) {
                  final areaState = ref.watch(areaViewModelProvider);
                  if (areaState.areas.isEmpty) {
                    return Text(
                      'No areas available for this treatment.',
                      style: context.fonts.grey11w400,
                    );
                  }
                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: areaState.areas.map((area) {
                      final isSelected = selectedAreas.containsKey(area.id);
                      return FilterChip(
                        label: Text(area.name),
                        selected: isSelected,
                        onSelected: (_) => _toggleAreaSelection(template.id, area),
                        checkmarkColor: Colors.white,
                        selectedColor: CustomColors.purple,
                        backgroundColor: CustomColors.whiteGrey,
                        labelStyle: isSelected
                            ? context.fonts.white10w700.copyWith(fontSize: 9)
                            : context.fonts.black10w600.copyWith(fontSize: 9),
                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(BuildContext context) {
    final int totalPagesCount = (_treatments.length / _pageSize).ceil();
    if (totalPagesCount <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: NumberPaginator(
          totalPages: totalPagesCount,
          currentPage: _currentPage - 1,
          onPageChanged: (pageIndex) {
            setState(() {
              _currentPage = pageIndex + 1;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = (_currentPage - 1) * _pageSize;
    final int endIndex =
        startIndex + _pageSize > _treatments.length ? _treatments.length : startIndex + _pageSize;

    final List<AdminTreatment> paginatedTemplates =
        _treatments.isEmpty ? [] : _treatments.sublist(startIndex, endIndex);
    final bool isWideScreen = context.screenWidth > 700;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Add Clinic Treatments', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Panel & Selection Display
          Padding(
            padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
            child: BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 16),
              backgroundColor: CustomColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CustomColors.purple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: CustomColors.purple,
                            ),
                          ),
                          context.horizontalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Search Platform Templates', style: context.fonts.black16w600),
                              Text(
                                'Choose templates and target areas to import.',
                                style: context.fonts.grey12w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_selectedTemplateAreas.isNotEmpty)
                        CustomPrimaryButton(
                          onTap: _showConfirmationDialog,
                          label: 'Import ${_selectedTemplateAreas.length} Treatments',
                          width: context.w(200),
                          height: context.h(40),
                          icon: Icons.download_for_offline_outlined,
                        ),
                    ],
                  ),
                  context.verticalSpace(16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search templates by name, keyword...',
                      hintStyle: context.fonts.grey14w400,
                      prefixIcon: const Icon(Icons.search, color: CustomColors.grey),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: CustomColors.grey),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: context.appBorderRadius(all: 12),
                        borderSide: const BorderSide(color: CustomColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: context.appBorderRadius(all: 12),
                        borderSide: const BorderSide(color: CustomColors.purple, width: 2),
                      ),
                      filled: true,
                      fillColor: CustomColors.whiteGrey,
                      contentPadding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  if (_selectedTemplateAreas.isNotEmpty) ...[
                    context.verticalSpace(16),
                    const Divider(color: CustomColors.border, height: 1),
                    context.verticalSpace(12),
                    Row(
                      children: [
                        Text(
                          'Batch Configuration (${_selectedTemplateAreas.length}):',
                          style: context.fonts.black12w600,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => setState(() => _selectedTemplateAreas.clear()),
                          child: Text(
                            'Clear All',
                            style: context.fonts.purple12w700.copyWith(color: CustomColors.red),
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Container(
                      constraints: BoxConstraints(maxHeight: context.h(100)),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedTemplateAreas.entries.map((entry) {
                            final template = _treatments.firstWhere((t) => t.id == entry.key);
                            return Chip(
                              backgroundColor: CustomColors.purple.withValues(alpha: 0.1),
                              side: BorderSide(color: CustomColors.purple.withValues(alpha: 0.2)),
                              label: Text(
                                '${template.name} (${entry.value.length})',
                                style: context.fonts.purple11w600,
                              ),
                              onDeleted: () => _clearTreatment(template.id),
                              deleteIcon: const Icon(Icons.close, size: 14, color: CustomColors.purple),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Main List of Templates
          Expanded(
            child: _loadingTemplates
                ? const Center(child: CircularProgressIndicator())
                : _templatesError != null
                    ? Center(
                        child: Text(
                          _templatesError!,
                          style: context.fonts.grey14w400,
                        ),
                      )
                    : _treatments.isEmpty
                        ? Center(
                            child: Text(
                              'No matching treatment templates found.',
                              style: context.fonts.grey14w400,
                            ),
                          )
                        : ListView.builder(
                            padding: context.appEdgeInsets(horizontal: 24, vertical: 8),
                            itemCount:
                                (paginatedTemplates.length / (isWideScreen ? 2 : 1)).ceil() + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  (paginatedTemplates.length / (isWideScreen ? 2 : 1)).ceil()) {
                                return _buildPaginationFooter(context);
                              }

                              if (isWideScreen) {
                                final int firstIdx = index * 2;
                                final int secondIdx = firstIdx + 1;
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildTreatmentTile(context, paginatedTemplates[firstIdx]),
                                    ),
                                    context.horizontalSpace(16),
                                    Expanded(
                                      child: secondIdx < paginatedTemplates.length
                                          ? _buildTreatmentTile(context, paginatedTemplates[secondIdx])
                                          : const SizedBox(),
                                    ),
                                  ],
                                );
                              } else {
                                return _buildTreatmentTile(context, paginatedTemplates[index]);
                              }
                            },
                          ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return StandardDialog(
          title: "Confirm Configuration",
          showCloseButton: false,
          width: 500.w,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: const BoxDecoration(color: CustomColors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 40, color: Colors.white),
              ),
              context.verticalSpace(24),
              Text(
                "You are importing ${_selectedTemplateAreas.length} treatments with custom area configurations. Continue?",
                style: context.fonts.grey14w400,
                textAlign: TextAlign.center,
              ),
              context.verticalSpace(16),
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CustomColors.border),
                ),
                constraints: BoxConstraints(maxHeight: context.h(250)),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _selectedTemplateAreas.length,
                  separatorBuilder: (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final entry = _selectedTemplateAreas.entries.elementAt(index);
                    final template = _treatments.firstWhere((t) => t.id == entry.key);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(template.name, style: context.fonts.black12w600),
                        context.verticalSpace(4),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: entry.value.values
                              .map((area) => Text("• ${area.name}", style: context.fonts.grey10w400))
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            CustomOutlinedButton(onTap: () => Navigator.of(ctx).pop(), label: "Cancel", width: context.w(100)),
            CustomPrimaryButton(
              onTap: () {
                Navigator.of(ctx).pop();
                context.pop();
              },
              label: "Confirm Import",
              width: context.w(160),
            ),
          ],
        );
      },
    );
  }
}