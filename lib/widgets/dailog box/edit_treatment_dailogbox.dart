import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/extentions.dart';
import '../../models/requests/add_treatment_req_model.dart';
import '../../models/treatment_model.dart';
import '../../utils/theme.dart';
import '../../view_models/treatment_view_model.dart';
import '../build_textfield.dart';

class EditTreatmentDialog extends ConsumerStatefulWidget {
  const EditTreatmentDialog({super.key});

  @override
  ConsumerState<EditTreatmentDialog> createState() =>
      EditTreatmentDialogState();
}

class EditTreatmentDialogState extends ConsumerState<EditTreatmentDialog> {
  @override
  void initState() {
    super.initState();
    final provider = ref.read(treatmentViewModelProvider);
    final fromProvider = provider.treatments.firstWhere(
      (e) => e.id == provider.selectedTreatmentId,
    );
    // Work on a copy so we don't mutate provider state; ensures unselect/select updates UI
    _selectedTreatment =
        TreatmentModel(
            id: fromProvider.id,
            name: fromProvider.name,
            description: fromProvider.description,
            isArea: true,
          )
          ..price = fromProvider.price
          ..sideAreas = fromProvider.sideAreas
              ?.map(
                (e) => SideAreaModel(
                  id: e.id,
                  name: e.name,
                  perSyringePrice: e.perSyringePrice,
                  maxSyringe: e.maxSyringe ?? 0,
                ),
              )
              .toList();

    _treatmentPriceControllers = TextEditingController(
      text: _selectedTreatment!.price.toString(),
    );

    if (_selectedTreatment!.sideAreas != null &&
        _selectedTreatment!.sideAreas!.isNotEmpty) {
      _loadingAreas = true;
      // One controller per selected side area, in the same order
      for (var e in _selectedTreatment!.sideAreas!) {
        if (e.maxSyringe != 0) {
          _areaPriceControllers.add(
            TextEditingController(
              text: e.perSyringePrice?.toString() ?? '',
            ),
          );
        }
      }
      // Fetch full list of side areas once (outside the loop)
      ref
          .read(treatmentViewModelProvider.notifier)
          .getTreatmentsSideAreas(treatmentId: _selectedTreatment!.id!)
          .then((areas) {
            if (mounted) {
              setState(() {
                _sideAreas = areas;
                _loadingAreas = false;
              });
            }
          });
    } else {
      _sideAreas = _selectedTreatment!.sideAreas ?? [];
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TreatmentModel? _selectedTreatment;
  final List<TextEditingController> _areaPriceControllers = [];
  late List<SideAreaModel> _sideAreas;
  bool _loadingAreas = false;
  late TextEditingController _treatmentPriceControllers;

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
                  Text('Edit Treatment', style: CustomFonts.black20w600),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.close, color: CustomColors.black),
                  ),
                ],
              ),
              SizedBox(height: context.h(40)),

              AbsorbPointer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<TreatmentModel>(
                    isExpanded: true,
                    hint: Text(
                      _selectedTreatment?.name ?? "N/A",
                      style: TextStyle(
                        color: CustomColors.lightGrey,
                        fontSize: context.sp(14),
                      ),
                    ),
                    value: _selectedTreatment,
                    items: const [],
                    onChanged: (value) {},
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
              ),
              SizedBox(height: context.h(30)),

              Padding(
                padding: EdgeInsets.only(bottom: context.h(20)),
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
                  label: '${_selectedTreatment?.name ?? "N/A"} Treatment Price',
                  controller: _treatmentPriceControllers,
                  hintText: '$200',
                ),
              ),
              Text("Select Areas", style: CustomFonts.black14w500),

              if ((_selectedTreatment?.isArea ?? false) && _loadingAreas) ...[
                SizedBox(height: context.h(16)),
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

              if ((_selectedTreatment?.isArea ?? false) && !_loadingAreas) ...[
                SizedBox(height: context.h(16)),
                Wrap(
                  spacing: context.w(8),
                  runSpacing: context.h(8),
                  children: _sideAreas.map((area) {
                    final isSelected = _selectedTreatment!.sideAreas!.any(
                      (e) => e.id == area.id,
                    );
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
                            _selectedTreatment!.sideAreas!.add(area);
                            // Only add a controller if this area has per-syringe price (maxSyringe != 0)
                            if (area.maxSyringe != 0) {
                              _areaPriceControllers.add(
                                TextEditingController(),
                              );
                            }
                          } else {
                            final index = _selectedTreatment!.sideAreas!
                                .indexWhere((e) => e.id == area.id);
                            if (index != -1) {
                              final areaToRemove =
                                  _selectedTreatment!.sideAreas![index];
                              // Controller index = count of areas with maxSyringe!=0 before this index (must compute before remove)
                              final controllerIndex =
                                  areaToRemove.maxSyringe != 0
                                  ? _selectedTreatment!.sideAreas!
                                        .sublist(0, index)
                                        .where((e) => e.maxSyringe != 0)
                                        .length
                                  : -1;
                              _selectedTreatment!.sideAreas!.removeAt(index);
                              if (controllerIndex >= 0) {
                                _areaPriceControllers[controllerIndex]
                                    .dispose();
                                _areaPriceControllers.removeAt(controllerIndex);
                              }
                            }
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: context.h(30)),
                Column(
                  // _areaPriceControllers has one entry per area with maxSyringe != 0; use controllerIndex for that list
                  children: () {
                    int controllerIndex = 0;
                    return List.generate(
                      _selectedTreatment!.sideAreas!.length,
                      (index) {
                        final area = _selectedTreatment!.sideAreas![index];
                        if (area.maxSyringe != 0) {
                          final ctrlIndex = controllerIndex++;
                          return Padding(
                            padding: EdgeInsets.only(bottom: context.h(20)),
                            child: BuildTextField(
                              onChanged: (value) {
                                final currentIdx = _selectedTreatment!.sideAreas!
                                    .indexWhere((e) => e.id == area.id);
                                if (currentIdx != -1) {
                                  _selectedTreatment!
                                      .sideAreas![currentIdx]
                                      .perSyringePrice =
                                      double.tryParse(value) ?? 0;
                                }
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    int.tryParse(value) == 0) {
                                  return 'Price is required';
                                }
                                return null;
                              },
                              label: '${area.name} Per Syringe Price',
                              controller: _areaPriceControllers[ctrlIndex],
                              hintText: '$200',
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  }(),
                ),
              ],
              SizedBox(height: context.h(32)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_loadingAreas) {
                          EasyLoading.showError('Please wait while we load');
                          return;
                        }

                        if (_selectedTreatment!.isArea == true &&
                            _selectedTreatment!.sideAreas!.isEmpty) {
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
                            .editClinicTreatment(
                              treatment: AddTreatmentReqModel(
                                treatmentId: _selectedTreatment!.id!,
                                treatmentPrice:
                                    double.tryParse(
                                      _treatmentPriceControllers.text,
                                    ) ??
                                    0,
                                sideareas: _selectedTreatment!.sideAreas!,
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
                        padding: EdgeInsets.symmetric(vertical: context.h(20)),
                      ),
                      child: Text('Update', style: CustomFonts.white14w600),
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
