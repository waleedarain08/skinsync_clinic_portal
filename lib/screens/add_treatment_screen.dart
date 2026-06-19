import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/build_textfield.dart';

class AddTreatmentScreen extends StatefulWidget {
  const AddTreatmentScreen({super.key});
  static const String routeName = '/add-treatment';

  @override
  State<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  int _currentStep = 0;

  final List<String> _steps = [
    'Selection',
    'Area Configuration',
    'Pricing Setup',
    'Review & Create',
  ];

  // Form values
  String? _selectedCategory;
  final Set<String> _selectedAreas = {};
  final Map<String, TextEditingController> _areaPriceControllers = {};

  // Data
  final List<String> _categories = ['Botox', 'Dermal Filler'];
  final Map<String, List<String>> _categoryAreas = {
    'Dermal Filler': ['Temples', 'TearTough', 'Cheeks / Middle face volume'],
    'Botox': [
      'Forehead',
      'Glabella Line',
      'Eyebrow Lift',
      'Crows Feet',
      "Bunny Line",
    ],
  };

  @override
  void dispose() {
    for (final c in _areaPriceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _handleNextStep() {
    if (_currentStep == 0 && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a treatment category.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return;
    }
    if (_currentStep == 1 && _selectedAreas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one treatment area.'),
          backgroundColor: CustomColors.red,
        ),
      );
      return;
    }
    if (_currentStep == 2) {
      final incomplete = _selectedAreas.any((a) => _areaPriceControllers[a]?.text.isEmpty ?? true);
      if (incomplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please set pricing for all selected areas.'),
            backgroundColor: CustomColors.red,
          ),
        );
        return;
      }
    }
    _nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.screenWidth > 1200;
    final bool isTablet = context.screenWidth > 800 && context.screenWidth <= 1200;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Treatment Builder', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.close, color: CustomColors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar - Stepper (exactly matches CreateTreatmentScreen)
          if (isDesktop || isTablet) _buildLeftSidebar(),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                if (!isDesktop && !isTablet) _buildMobileProgress(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: context.w(isDesktop ? 800 : 900)),
                        child: Column(
                          children: [
                            _buildStepHeader(),
                            context.verticalSpace(32),
                            _buildFormContainer(),
                            context.verticalSpace(48),
                            _buildNavigationButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right Sidebar - Live Preview (exactly matches CreateTreatmentScreen)
          if (isDesktop) _buildRightSidebar(),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: context.w(280),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: CustomColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Builder Progress", style: context.fonts.grey12w600),
                context.verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${_currentStep + 1} / ${_steps.length}", style: context.fonts.black14w700),
                    Text("${((_currentStep + 1) / _steps.length * 100).toInt()}%", style: context.fonts.purple14w700),
                  ],
                ),
                context.verticalSpace(12),
                ClipRRect(
                  borderRadius: context.appBorderRadius(all: 10),
                  child: LinearProgressIndicator(
                    value: (_currentStep + 1) / _steps.length,
                    minHeight: context.h(8),
                    backgroundColor: CustomColors.whiteGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(CustomColors.purple),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: context.appEdgeInsets(vertical: 16),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final bool isActive = _currentStep == index;
                final bool isCompleted = _currentStep > index;

                return InkWell(
                  onTap: index <= _currentStep ? () => setState(() => _currentStep = index) : null,
                  child: Container(
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: isActive ? CustomColors.purple.withValues(alpha: 0.05) : Colors.transparent,
                      border: Border(right: BorderSide(color: isActive ? CustomColors.purple : Colors.transparent, width: 3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: context.w(24),
                          height: context.w(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted ? CustomColors.green : (isActive ? CustomColors.purple : Colors.white),
                            border: Border.all(color: isActive || isCompleted ? Colors.transparent : CustomColors.border),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check, color: Colors.white, size: 14)
                                : Text("${index + 1}", style: isActive ? context.fonts.white10w700 : context.fonts.grey10w700),
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Text(
                            _steps[index],
                            style: isActive ? context.fonts.purple14w600 : (isCompleted ? context.fonts.black14w400 : context.fonts.grey14w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileProgress() {
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Step ${_currentStep + 1} of ${_steps.length}", style: context.fonts.black14w700),
              Text("${((_currentStep + 1) / _steps.length * 100).toInt()}%", style: context.fonts.purple14w700),
            ],
          ),
          context.verticalSpace(8),
          ClipRRect(
            borderRadius: context.appBorderRadius(all: 4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              minHeight: context.h(4),
              backgroundColor: CustomColors.whiteGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(CustomColors.purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader() {
    final titles = [
      "Select Treatment Type",
      "Configure Sub-Areas",
      "Dynamic Pricing Setup",
      "Finalize Treatment",
    ];
    final descriptions = [
      "Choose a medical treatment category to begin configuration.",
      "Select mandatory clinical areas for this treatment.",
      "Define standard pricing per syringe or unit for each selected area.",
      "Review the clinical blueprint and create the treatment profile.",
    ];
    final icons = [
      Icons.category_outlined,
      Icons.accessibility_new_outlined,
      Icons.payments_outlined,
      Icons.fact_check_outlined,
    ];

    return Row(
      children: [
        Container(
          padding: context.appEdgeInsets(all: 12),
          decoration: BoxDecoration(
            color: CustomColors.purple.withValues(alpha: 0.1),
            borderRadius: context.appBorderRadius(all: 12),
          ),
          child: Icon(icons[_currentStep], color: CustomColors.purple, size: 24),
        ),
        context.horizontalSpace(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titles[_currentStep], style: context.fonts.black20w600),
              Text(descriptions[_currentStep], style: context.fonts.grey14w400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: context.appEdgeInsets(all: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.card(context),
      ),
      child: _buildCurrentStepContent(),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Treatment Category", style: context.fonts.black16w600),
        context.verticalSpace(24),
        _buildDropdownField(
          label: 'Select Treatment',
          hintText: 'Select Treatment Type',
          value: _selectedCategory,
          items: _categories,
          onChanged: (value) {
            setState(() {
              _selectedCategory = value;
              _selectedAreas.clear();
              _areaPriceControllers.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    if (_selectedCategory == null) return _buildWarning("Please select a category first.");

    final areas = _categoryAreas[_selectedCategory] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mandatory Treatment Areas", style: context.fonts.black16w600),
        context.verticalSpace(12),
        Text("Choose which sub-areas are available for this treatment in your clinic.", style: context.fonts.grey14w400),
        context.verticalSpace(24),
        Wrap(
          spacing: context.w(12),
          runSpacing: context.h(12),
          children: areas.map((area) {
            final isSelected = _selectedAreas.contains(area);

            return InkWell(
              onTap: () {
                setState(() {
                  if (!isSelected) {
                    _selectedAreas.add(area);
                    _areaPriceControllers[area] = TextEditingController();
                  } else {
                    _selectedAreas.remove(area);
                    _areaPriceControllers[area]?.dispose();
                    _areaPriceControllers.remove(area);
                  }
                });
              },
              borderRadius: context.appBorderRadius(all: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? CustomColors.purple.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: context.appBorderRadius(all: 10),
                  border: Border.all(
                    color: isSelected ? CustomColors.purple : CustomColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                      size: 18,
                      color: isSelected ? CustomColors.purple : CustomColors.grey,
                    ),
                    context.horizontalSpace(10),
                    Text(
                      area,
                      style: isSelected ? context.fonts.purple14w600 : context.fonts.black14w400,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    if (_selectedAreas.isEmpty) return _buildWarning("Please select at least one treatment area.");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Area-Specific Pricing", style: context.fonts.black16w600),
        context.verticalSpace(12),
        Text("Define the clinical pricing per syringe or unit for each selected area.", style: context.fonts.grey14w400),
        context.verticalSpace(24),
        ..._selectedAreas.map((area) {
          return Container(
            margin: context.appEdgeInsets(bottom: 16),
            padding: context.appEdgeInsets(all: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(color: CustomColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.monetization_on_outlined, color: CustomColors.purple, size: 20),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: BuildTextField(
                    label: '$area - Price Per Syringe (AED)',
                    controller: _areaPriceControllers[area]!,
                    hintText: 'e.g. 200',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Final Review", style: context.fonts.black16w600),
        context.verticalSpace(24),
        Container(
          padding: context.appEdgeInsets(all: 20),
          decoration: BoxDecoration(
            color: CustomColors.whiteGrey,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBlueprintItem("Category", _selectedCategory ?? "N/A"),
              const Divider(height: 32, color: CustomColors.border),
              Text("Configured Areas & Pricing", style: context.fonts.purple14w700),
              context.verticalSpace(16),
              if (_selectedAreas.isEmpty)
                Text("No areas configured", style: context.fonts.grey14w400)
              else
                ..._selectedAreas.map((area) {
                  final price = _areaPriceControllers[area]?.text.isEmpty ?? true ? "0" : _areaPriceControllers[area]!.text;
                  return Padding(
                    padding: context.appEdgeInsets(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_outline, color: CustomColors.green, size: 16),
                            context.horizontalSpace(8),
                            Text(area, style: context.fonts.black14w400),
                          ],
                        ),
                        Text("AED $price / syringe", style: context.fonts.black14w600),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBlueprintItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.fonts.grey14w400),
        Text(value, style: context.fonts.black16w600),
      ],
    );
  }

  Widget _buildWarning(String message) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
          context.verticalSpace(16),
          Text(message, style: context.fonts.grey14w400),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: CustomOutlinedButton(
              onTap: _prevStep,
              label: 'Previous Step',
            ),
          ),
        if (_currentStep > 0) context.horizontalSpace(16),
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () {
              if (_currentStep == _steps.length - 1) {
                _handleSubmit();
              } else {
                _handleNextStep();
              }
            },
            label: _currentStep == _steps.length - 1 ? 'Finish & Create' : 'Next Step',
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Treatment created successfully!'),
        backgroundColor: CustomColors.green,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildRightSidebar() {
    return Container(
      width: context.w(350),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey.withValues(alpha: 0.5),
        border: const Border(left: BorderSide(color: CustomColors.border)),
      ),
      child: SingleChildScrollView(
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Live Blueprint Summary", style: context.fonts.black16w600),
            context.verticalSpace(20),
            _buildSummaryCard(),
            context.verticalSpace(32),
            Text("Clinical Checklist", style: context.fonts.black16w600),
            context.verticalSpace(16),
            _buildChecklistRow("Target Category Identified", _selectedCategory != null),
            _buildChecklistRow("Anatomical Areas Configured", _selectedAreas.isNotEmpty),
            _buildChecklistRow("Clinical Pricing Validated", _selectedAreas.isNotEmpty && _selectedAreas.every((a) => _areaPriceControllers[a]!.text.isNotEmpty)),
            context.verticalSpace(32),
            const Divider(),
            context.verticalSpace(24),
            Text("Audit Logs", style: context.fonts.black14w600),
            context.verticalSpace(12),
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.appBorderRadius(all: 8),
                border: Border.all(color: CustomColors.border),
              ),
              child: Text(
                _selectedCategory == null 
                    ? "Blueprint initialization successful. Waiting for clinical data validation..."
                    : "Category updated to '$_selectedCategory'. Waiting for area selection and pricing configuration.",
                style: context.fonts.grey12w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistRow(String label, bool isDone) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 12),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: isDone ? CustomColors.green : CustomColors.grey,
          ),
          context.horizontalSpace(12),
          Expanded(child: Text(label, style: isDone ? context.fonts.black14w600 : context.fonts.grey14w400)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final hasPrice = _selectedAreas.isNotEmpty && _selectedAreas.every((a) => _areaPriceControllers[a]?.text.isNotEmpty ?? false);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 16),
        boxShadow: AppShadows.card(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: context.h(140),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                color: CustomColors.grey,
                size: 36,
              ),
            ),
          ),
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedCategory ?? 'New Treatment',
                        style: context.fonts.black16w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_selectedAreas.isNotEmpty)
                      Text(
                        "AED ${_areaPriceControllers[_selectedAreas.first]?.text.isEmpty ?? true ? '0' : _areaPriceControllers[_selectedAreas.first]!.text}",
                        style: context.fonts.purple16w700,
                      )
                    else
                      Text(
                        "AED 0",
                        style: context.fonts.purple16w700,
                      ),
                  ],
                ),
                context.verticalSpace(8),
                Text(
                  _selectedCategory == null
                      ? 'Select a treatment category to begin configuration.'
                      : 'Clinical treatment category configured for $_selectedCategory.',
                  style: context.fonts.grey12w400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(16),
                const Divider(),
                context.verticalSpace(16),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: CustomColors.grey,
                    ),
                    context.horizontalSpace(8),
                    Text(
                      '${_selectedAreas.length} Areas Selected',
                      style: context.fonts.black12w600,
                    ),
                    const Spacer(),
                    Container(
                      padding: context.appEdgeInsets(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: hasPrice 
                            ? CustomColors.green.withValues(alpha: 0.1)
                            : CustomColors.purple.withValues(alpha: 0.1),
                        borderRadius: context.appBorderRadius(all: 20),
                      ),
                      child: Text(
                        hasPrice ? 'Ready' : 'Draft', 
                        style: hasPrice ? context.fonts.green10w700 : context.fonts.purple11w600
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

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w500),
        context.verticalSpace(8),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: context.fonts.grey14w400.copyWith(color: CustomColors.grey),
            ),
            value: value,
            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item, style: context.fonts.black14w400)),
                )
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: context.h(52),
              padding: context.appEdgeInsets(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.appBorderRadius(all: 12),
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
      ],
    );
  }
}
