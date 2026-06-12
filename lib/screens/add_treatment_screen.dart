import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';

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

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  // Dropdown values
  String? _selectedCategory;
  String? _selectedSubcategory;

  // Dropdown lists
  final List<String> _categories = ['Botox', 'Dermal Filler'];

  // final List<String> _subcategories = [
  //   'Anti-Aging',
  //   'Hydration',
  //   'Acne Treatment',
  //   'Brightening',
  //   'Relaxation',
  //   'Deep Tissue',
  // ];

  // Areas per category
  final Map<String, List<String>> _categoryAreas = {
    // 'Facial Treatments': ['Eye', 'Lip', 'Forehead', 'Cheeks'],
    'Dermal Filler': ['Temples', 'TearTough', 'Cheeks / Middle face volume'],
    'Botox': [
      'Forehead',
      'Glabella Line',
      'Eyebrow Lift',
      'Crows Feet',
      "Bunny Line",
    ],
    // 'Skin Care': ['Face', 'Neck', 'Hands'],
    // 'Hair Treatments': ['Scalp', 'Beard', 'Eyebrows'],
    // 'Massage Therapy': ['Full Body', 'Upper Body', 'Lower Body'],
    // 'Wellness': ['Relaxation', 'Detox', 'Rejuvenation'],
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 250.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeader(title: 'Add Treatment'),
              SizedBox(height: 24.h),
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
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatment Details', style: CustomFonts.black20w600),
          SizedBox(height: 24.h),

          // BuildTextField(
          //   label: 'Treatment Name',
          //   controller: _treatmentNameController,
          //   hintText: 'e.g., Botox, Dermal Fillers',
          // ),
          SizedBox(height: 20.h),

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
            SizedBox(height: 16.h),
            _buildAreaChips(),
            SizedBox(height: 16.h),
            _buildAreaPriceFields(),
          ],

          // SizedBox(height: 20.h),

          // _buildDropdownField(
          //   label: 'Subcategory',
          //   hintText: 'Select subcategory',
          //   value: _selectedSubcategory,
          //   items: _subcategories,
          //   onChanged: (value) {
          //     setState(() {
          //       _selectedSubcategory = value;
          //     });
          //   },
          // ),
          // SizedBox(height: 20.h),
          SizedBox(height: 32.h),

          _buildButtonsRow(),
        ],
      ),
    );
  }

  // ================== AREA CHIPS ==================
  Widget _buildAreaChips() {
    final areas = _categoryAreas[_selectedCategory] ?? [];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: areas.map((area) {
        final isSelected = _selectedAreas.contains(area);

        return ChoiceChip(
          label: Text(area),
          selected: isSelected,
          selectedColor: Colors.black,
          // showCheckmark: false,
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14.sp,
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
          padding: EdgeInsets.only(bottom: 12.h),
          child: BuildTextField(
            label: '$area Per Syringe Price',
            controller: _areaPriceControllers[area]!,
            hintText: '\$200',
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
        Text(label, style: CustomFonts.black14w500),
        SizedBox(height: 8.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(hintText, style: TextStyle(color: Colors.grey[400])),
            value: value,
            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[300]!),
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
              final Map<String, String> areaPrices = {
                for (var area in _selectedAreas)
                  area: _areaPriceControllers[area]!.text,
              };

              debugPrint(areaPrices.toString());

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Treatment created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              // padding: EdgeInsets.symmetric(vertical: 20.h),
            ),
            child: Text('Create', style: CustomFonts.white14w600),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: Text('Cancel', style: CustomFonts.black14w500),
          ),
        ),
      ],
    );
  }
}
