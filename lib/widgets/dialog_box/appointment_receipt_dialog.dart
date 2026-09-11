import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../borderd_container_widget.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class TreatmentSummaryItem {
  final String treatmentName;
  final double treatmentCost;
  final String? areaName;
  final String? sessionName;
  final String? materialName;
  final int? materialQty;

  TreatmentSummaryItem({
    required this.treatmentName,
    required this.treatmentCost,
    this.areaName,
    this.sessionName,
    this.materialName,
    this.materialQty,
  });
}

class AppointmentReceiptDialog extends StatefulWidget {
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final List<Map<String, String>> practitioners;
  final String dateStr;
  final String timeSlot;
  final String appointmentType;
  final String bookingMethod;
  final List<TreatmentSummaryItem> treatments;
  final double treatmentTotal;
  final String discountType;
  final double discountVal;
  final double discountAmount;
  final double amountPaid;
  final double remainingPayable;
  final String paymentType;
  final String paymentStatus;
  final Map<String, String> simulations;
  final Future<bool> Function() onConfirm;

  const AppointmentReceiptDialog({
    super.key,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.practitioners,
    required this.dateStr,
    required this.timeSlot,
    required this.appointmentType,
    required this.bookingMethod,
    required this.treatments,
    required this.treatmentTotal,
    required this.discountType,
    required this.discountVal,
    required this.discountAmount,
    required this.amountPaid,
    required this.remainingPayable,
    required this.paymentType,
    required this.paymentStatus,
    required this.simulations,
    required this.onConfirm,
  });

  @override
  State<AppointmentReceiptDialog> createState() =>
      _AppointmentReceiptDialogState();
}

class _AppointmentReceiptDialogState extends State<AppointmentReceiptDialog> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Appointment Summary & Receipt",
      width: 600.w,
      height: 680.h,
      actions: [
        CustomOutlinedButton(
          onTap: _isSubmitting ? null : () => Navigator.of(context).pop(),
          label: 'Edit Details',
          height: context.h(40),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        CustomPrimaryButton(
          onTap: _isSubmitting ? null : _handleConfirm,
          label: _isSubmitting ? 'Creating...' : 'Confirm & Create',
          height: context.h(40),
          width: context.w(210),
          icon: _isSubmitting ? null : Icons.check_circle_outline,
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient & Schedule Header
            _buildPatientHeader(context),
            context.verticalSpace(16),

            // Practitioners Section
            _buildPractitionersSection(context),
            context.verticalSpace(16),

            // Treatments & Services Section
            _buildTreatmentsSection(context),
            context.verticalSpace(16),

            // Financial Breakdown Section
            _buildFinancialSection(context),

            // Simulations Section (if any attached)
            if (widget.simulations.values.any((s) => s.isNotEmpty)) ...[
              context.verticalSpace(16),
              _buildSimulationsSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() => _isSubmitting = true);
    final success = await widget.onConfirm();
    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Widget _buildPatientHeader(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      backgroundColor: CustomColors.whiteGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.patientName,
                style: context.fonts.black16w600,
              ),
              Container(
                padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.1),
                  borderRadius: context.appBorderRadius(all: 12),
                ),
                child: Text(
                  '${widget.bookingMethod.toUpperCase()} | ${widget.appointmentType}',
                  style: context.fonts.purple11w600,
                ),
              ),
            ],
          ),
          context.verticalSpace(8),
          Row(
            children: [
              if (widget.patientEmail.isNotEmpty) ...[
                const Icon(Icons.email_outlined,
                    size: 14, color: CustomColors.grey),
                context.horizontalSpace(4),
                Text(widget.patientEmail, style: context.fonts.grey12w400),
                context.horizontalSpace(16),
              ],
              if (widget.patientPhone.isNotEmpty) ...[
                const Icon(Icons.phone_outlined,
                    size: 14, color: CustomColors.grey),
                context.horizontalSpace(4),
                Text(widget.patientPhone, style: context.fonts.grey12w400),
              ],
            ],
          ),
          const Divider(height: 20, color: CustomColors.border),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined,
                  size: 16, color: CustomColors.purple),
              context.horizontalSpace(6),
              Text(
                'Date: ${widget.dateStr}',
                style: context.fonts.black13w600,
              ),
              context.horizontalSpace(20),
              const Icon(Icons.access_time_rounded,
                  size: 16, color: CustomColors.purple),
              context.horizontalSpace(6),
              Text(
                'Slot: ${widget.timeSlot}',
                style: context.fonts.black13w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPractitionersSection(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assigned Practitioners', style: context.fonts.black14w600),
          context.verticalSpace(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.practitioners.map((p) {
              return Container(
                padding: context.appEdgeInsets(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomColors.purple.withValues(alpha: 0.08),
                  borderRadius: context.appBorderRadius(all: 8),
                  border: Border.all(
                    color: CustomColors.purple.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person,
                        size: 14, color: CustomColors.purple),
                    context.horizontalSpace(6),
                    Text(
                      '${p['name']} (${p['role']})',
                      style: context.fonts.black12w600,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentsSection(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatments & Services', style: context.fonts.black14w600),
          context.verticalSpace(10),
          ...widget.treatments.map((t) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.treatmentName +
                              (t.areaName != null ? ' - ${t.areaName}' : ''),
                          style: context.fonts.black13w600,
                        ),
                        if (t.sessionName != null || t.materialName != null) ...[
                          context.verticalSpace(2),
                          Text(
                            [
                              if (t.sessionName != null)
                                'Session: ${t.sessionName}',
                              if (t.materialName != null)
                                'Material: ${t.materialName}${t.materialQty != null ? ' [Qty: ${t.materialQty}]' : ''}',
                            ].join(' | '),
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    '\$${t.treatmentCost.toStringAsFixed(2)}',
                    style: context.fonts.black13w600,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFinancialSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.whiteGrey,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 16),
            child: Column(
              children: [
                _summaryRow(
                  context,
                  'Treatment Total',
                  '\$${widget.treatmentTotal.toStringAsFixed(2)}',
                ),
                context.verticalSpace(8),
                _summaryRow(
                  context,
                  'Discount (${widget.discountType.toUpperCase()})',
                  '-\$${widget.discountAmount.toStringAsFixed(2)}',
                ),
                context.verticalSpace(8),
                _summaryRow(
                  context,
                  'Amount Paid',
                  '\$${widget.amountPaid.toStringAsFixed(2)}',
                ),
                context.verticalSpace(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment Details', style: context.fonts.grey12w400),
                    Text(
                      '${widget.paymentType.toUpperCase()} | ${widget.paymentStatus.toUpperCase()}',
                      style: context.fonts.black12w600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CustomColors.purple,
              borderRadius: context.appBorderRadius(
                bottomLeft: 12,
                bottomRight: 12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining Payable',
                  style: context.fonts.white14w600,
                ),
                Text(
                  '\$${widget.remainingPayable.toStringAsFixed(2)}',
                  style: context.fonts.white14w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationsSection(BuildContext context) {
    final nonNullSimulations = Map<String, String>.from(widget.simulations)
      ..removeWhere((k, v) => v.isEmpty);

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attached Simulations', style: context.fonts.black14w600),
          context.verticalSpace(8),
          ...nonNullSimulations.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text('${e.key}: ', style: context.fonts.grey12w500),
                  Expanded(
                    child: Text(
                      e.value,
                      style: context.fonts.purple11w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.fonts.grey13w500),
        Text(value, style: context.fonts.black13w600),
      ],
    );
  }
}
