import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';
import '../../view_models/product_view_model.dart';
import '../build_textfield.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'show_success_dailog.dart';

class AddBatchDialog extends ConsumerStatefulWidget {
  final int productId;
  const AddBatchDialog({super.key, required this.productId});

  @override
  ConsumerState<AddBatchDialog> createState() => _AddBatchDialogState();

  static void show(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AddBatchDialog(productId: productId),
    );
  }
}

class _AddBatchDialogState extends ConsumerState<AddBatchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _batchNumberController = TextEditingController();
  final _manufactureDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _batchNumberController.dispose();
    _manufactureDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
        _manufactureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
        width: context.w(500),
        padding: EdgeInsets.all(context.r(24)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New Batch', style: CustomFonts.black20w600),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close, color: CustomColors.black),
                  ),
                ],
              ),
              SizedBox(height: context.h(24)),
              BuildTextField(
                label: 'Batch Number',
                controller: _batchNumberController,
                hintText: 'e.g. BATCH-2024-001',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Batch number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.h(20)),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: BuildTextField(
                    label: 'Manufacture Date',
                    controller: _manufactureDateController,
                    hintText: 'YYYY-MM-DD',
                    suffixIcon: const Icon(Icons.calendar_today, color: CustomColors.purple),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Manufacture date is required';
                      }
                      return null;
                    },
                  ),
                ),
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
                          final success = await ref.read(productViewModelProvider.notifier).addBatch(
                                productId: widget.productId,
                                batchNumber: _batchNumberController.text,
                                manufactureDate: _manufactureDateController.text,
                              );
                          if (success && context.mounted) {
                            context.pop();
                            SuccessDialog.show(
                              context,
                              title: 'Batch Added',
                              description: 'The new batch has been successfully added to this product.',
                              icon: const Icon(Icons.layers_outlined, size: 48, color: CustomColors.green),
                            );
                          }
                        }
                      },
                      label: 'Add Batch',
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
