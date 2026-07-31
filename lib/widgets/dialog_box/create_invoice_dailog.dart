import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/assets.dart';
import '../../view_models/auth_view_model.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'appointment_ready_dailog.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class CreateInvoiceDialog extends StatefulWidget {
  final String invoiceNumber;

  const CreateInvoiceDialog({super.key, required this.invoiceNumber});

  static void show(BuildContext context, {required String invoiceNumber}) {
    showDialog(
      context: context,
      builder: (_) => CreateInvoiceDialog(invoiceNumber: invoiceNumber),
    );
  }

  @override
  State<CreateInvoiceDialog> createState() => _CreateInvoiceDialogState();
}

class _CreateInvoiceDialogState extends State<CreateInvoiceDialog> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _products = [
    {'name': 'Product Name', 'price': 50.0, 'image': PngAssets.image},
    {'name': 'Product Name', 'price': 40.0, 'image': PngAssets.image},
    {'name': 'Product Name', 'price': 30.0, 'image': PngAssets.image},
  ];

  final double _platformFee = 1.00;

  double get _subtotal => _products.fold(0, (sum, p) => sum + p['price']);
  double get _total => _subtotal + _platformFee;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: 'Create Invoice',
      width: 600.w,
      content: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('#${widget.invoiceNumber}', style: context.fonts.grey13w500),
              context.verticalSpace(16),

              /// Search
              CupertinoSearchTextField(
                style: context.fonts.black14w400,
                backgroundColor: CustomColors.whiteGrey,
                placeholderStyle: context.fonts.grey13w500,
                padding: context.appEdgeInsets(horizontal: 12, vertical: 10),
              ),
              context.verticalSpace(20),

              /// Product List
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _products.length,
                  separatorBuilder: (_, __) => context.verticalSpace(12),
                  itemBuilder: (context, index) =>
                      _ProductTile(product: _products[index]),
                ),
              ),

              context.verticalSpace(24),
              const Divider(color: CustomColors.border),
              context.verticalSpace(24),

              /// Payment Summary
              Text('Payment Summary', style: context.fonts.black16w600),
              context.verticalSpace(12),
              Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
                  color: CustomColors.whiteGrey,
                ),
                child: Column(
                  children: [
                    _summaryRow(
                      'Subtotal',
                      '\$ ${_subtotal.toStringAsFixed(2)}',
                      isBold: false,
                    ),
                    context.verticalSpace(12),
                    const Divider(color: CustomColors.border),
                    context.verticalSpace(12),
                    _summaryRow(
                      'Platform Fee',
                      '\$ ${_platformFee.toStringAsFixed(2)}',
                      isBold: false,
                    ),
                    context.verticalSpace(12),
                    const Divider(color: CustomColors.border),
                    context.verticalSpace(12),
                    _summaryRow(
                      'Total',
                      '\$ ${_total.toStringAsFixed(2)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: 'Cancel',
          width: 100.w,
        ),
        Consumer(
          builder: (context, ref, _) {
            return CustomPrimaryButton(
              onTap: () {
                ref
                    .read(authViewModelProvider.notifier)
                    .navigateDailogIndexToNext(1);
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) => const AppointmentReadyDailog(),
                );
              },
              label: 'Send Invoice & Consent',
              width: 220.w,
            );
          },
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {required bool isBold}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? context.fonts.black14w600 : context.fonts.grey13w500,
        ),
        Text(
          value,
          style: isBold
              ? context.fonts.black16w600.copyWith(color: CustomColors.purple)
              : context.fonts.black14w600,
        ),
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(all: 12),
      decoration: BoxDecoration(
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
        color: CustomColors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: context.appBorderRadius(all: 8),
            child: Image.asset(
              product['image'],
              width: 52.w,
              height: 52.w,
              fit: BoxFit.cover,
            ),
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'], style: context.fonts.black14w600),
                Text(
                  '\$ ${product['price'].toStringAsFixed(0)}',
                  style: context.fonts.purple14w600,
                ),
              ],
            ),
          ),
          Icon(Icons.qr_code_scanner, size: 24.sp, color: CustomColors.black),
        ],
      ),
    );
  }
}
