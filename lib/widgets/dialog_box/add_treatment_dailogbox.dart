import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/extentions.dart';

import '../../models/requests/add_treatment_req_model.dart';
import '../../models/treatment_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class AddTreatmentDialog extends ConsumerStatefulWidget {
  const AddTreatmentDialog({super.key});

  @override
  ConsumerState<AddTreatmentDialog> createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends ConsumerState<AddTreatmentDialog> {
  @override
  void initState() {
    ref.read(treatmentViewModelProvider.notifier).getAdminTreatments().then((
      treatments,
    ) {
      setState(() {
        _loadingTreatments = false;
        _adminTreatments = treatments;
      });
    });

    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loadingTreatments = true;
  bool _loadingAreas = false;

  TreatmentModel? _selectedTreatment;
  late List<TreatmentModel> _adminTreatments;
  List<SideAreaModel> _sideAreas = [];
  List<SideAreaModel> _selectedAreas = [];
  final List<TextEditingController> _areaPriceControllers = [];
  final TextEditingController _treatmentPriceControllers =
      TextEditingController();

  @override
  void dispose() {
    for (final c in _areaPriceControllers) {
      c.dispose();
    }
    _treatmentPriceControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Add Treatment",
      width: 600.w,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                        items: _adminTreatments
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
                          if (value == null || value == _selectedTreatment) {
                            return;
                          }

                          setState(() {
                            _selectedTreatment = value;
                          });
                          if (value.isArea == true) {
                            setState(() {
                              _loadingAreas = true;
                            });
                            ref
                                .read(treatmentViewModelProvider.notifier)
                                .getTreatmentsSideAreas(treatmentId: value.id!)
                                .then((areas) {
                                  setState(() {
                                    _sideAreas = areas;
                                    _loadingAreas = false;
                                    _selectedAreas = [];
                                    _areaPriceControllers.clear();
                                  });
                                });
                          }
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
              if (_selectedTreatment != null) ...[
                context.verticalSpace(20),
                BuildTextField(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: CustomColors.purple,
                    size: 20.sp,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == 0) {
                      return 'Price is required';
                    }
                    return null;
                  },
                  label: '${_selectedTreatment?.name ?? "N/A"} Treatment Price',
                  controller: _treatmentPriceControllers,
                  hintText: '200',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],

              if (_selectedTreatment?.isArea == true) ...[
                context.verticalSpace(20),
                Text("Select Areas", style: context.fonts.black14w600),
                context.verticalSpace(12),
                if (_loadingAreas)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(4, (index) {
                      return Container(
                        height: 40.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: CustomColors.softGrey,
                          borderRadius: context.appBorderRadius(all: 8),
                        ),
                      ).withShimmer();
                    }).toList(),
                  )
                else
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
                              _areaPriceControllers.add(
                                TextEditingController(),
                              );
                            } else {
                              final index = _selectedAreas.indexOf(area);
                              if (index != -1) {
                                _areaPriceControllers[index].dispose();
                                _areaPriceControllers.removeAt(index);
                              }
                              _selectedAreas.remove(area);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                context.verticalSpace(20),
                Column(
                  children: _selectedAreas.map((area) {
                    return area.maxSyringe != 0
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: BuildTextField(
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: CustomColors.purple,
                                size: 20.sp,
                              ),
                              onChanged: (value) {
                                final index = _selectedAreas.indexOf(area);
                                if (index != -1) {
                                  _selectedAreas[index].perSyringePrice =
                                      double.tryParse(value ?? "") ?? 0;
                                }
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    double.tryParse(value) == 0) {
                                  return 'Price is required';
                                }
                                return null;
                              },
                              label: '${area.name} Per Syringe Price',
                              controller:
                                  _areaPriceControllers[_selectedAreas.indexOf(
                                    area,
                                  )],
                              hintText: '200',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          )
                        : const SizedBox.shrink();
                  }).toList(),
                ),
              ],
            ],
          ),
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
            if (_loadingAreas || _loadingTreatments) {
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

            final isValid = _formKey.currentState?.validate() ?? false;
            if (!isValid) return;

            ref
                .read(treatmentViewModelProvider.notifier)
                .addClinicTreatment(
                  treatment: AddTreatmentReqModel(
                    treatmentId: _selectedTreatment!.id!,
                    treatmentPrice:
                        double.tryParse(_treatmentPriceControllers.text) ?? 0,
                    sideareas: _selectedAreas,
                  ),
                )
                .then((value) {
                  if (value && context.mounted) {
                    context.pop();
                  }
                });
          },
          label: 'Create',
          width: 120.w,
        ),
      ],
    );
  }
}
