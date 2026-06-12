import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/extentions.dart';

import '../../models/requests/add_treatment_req_model.dart';
import '../../models/treatment_model.dart';
import '../../view_models/treatment_view_model.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Treatment', style: CustomFonts.black20w600),
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
                        items: _adminTreatments
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item.name ?? "N/A"),
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
              _selectedTreatment == null
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(bottom: context.h(30)),
                      child: BuildTextField(
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: CustomColors.blue,
                          size: context.r(20),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.parse(value) == 0) {
                            return 'Price is required';
                          }
                          return null;
                        },
                        label:
                            '${_selectedTreatment?.name ?? "N/A"} Treatment Price',
                        controller: _treatmentPriceControllers,
                        hintText: '200',
                      ),
                    ),
              Text("Select Areas", style: CustomFonts.black14w500),

              if (_selectedTreatment?.isArea == true && _loadingAreas) ...[
                SizedBox(height: context.h(20)),
                Wrap(
                  spacing: context.w(8),
                  runSpacing: context.h(8),
                  children: List.generate(8, (index) {
                    return Container(
                      height: context.h(48),
                      width: context.w(150),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(8)),
                      ),
                    ).withShimmer();
                  }).toList(),
                ),
              ],

              if (_selectedTreatment?.isArea == true && !_loadingAreas) ...[
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
                            _areaPriceControllers.add(TextEditingController());
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
                SizedBox(height: context.h(30)),
                Column(
                  children: _selectedAreas.map((area) {
                    return area.maxSyringe != 0
                        ? Padding(
                            padding: EdgeInsets.only(bottom: context.h(20)),
                            child: BuildTextField(
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: CustomColors.blue,
                                size: context.r(20),
                              ),
                              onChanged: (value) {
                                final index = _selectedAreas.indexOf(area);
                                if (index != -1) {
                                  _selectedAreas[index].perSyringePrice =
                                      double.tryParse(value) ?? 0;
                                }
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.parse(value) == 0) {
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
                            ),
                          )
                        : const SizedBox.shrink();
                  }).toList(),
                ),
              ],
              SizedBox(height: context.h(32)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_loadingAreas || _loadingTreatments) {
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

                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (!isValid) {
                          return;
                        }
                        ref
                            .read(treatmentViewModelProvider.notifier)
                            .addClinicTreatment(
                              treatment: AddTreatmentReqModel(
                                treatmentId: _selectedTreatment!.id!,
                                treatmentPrice:
                                    double.tryParse(
                                      _treatmentPriceControllers.text,
                                    ) ??
                                    0,
                                sideareas: _selectedAreas,
                              ),
                            )
                            .then((value) {
                              if (value && context.mounted) {
                                context.pop();
                              }
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.black,
                      ),
                      child: Text('Create', style: CustomFonts.white14w600),
                    ),
                  ),
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(),
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
      ),
    );
  }
}
