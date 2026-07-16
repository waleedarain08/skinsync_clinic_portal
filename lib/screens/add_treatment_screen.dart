import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_primary_button.dart';

class AdminTreatmentTemplate {
  final int id;
  final String name;
  final String description;
  final List<String> availableAreas;

  AdminTreatmentTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.availableAreas,
  });
}

final List<AdminTreatmentTemplate> dummyAdminTemplates = [
  AdminTreatmentTemplate(
    id: 1,
    name: 'Botox Cosmetic Wrinkle Relaxation',
    description: 'Advanced neurotoxin treatment for dynamic lines.',
    availableAreas: ['Forehead', 'Glabella', 'Crow\'s Feet', 'Bunny Lines'],
  ),
  AdminTreatmentTemplate(
    id: 2,
    name: 'Dermal Fillers (Juvederm)',
    description: 'Hyaluronic acid fillers for volume restoration and contouring.',
    availableAreas: ['Lips', 'Cheeks', 'Nasolabial Folds', 'Jawline', 'Chin'],
  ),
  AdminTreatmentTemplate(
    id: 3,
    name: 'Chemical Peel (Glycolic Acid)',
    description: 'Medical-grade skin resurfacing and rejuvenation.',
    availableAreas: ['Full Face', 'Neck', 'Decolletage', 'Hands'],
  ),
  AdminTreatmentTemplate(
    id: 4,
    name: 'Microneedling (SkinPen)',
    description: 'Collagen induction therapy for scarring and texture.',
    availableAreas: ['Full Face', 'Neck', 'Scar Target Area'],
  ),
  AdminTreatmentTemplate(
    id: 5,
    name: 'Laser Hair Removal (Soprano Ice)',
    description: 'Pain-free diode laser hair removal for all skin types.',
    availableAreas: ['Full Face', 'Underarms', 'Full Arms', 'Full Legs', 'Back'],
  ),
  AdminTreatmentTemplate(
    id: 6,
    name: 'HydraFacial MD Rejuvenation',
    description: 'Patented 3-step treatment to cleanse, extract, and hydrate.',
    availableAreas: ['Full Face', 'Neck', 'Decolletage'],
  ),
  AdminTreatmentTemplate(
    id: 7,
    name: 'Platelet-Rich Plasma (PRP) Therapy',
    description: 'Autologous platelet gel therapy for tissue regeneration.',
    availableAreas: ['Full Face', 'Scalp', 'Scar Target Area'],
  ),
  AdminTreatmentTemplate(
    id: 8,
    name: 'Kybella Double Chin Treatment',
    description: 'Injectable deoxycholic acid to dissolve submental fat cells.',
    availableAreas: ['Submental Area', 'Jawline Contour'],
  ),
  AdminTreatmentTemplate(
    id: 9,
    name: 'IPL Photofacial (Intense Pulsed Light)',
    description: 'Targeted light therapy for pigmentation, sun damage, and redness.',
    availableAreas: ['Full Face', 'Neck', 'Hands', 'Chest'],
  ),
  AdminTreatmentTemplate(
    id: 10,
    name: 'CoolSculpting Body Contouring',
    description: 'Non-invasive cryolipolysis to freeze and eliminate stubborn fat.',
    availableAreas: ['Abdomen', 'Flanks', 'Thighs', 'Under Chin'],
  ),
  AdminTreatmentTemplate(
    id: 11,
    name: 'Thermage Skin Tightening',
    description: 'Radiofrequency energy to stimulate collagen production and tighten skin.',
    availableAreas: ['Full Face', 'Eyes', 'Neck', 'Abdomen'],
  ),
  AdminTreatmentTemplate(
    id: 12,
    name: 'Ultherapy Non-Surgical Lift',
    description: 'Micro-focused ultrasound to lift and tighten eyebrows, chin, and neck.',
    availableAreas: ['Full Face', 'Lower Face', 'Neck', 'Decolletage'],
  ),
];

class AddTreatmentScreen extends ConsumerStatefulWidget {
  const AddTreatmentScreen({super.key});

  static const String routeName = '/clinic-add-treatment';

  @override
  ConsumerState<AddTreatmentScreen> createState() => _ClinicAddTreatmentScreenState();
}

class _ClinicAddTreatmentScreenState extends ConsumerState<AddTreatmentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  AdminTreatmentTemplate? _selectedTemplate;
  final Set<String> _selectedAreas = {};

  List<AdminTreatmentTemplate> _filteredTemplates = [];
  final List<AdminTreatmentTemplate> _displayedTemplates = [];

  int _currentPage = 1;
  final int _pageSize = 5;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _filteredTemplates = List.from(dummyAdminTemplates);
    _loadInitialPage();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadInitialPage() {
    _currentPage = 1;
    _displayedTemplates.clear();
    final int endIndex = _filteredTemplates.length < _pageSize ? _filteredTemplates.length : _pageSize;
    _displayedTemplates.addAll(_filteredTemplates.sublist(0, endIndex));
    _hasMore = _displayedTemplates.length < _filteredTemplates.length;
    _isLoadingMore = false;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate API network latency
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final int nextStartIndex = _currentPage * _pageSize;
    final int remainingItems = _filteredTemplates.length - nextStartIndex;

    if (remainingItems > 0) {
      final int itemsToTake = remainingItems < _pageSize ? remainingItems : _pageSize;
      final int nextEndIndex = nextStartIndex + itemsToTake;

      setState(() {
        _displayedTemplates.addAll(_filteredTemplates.sublist(nextStartIndex, nextEndIndex));
        _currentPage++;
        _hasMore = _displayedTemplates.length < _filteredTemplates.length;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _hasMore = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredTemplates = dummyAdminTemplates.where((template) {
        final nameMatch = template.name.toLowerCase().contains(query.toLowerCase());
        final descMatch = template.description.toLowerCase().contains(query.toLowerCase());
        return nameMatch || descMatch;
      }).toList();

      _selectedTemplate = null;
      _selectedAreas.clear();
      _loadInitialPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.screenWidth > 1200;

    return Scaffold(
      appBar: AppBar(
      flexibleSpace: AppDecorations.appBarGradient,
      title: const Text('Add Treatment'),
      centerTitle: true,
    ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.w(isDesktop ? 700 : 850),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Panel Card wrapped in BorderdContainerWidget
              Padding(
                padding: context.appEdgeInsets(horizontal: 12, vertical: 16),
                child: BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 16),
                  backgroundColor: CustomColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Search Templates',
                                  style: context.fonts.black16w600,
                                ),
                                Text(
                                  'Find treatment templates registered by administrative doctors.',
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                            ),
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
                    ],
                  ),
                ),
              ),

              // Paginated Expansion Tiles List wrapped in BorderdContainerWidget
              Expanded(
                child: _displayedTemplates.isEmpty
                    ? Center(
                        child: Text(
                          'No treatment templates found.',
                          style: context.fonts.grey14w400,
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
                        itemCount: _displayedTemplates.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _displayedTemplates.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(CustomColors.purple),
                                  ),
                                ),
                              ),
                            );
                          }

                          final template = _displayedTemplates[index];
                          final bool isSelected = _selectedTemplate?.id == template.id;

                          return BorderdContainerWidget(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.zero,
                            borderRadius: 12,
                            borderColor: isSelected ? CustomColors.purple : CustomColors.border,
                            borderWidth: isSelected ? 2 : 1,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                key: PageStorageKey<int>(template.id),
                                initiallyExpanded: isSelected,
                                onExpansionChanged: (expanded) {
                                  setState(() {
                                    if (expanded) {
                                      _selectedTemplate = template;
                                      _selectedAreas.clear();
                                    } else {
                                      if (_selectedTemplate?.id == template.id) {
                                        _selectedTemplate = null;
                                        _selectedAreas.clear();
                                      }
                                    }
                                  });
                                },
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? CustomColors.purple.withValues(alpha: 0.1) : CustomColors.whiteGrey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.spa_outlined,
                                    color: isSelected ? CustomColors.purple : CustomColors.grey,
                                  ),
                                ),
                                title: Text(
                                  template.name,
                                  style: isSelected 
                                      ? context.fonts.purple16w600.copyWith(fontWeight: FontWeight.bold) 
                                      : context.fonts.black16w600,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    template.description,
                                    style: context.fonts.grey12w400,
                                  ),
                                ),
                                children: [
                                  const Divider(height: 1, color: CustomColors.border),
                                  Padding(
                                    padding: context.appEdgeInsets(all: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.layers_outlined,
                                              size: 16,
                                              color: CustomColors.purple,
                                            ),
                                            context.horizontalSpace(8),
                                            Text(
                                              'Available Application Areas:',
                                              style: context.fonts.black14w600,
                                            ),
                                          ],
                                        ),
                                        context.verticalSpace(12),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          children: template.availableAreas.map((area) {
                                            final bool areaSelected = _selectedAreas.contains(area);
                                            return FilterChip(
                                              selected: areaSelected,
                                              checkmarkColor: Colors.white,
                                              selectedColor: CustomColors.purple,
                                              backgroundColor: CustomColors.whiteGrey,
                                              label: Text(
                                                area,
                                                style: areaSelected
                                                    ? context.fonts.white14w600
                                                    : context.fonts.black12w400,
                                              ),
                                              onSelected: (selected) {
                                                setState(() {
                                                  if (selected) {
                                                    _selectedAreas.add(area);
                                                  } else {
                                                    _selectedAreas.remove(area);
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Import/Add Button with matching padding (12)
              Padding(
                padding: context.appEdgeInsets(horizontal: 12, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomPrimaryButton(
                    onTap: _selectedTemplate == null || _selectedAreas.isEmpty
                        ? null
                        : () {
                            _handleAddTreatment();
                          },
                    label: 'Add Treatment',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddTreatment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(16))),
          child: Padding(
            padding: context.appEdgeInsets(all: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 16),
                  decoration: const BoxDecoration(
                    color: CustomColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 40, color: Colors.white),
                ),
                context.verticalSpace(24),
                Text(
                  "Treatment Registered!",
                  style: context.fonts.black20w600,
                  textAlign: TextAlign.center,
                ),
                context.verticalSpace(12),
                Text(
                  "Successfully configured and imported ${_selectedTemplate!.name} with ${_selectedAreas.length} selected target areas.",
                  style: context.fonts.grey14w400,
                  textAlign: TextAlign.center,
                ),
                context.verticalSpace(24),
                SizedBox(
                  width: double.infinity,
                  child: CustomPrimaryButton(
                    onTap: () {
                      Navigator.of(ctx).pop(); // Dismiss success dialog
                      context.pop(); // Navigate back to treatments catalog screen
                    },
                    label: "Return to Catalog",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}