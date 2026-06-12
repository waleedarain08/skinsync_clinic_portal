import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';
import 'package:skinsync_clinic_portal/view_models/auth_view_model.dart';
import 'package:skinsync_clinic_portal/widgets/custom_outlined_button.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/appointment_ready_dailog.dart';

import '../../utils/theme.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Invoice', style: CustomFonts.black20w600),
                    SizedBox(height: context.h(4)),
                    Text(
                      '#${widget.invoiceNumber}',
                      style: CustomFonts.grey14w400,
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: context.w(36),
                    width: context.w(36),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Icon(Icons.close, size: context.r(18)),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(20)),

            /// Search
            CupertinoSearchTextField(
              style: CustomFonts.black16w500,
              backgroundColor: CustomColors.softGrey,
            ),
            SizedBox(height: context.h(16)),

            /// Product List
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.28,
              child: SingleChildScrollView(
                child: Column(
                  children: _products
                      .map((product) => _ProductTile(product: product))
                      .toList(),
                ),
              ),
            ),

            Divider(height: context.h(28), color: CustomColors.border),

            /// Payment Summary
            Text('Payment Summary', style: CustomFonts.black18w600),
            SizedBox(height: context.h(12)),
            Container(
              padding: EdgeInsets.all(context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                children: [
                  _summaryRow(
                    'Subtotal',
                    'AED ${_subtotal.toStringAsFixed(2)}',
                    isBold: false,
                  ),
                  Divider(height: context.h(20), color: CustomColors.border),
                  _summaryRow(
                    'Platform Fee',
                    'AED ${_platformFee.toStringAsFixed(2)}',
                    isBold: false,
                  ),
                  Divider(height: context.h(20), color: CustomColors.border),
                  _summaryRow(
                    'Total',
                    'AED ${_total.toStringAsFixed(2)}',
                    isBold: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(20)),

            /// Buttons
            Row(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    return Expanded(
                      child: CustomPrimaryButton(
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
                      ),
                    );
                  },
                ),
                SizedBox(width: context.w(12)),
                Expanded(
                  child: CustomOutlinedButton(
                    onTap: () => Navigator.pop(context),
                    label: 'Cancel',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {required bool isBold}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? CustomFonts.black16w600 : CustomFonts.grey14w400,
        ),
        Text(
          value,
          style: isBold ? CustomFonts.black16w600 : CustomFonts.grey14w400,
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
      margin: EdgeInsets.only(bottom: context.h(10)),
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(8)),
            child: Image.asset(
              product['image'],
              width: context.w(52),
              height: context.w(52),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: CustomFonts.black16w600,
                ),
                SizedBox(height: context.h(4)),
                Text(
                  'AED ${product['price'].toStringAsFixed(0)}',
                  style: CustomFonts.purple14w600,
                ),
              ],
            ),
          ),
          Icon(
            Icons.qr_code_scanner,
            size: context.r(24),
            color: CustomColors.black,
          ),
        ],
      ),
    );
  }
}
