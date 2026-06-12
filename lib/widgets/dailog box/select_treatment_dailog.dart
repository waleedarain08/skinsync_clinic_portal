import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/view_models/doctor_view_model.dart';

import '../../models/treatment_model.dart';
import '../../utils/theme.dart';
import '../../utils/extentions.dart';
import '../../view_models/treatment_view_model.dart';

class SelectTreatmentDialog extends ConsumerStatefulWidget {
  const SelectTreatmentDialog({super.key});

  @override
  ConsumerState<SelectTreatmentDialog> createState() =>
      _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends ConsumerState<SelectTreatmentDialog> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentViewModelProvider.notifier).getTreatments().then((
        success,
      ) {
        if (!success) {
          return;
        }
        final treatments = ref.read(treatmentViewModelProvider).treatments;
        setState(() {
          _loadingTreatments = false;
          _treatments = treatments;
        });
      });
    });

    super.initState();
  }

  bool _loadingTreatments = true;

  TreatmentModel? _selectedTreatment;
  late List<TreatmentModel> _treatments;
  List<SideAreaModel> _sideAreas = [];
  List<SideAreaModel> _selectedAreas = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.w(50),
        vertical: context.h(50),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.r(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Doctor Treatment', style: CustomFonts.black20w600),
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close, color: CustomColors.black),
                ),
              ],
            ),
            SizedBox(height: context.h(40)),

            Text("Select Treatment", style: CustomFonts.black14w500),
            SizedBox(height: context.h(8)),
            _loadingTreatments
                ? Container(
                    height: context.h(48),
                    decoration: BoxDecoration(
                      color: CustomColors.softGrey,
                      borderRadius: BorderRadius.circular(context.r(8)),
                    ),
                  ).withShimmer()
                : DropdownButtonHideUnderline(
                    child: DropdownButton2<TreatmentModel>(
                      isExpanded: true,
                      hint: Text(
                        "Select Treatment",
                        style: TextStyle(
                          color: CustomColors.lightGrey,
                          fontSize: context.sp(14),
                        ),
                      ),
                      value: _selectedTreatment,
                      items: _treatments
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.name ?? "N/A"),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        log('VALUE: ${value?.description}');
                        if (value == null || value == _selectedTreatment) {
                          return;
                        }

                        setState(() {
                          _selectedTreatment = value;
                        });
                        _sideAreas = _selectedTreatment!.sideAreas ?? [];
                        _selectedAreas = [];
                        setState(() {});
                      },
                      buttonStyleData: ButtonStyleData(
                        height: context.h(48),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(16),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.r(8)),
                          border: Border.all(color: CustomColors.border),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: context.h(30)),
            if (_selectedTreatment != null) ...[
              Text("Select Areas", style: CustomFonts.black14w500),
              SizedBox(height: context.h(16)),
              Wrap(
                spacing: context.w(8),
                runSpacing: context.h(8),
                children: _sideAreas.map((area) {
                  final isSelected = _selectedAreas.contains(area);
                  return ChoiceChip(
                    label: Text(area.name ?? "N/A"),
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
                        } else {
                          _selectedAreas.remove(area);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: context.h(30)),
            ],
            SizedBox(height: context.h(32)),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_loadingTreatments) {
                        EasyLoading.showError('Please wait while we load');
                        return;
                      }
                      if (_selectedTreatment == null) {
                        EasyLoading.showError('Please select a treatment');
                        return;
                      }
                      if (_selectedTreatment!.isArea == true &&
                          _selectedAreas.isEmpty) {
                        EasyLoading.showError(
                          'Please select at least one area',
                        );
                        return;
                      }
                      ref
                          .read(doctorProvider.notifier)
                          .toggleSelectedTreatment(
                            _selectedTreatment!.copyWith(
                              sideAreas: _selectedAreas,
                            ),
                          );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.black,
                    ),
                    child: Text(
                      'Add Treatment',
                      style: CustomFonts.white14w600,
                    ),
                  ),
                ),
                SizedBox(width: context.w(16)),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: CustomColors.black),
                    ),
                    child: Text('Cancel', style: CustomFonts.black14w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
