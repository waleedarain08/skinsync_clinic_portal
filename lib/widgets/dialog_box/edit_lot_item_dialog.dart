import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/responses/lot_items_list_response.dart';
import '../../utils/theme.dart';
import '../../view_models/product_view_model.dart';
import '../build_textfield.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'show_success_dailog.dart';

class EditLotItemDialog extends ConsumerStatefulWidget {
  final LotItemModel item;
  const EditLotItemDialog({super.key, required this.item});

  @override
  ConsumerState<EditLotItemDialog> createState() => _EditLotItemDialogState();

  static void show(BuildContext context, LotItemModel item) {
    showDialog(
      context: context,
      builder: (context) => EditLotItemDialog(item: item),
    );
  }
}

class _EditLotItemDialogState extends ConsumerState<EditLotItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _serialNumberController;
  late final TextEditingController _barcodeController;

  @override
  void initState() {
    super.initState();
    _serialNumberController = TextEditingController(text: widget.item.serialNumber);
    _barcodeController = TextEditingController(text: widget.item.itemBarcode);
  }

  @override
  void dispose() {
    _serialNumberController.dispose();
    _barcodeController.dispose();
    super.dispose();
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
                  Text('Edit Lot Item', style: CustomFonts.black20w600),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close, color: CustomColors.black),
                  ),
                ],
              ),
              SizedBox(height: context.h(24)),
              BuildTextField(
                label: 'Serial Number',
                controller: _serialNumberController,
                hintText: 'e.g. SN-2024-001-0001',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Serial number is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.h(20)),
              BuildTextField(
                label: 'Item Barcode',
                controller: _barcodeController,
                hintText: 'e.g. ITEM5901234123457001',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Item barcode is required';
                  }
                  return null;
                },
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
                          final success = await ref.read(productViewModelProvider.notifier).updateLotItem(
                                itemId: widget.item.id,
                                serialNumber: _serialNumberController.text,
                                itemBarcode: _barcodeController.text,
                              );
                          if (success && context.mounted) {
                            context.pop();
                            SuccessDialog.show(
                              context,
                              title: 'Item Updated',
                              description: 'The lot item has been successfully updated.',
                              icon: const Icon(Icons.check_circle_outline, size: 48, color: CustomColors.green),
                            );
                          }
                        }
                      },
                      label: 'Save Changes',
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
