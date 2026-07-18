import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';
import '../../view_models/product_view_model.dart';
import '../build_textfield.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'show_success_dailog.dart';

class AddLotDialog extends ConsumerStatefulWidget {
  final int batchId;
  const AddLotDialog({super.key, required this.batchId});

  @override
  ConsumerState<AddLotDialog> createState() => _AddLotDialogState();

  static void show(BuildContext context, int batchId) {
    showDialog(
      context: context,
      builder: (context) => AddLotDialog(batchId: batchId),
    );
  }
}

class _AddLotDialogState extends ConsumerState<AddLotDialog> {
  final _formKey = GlobalKey<FormState>();
  final _lotNumberController = TextEditingController();
  final _lotBarcodeController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _clinicCostController = TextEditingController();
  final _retailPriceController = TextEditingController();
  final _supplierController = TextEditingController();
  final _quantityReceivedController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _lotNumberController.dispose();
    _lotBarcodeController.dispose();
    _expirationDateController.dispose();
    _clinicCostController.dispose();
    _retailPriceController.dispose();
    _supplierController.dispose();
    _quantityReceivedController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomColors.purple,
              onPrimary: Colors.white,
              onSurface: CustomColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _expirationDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Container(
        width: context.w(600),
        padding: EdgeInsets.all(context.r(24)),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add New Lot', style: CustomFonts.black20w600),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, color: CustomColors.black),
                    ),
                  ],
                ),
                SizedBox(height: context.h(24)),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: 'Lot Number',
                        controller: _lotNumberController,
                        hintText: 'LOT-2024-001-A',
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    Expanded(
                      child: BuildTextField(
                        label: 'Lot Barcode',
                        controller: _lotBarcodeController,
                        hintText: 'Barcode ID',
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(20)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: BuildTextField(
                            label: 'Expiration Date',
                            controller: _expirationDateController,
                            hintText: 'YYYY-MM-DD',
                            suffixIcon: const Icon(Icons.calendar_today, color: CustomColors.purple),
                            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    Expanded(
                      child: BuildTextField(
                        label: 'Supplier',
                        controller: _supplierController,
                        hintText: 'MedSupply Co.',
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(20)),
                Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        label: 'Clinic Cost',
                        controller: _clinicCostController,
                        hintText: '300.00',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    Expanded(
                      child: BuildTextField(
                        label: 'Retail Price',
                        controller: _retailPriceController,
                        hintText: '500.00',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (double.tryParse(value) == null || double.parse(value) <= 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    Expanded(
                      child: BuildTextField(
                        label: 'Qty Received',
                        controller: _quantityReceivedController,
                        hintText: '50',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (int.tryParse(value) == null || int.parse(value) <= 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(32)),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        onTap: () => context.pop(),
                        label: 'Cancel',
                      ),
                    ),
                    SizedBox(width: context.w(16)),
                    Expanded(
                      child: CustomPrimaryButton(
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final success = await ref.read(productViewModelProvider.notifier).addLot(
                                  batchId: widget.batchId,
                                  lotNumber: _lotNumberController.text,
                                  lotBarcode: _lotBarcodeController.text,
                                  expirationDate: _expirationDateController.text,
                                  clinicCost: double.parse(_clinicCostController.text),
                                  retailPricePerUnit: double.parse(_retailPriceController.text),
                                  supplier: _supplierController.text,
                                  quantityReceived: int.parse(_quantityReceivedController.text),
                                );
                            if (success && context.mounted) {
                              context.pop();
                              SuccessDialog.show(
                                context,
                                title: 'Lot Added',
                                description: 'The new lot has been successfully added to this batch.',
                                icon: const Icon(Icons.qr_code_scanner_outlined, size: 48, color: CustomColors.green),
                              );
                            }
                          }
                        },
                        label: 'Add Lot',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
