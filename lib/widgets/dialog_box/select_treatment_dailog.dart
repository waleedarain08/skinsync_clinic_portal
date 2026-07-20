import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../view_models/doctor_view_model.dart';
import '../../models/treatment_model.dart';
import '../../utils/theme.dart';
import '../../utils/extentions.dart';
import '../../view_models/treatment_view_model.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class SelectTreatmentDialog extends ConsumerStatefulWidget {
  const SelectTreatmentDialog({super.key});

  @override
  ConsumerState<SelectTreatmentDialog> createState() =>
      _SelectTreatmentDialogState();
}

class _SelectTreatmentDialogState extends ConsumerState<SelectTreatmentDialog> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(treatmentViewModelProvider.notifier)
          .getTreatments(isRefresh: true)
          .then((_) {
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
    return StandardDialog(
      title: "Add Doctor Treatment",
      width: 600.w,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Treatment", style: context.fonts.black14w600),
            context.verticalSpace(8),
            _loadingTreatments
                ? Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: CustomColors.softGrey,
                      borderRadius: context.appBorderRadius(all: 8),
                    ),
                  ).withShimmer()
                : DropdownButtonHideUnderline(
                    child: DropdownButton2<TreatmentModel>(
                      isExpanded: true,
                      hint: Text(
                        "Select Treatment",
                        style: context.fonts.grey14w400,
                      ),
                      value: _selectedTreatment,
                      items: _treatments
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.name ?? "N/A",
                                style: context.fonts.black14w400,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null || value == _selectedTreatment)
                          return;
                        setState(() {
                          _selectedTreatment = value;
                          _sideAreas = value.sideAreas ?? [];
                          _selectedAreas = [];
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 48.h,
                        padding: context.appEdgeInsets(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: context.appBorderRadius(all: 8),
                          border: Border.all(color: CustomColors.border),
                        ),
                      ),
                    ),
                  ),
            if (_selectedTreatment != null && _sideAreas.isNotEmpty) ...[
              context.verticalSpace(24),
              Text("Select Areas", style: context.fonts.black14w600),
              context.verticalSpace(12),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _sideAreas.map((area) {
                  final isSelected = _selectedAreas.contains(area);
                  return ChoiceChip(
                    label: Text(area.name ?? "N/A"),
                    selected: isSelected,
                    selectedColor: CustomColors.purple,
                    checkmarkColor: CustomColors.white,
                    labelStyle: context.fonts.black14w500.copyWith(
                      color: isSelected
                          ? CustomColors.white
                          : CustomColors.black,
                    ),
                    backgroundColor: CustomColors.whiteGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.appBorderRadius(all: 8),
                      side: BorderSide(
                        color: isSelected
                            ? CustomColors.purple
                            : CustomColors.border,
                      ),
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
          ],
        ),
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'Cancel',
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () {
            if (_loadingTreatments) {
              EasyLoading.showError('Please wait while we load');
              return;
            }
            if (_selectedTreatment == null) {
              EasyLoading.showError('Please select a treatment');
              return;
            }
            if (_selectedTreatment!.isArea == true && _selectedAreas.isEmpty) {
              EasyLoading.showError('Please select at least one area');
              return;
            }
            ref
                .read(doctorProvider.notifier)
                .toggleSelectedTreatment(
                  _selectedTreatment!.copyWith(sideAreas: _selectedAreas),
                );
            Navigator.pop(context);
          },
          label: 'Add Treatment',
          width: 160.w,
        ),
      ],
    );
  }
}
