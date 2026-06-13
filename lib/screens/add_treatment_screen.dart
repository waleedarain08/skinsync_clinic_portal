import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/widgets/custom_outlined_button.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/header__with_back_btn.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';
import '../utils/responsive.dart';
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

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = context.isLandscape;

    return GradientScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(16),
              ),
              child: const BuildHeader(title: 'Treatment Builder'),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Sidebar - Stepper
                  if (isLandscape) _buildLeftSidebar(),
                  
                  // Main Content
                  Expanded(
                    child: Column(
                      children: [
                        if (!isLandscape) _buildMobileProgress(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(context.w(24)),
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: context.w(800)),
                                child: Column(
                                  children: [
                                    _buildStepHeader(),
                                    SizedBox(height: context.h(24)),
                                    _buildFormContainer(),
                                    SizedBox(height: context.h(32)),
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

                  // Right Sidebar - Live Preview
                  if (isLandscape) _buildRightSidebar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: context.w(280),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(right: BorderSide(color: CustomColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Builder Progress", style: context.fonts.grey12w600),
                SizedBox(height: context.h(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${_currentStep + 1} / ${_steps.length}", style: context.fonts.black14w700),
                    Text("${((_currentStep + 1) / _steps.length * 100).toInt()}%", style: context.fonts.purple14w700),
                  ],
                ),
                SizedBox(height: context.h(12)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.r(10)),
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
              padding: EdgeInsets.symmetric(vertical: context.h(16)),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final bool isActive = _currentStep == index;
                final bool isCompleted = _currentStep > index;

                return InkWell(
                  onTap: index <= _currentStep ? () => setState(() => _currentStep = index) : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(16)),
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
                        SizedBox(width: context.w(16)),
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
      padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(12)),
      color: CustomColors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Step ${_currentStep + 1} of ${_steps.length}", style: context.fonts.black14w700),
              Text("${((_currentStep + 1) / _steps.length * 100).toInt()}%", style: context.fonts.purple14w700),
            ],
          ),
          SizedBox(height: context.h(8)),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _steps.length,
            minHeight: context.h(4),
            backgroundColor: CustomColors.whiteGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(CustomColors.purple),
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
          padding: EdgeInsets.all(context.w(12)),
          decoration: BoxDecoration(
            color: CustomColors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(context.r(12)),
          ),
          child: Icon(icons[_currentStep], color: CustomColors.purple, size: 24),
        ),
        SizedBox(width: context.w(16)),
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
      padding: EdgeInsets.all(context.w(32)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
        SizedBox(height: context.h(24)),
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
        SizedBox(height: context.h(12)),
        Text("Choose which sub-areas are available for this treatment in your clinic.", style: context.fonts.grey14w400),
        SizedBox(height: context.h(24)),
        Wrap(
          spacing: context.w(12),
          runSpacing: context.h(12),
          children: areas.map((area) {
            final isSelected = _selectedAreas.contains(area);

            return ChoiceChip(
              label: Text(area),
              selected: isSelected,
              selectedColor: CustomColors.black,
              checkmarkColor: CustomColors.white,
              labelStyle: TextStyle(
                color: isSelected ? CustomColors.white : CustomColors.black,
                fontSize: context.sp(14),
                fontWeight: FontWeight.w500,
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAreas.add(area);
                    _areaPriceControllers[area] = TextEditingController();
                  } else {
                    _selectedAreas.remove(area);
                    _areaPriceControllers[area]?.dispose();
                    _areaPriceControllers.remove(area);
                  }
                });
              },
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
        SizedBox(height: context.h(12)),
        Text("Define the clinical pricing per syringe or unit for each selected area.", style: context.fonts.grey14w400),
        SizedBox(height: context.h(24)),
        ..._selectedAreas.map((area) {
          return Padding(
            padding: EdgeInsets.only(bottom: context.h(20)),
            child: BuildTextField(
              label: '$area - Price Per Syringe (AED)',
              controller: _areaPriceControllers[area]!,
              hintText: 'e.g. 200',
              keyboardType: TextInputType.number,
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
        SizedBox(height: context.h(24)),
        _buildBlueprintItem("Category", _selectedCategory ?? "N/A"),
        const Divider(height: 32),
        Text("Configured Areas", style: context.fonts.black14w600.copyWith(color: CustomColors.purple)),
        SizedBox(height: context.h(16)),
        if (_selectedAreas.isEmpty)
          Text("No areas configured", style: context.fonts.grey14w400)
        else
          ..._selectedAreas.map((area) {
            final price = _areaPriceControllers[area]?.text.isEmpty ?? true ? "0" : _areaPriceControllers[area]!.text;
            return Padding(
              padding: EdgeInsets.only(bottom: context.h(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(area, style: context.fonts.black14w400),
                  Text("AED $price / syringe", style: context.fonts.black14w600),
                ],
              ),
            );
          }),
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
          SizedBox(height: context.h(16)),
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
        if (_currentStep > 0) SizedBox(width: context.w(16)),
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () {
              if (_currentStep == _steps.length - 1) {
                _handleSubmit();
              } else {
                _nextStep();
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
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(left: BorderSide(color: CustomColors.border)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Live Blueprint Summary", style: context.fonts.black16w600),
            SizedBox(height: context.h(24)),
            _buildSummaryCard(),
            SizedBox(height: context.h(32)),
            Text("Clinical Checklist", style: context.fonts.black16w600),
            SizedBox(height: context.h(16)),
            _buildChecklistRow("Target Category Identified", _selectedCategory != null),
            _buildChecklistRow("Anatomical Areas Configured", _selectedAreas.isNotEmpty),
            _buildChecklistRow("Clinical Pricing Validated", _selectedAreas.isNotEmpty && _selectedAreas.every((a) => _areaPriceControllers[a]!.text.isNotEmpty)),
            SizedBox(height: context.h(32)),
            const Divider(),
            SizedBox(height: context.h(24)),
            Text("Audit Logs", style: context.fonts.black14w600),
            SizedBox(height: context.h(12)),
            Text("Blueprint initialization successful. Waiting for clinical data validation...", style: context.fonts.grey12w400),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistRow(String label, bool isDone) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(12)),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: isDone ? CustomColors.green : CustomColors.grey,
          ),
          SizedBox(width: context.w(12)),
          Expanded(child: Text(label, style: isDone ? context.fonts.black14w600 : context.fonts.grey14w400)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Blueprint", style: context.fonts.purple12w700),
          SizedBox(height: context.h(16)),
          _blueprintSummaryRow("Type", _selectedCategory ?? "Not set"),
          _blueprintSummaryRow("Areas", "${_selectedAreas.length} selected"),
          if (_selectedAreas.isNotEmpty) ...[
            const Divider(height: 24),
            Text("Prices Overview:", style: context.fonts.black12w600),
            SizedBox(height: context.h(8)),
            ..._selectedAreas.take(3).map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text("• $a: AED ${_areaPriceControllers[a]?.text ?? '0'}", style: context.fonts.grey12w400),
            )),
            if (_selectedAreas.length > 3)
              Text("• ...and ${_selectedAreas.length - 3} more", style: context.fonts.grey12w400),
          ],
        ],
      ),
    );
  }

  Widget _blueprintSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.fonts.grey12w400),
          Text(value, style: context.fonts.black12w600),
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
        SizedBox(height: context.h(8)),
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
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: context.h(52),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(color: CustomColors.border),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
