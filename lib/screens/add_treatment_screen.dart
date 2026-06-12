import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../widgets/build_textfield.dart';
import '../widgets/header__with_back_btn.dart';

class AddTreatmentScreen extends StatefulWidget {
  const AddTreatmentScreen({super.key});
  static const String routeName = '/add-treatment';

  @override
  State<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  final TextEditingController _treatmentNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;

  // Dropdown lists
  final List<String> _categories = ['Botox', 'Dermal Filler'];

  // Areas per category
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

  // Selected areas + prices
  final Set<String> _selectedAreas = {};
  final Map<String, TextEditingController> _areaPriceControllers = {};

  @override
  void dispose() {
    _treatmentNameController.dispose();
    _descriptionController.dispose();
    for (final c in _areaPriceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.w(250),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BuildHeader(title: 'Add Treatment'),
              SizedBox(height: context.h(24)),
              _buildFormContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(24)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatment Details', style: context.fonts.black20w600),
          SizedBox(height: context.h(24)),
          _buildDropdownField(
            label: 'Select Treatment',
            hintText: 'Select Treatment',
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

          // ===== AREA CHIPS =====
          if (_selectedCategory != null) ...[
            SizedBox(height: context.h(16)),
            _buildAreaChips(),
            SizedBox(height: context.h(16)),
            _buildAreaPriceFields(),
          ],

          SizedBox(height: context.h(32)),

          _buildButtonsRow(),
        ],
      ),
    );
  }

  // ================== AREA CHIPS ==================
  Widget _buildAreaChips() {
    final areas = _categoryAreas[_selectedCategory] ?? [];

    return Wrap(
      spacing: context.w(8),
      runSpacing: context.h(8),
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
    );
  }

  // ================== PRICE FIELDS ==================
  Widget _buildAreaPriceFields() {
    return Column(
      children: _selectedAreas.map((area) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.h(12)),
          child: BuildTextField(
            label: '$area Per Syringe Price',
            controller: _areaPriceControllers[area]!,
            hintText: 'AED 200',
          ),
        );
      }).toList(),
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
              height: context.h(48),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(8)),
                border: Border.all(color: CustomColors.border),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Treatment created successfully!'),
                  backgroundColor: CustomColors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.black,
            ),
            child: Text('Create', style: context.fonts.white14w600),
          ),
        ),
        SizedBox(width: context.w(16)),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: CustomColors.border),
            ),
            child: Text('Cancel', style: context.fonts.black14w500),
          ),
        ),
      ],
    );
  }
}
