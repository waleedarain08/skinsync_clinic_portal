import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../models/requests/create_appointment_request.dart';
import '../../models/responses/patient_treatment_request_response.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_creation_view_model.dart';
import '../borderd_container_widget.dart';
import '../build_textfield.dart';
import '../custom_primary_button.dart';

class CreateAppointmentFromChatDialog extends ConsumerStatefulWidget {
  final PatientTreatmentRequestData? treatmentRequestData;

  const CreateAppointmentFromChatDialog({
    super.key,
    this.treatmentRequestData,
  });

  @override
  ConsumerState<CreateAppointmentFromChatDialog> createState() =>
      _CreateAppointmentFromChatDialogState();
}

class _CreateAppointmentFromChatDialogState
    extends ConsumerState<CreateAppointmentFromChatDialog> {
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  String _selectedTimeSlot = '10:00 AM';
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:30 AM',
    '01:30 PM',
    '03:00 PM',
    '04:30 PM',
  ];

  String _paymentType = 'cash';
  final List<String> _paymentTypes = ['cash', 'card', 'stripe'];
  String _paymentStatus = 'pending';
  final List<String> _paymentStatuses = ['pending', 'completed'];
  String _discountType = 'flat';
  final List<String> _discountTypes = ['flat', 'percentage'];
  final _discountController = TextEditingController(text: '0');
  final _amountPaidController = TextEditingController(text: '0');

  @override
  void dispose() {
    _dateController.dispose();
    _discountController.dispose();
    _amountPaidController.dispose();
    super.dispose();
  }

  double get _calculatedTotal {
    double total = 0.0;
    if (widget.treatmentRequestData?.treatments != null) {
      for (var t in widget.treatmentRequestData!.treatments) {
        for (var a in t.areas) {
          total += a.price ?? 0.0;
        }
      }
    }
    return total > 0 ? total : 250.0;
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.treatmentRequestData;
    final patientName = req?.patientName ?? 'Patient';
    final patientEmail = req?.patientEmail ?? 'N/A';
    final totalCost = _calculatedTotal;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.w(20),
        vertical: context.h(24),
      ),
      child: Container(
        width: context.w(600),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(context.w(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(context.w(10)),
                        decoration: const BoxDecoration(
                          color: CustomColors.lightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          color: CustomColors.purple,
                          size: context.sp(20),
                        ),
                      ),
                      context.horizontalSpace(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Appointment from Request',
                            style: context.fonts.black16w700,
                          ),
                          context.verticalSpace(2),
                          Text(
                            'Patient: $patientName',
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: CustomColors.border),

            // Content Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.w(20)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Summary Card
                      BorderdContainerWidget(
                        padding: EdgeInsets.all(context.w(14)),
                        backgroundColor: CustomColors.softGrey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient Details',
                              style: context.fonts.black14w600,
                            ),
                            context.verticalSpace(6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name: $patientName',
                                  style: context.fonts.grey13w500,
                                ),
                                Text(
                                  'Email: $patientEmail',
                                  style: context.fonts.grey13w500,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      context.verticalSpace(16),

                      // Treatments Summary
                      Text(
                        'Requested Treatments & Areas:',
                        style: context.fonts.black14w600,
                      ),
                      context.verticalSpace(8),
                      if (req != null && req.treatments.isNotEmpty)
                        ...req.treatments.map(
                          (t) => Container(
                            margin: EdgeInsets.only(bottom: context.h(8)),
                            padding: EdgeInsets.all(context.w(10)),
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomColors.border),
                              borderRadius: BorderRadius.circular(
                                context.r(8),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.treatmentName,
                                  style: context.fonts.purple13w700,
                                ),
                                context.verticalSpace(4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: t.areas
                                      .map(
                                        (a) => Chip(
                                          label: Text(
                                            '${a.areaName} (\$${a.price ?? 0})',
                                          ),
                                          backgroundColor:
                                              CustomColors.lightPurple,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Text(
                          'No specific treatments attached. Default service will be applied.',
                          style: context.fonts.grey12w400,
                        ),
                      context.verticalSpace(16),

                      // Date & Time Selection
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Date',
                              controller: _dateController,
                              hintText: 'YYYY-MM-DD',
                              readOnly: true,
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time Slot',
                                  style: context.fonts.black14w600,
                                ),
                                context.verticalSpace(8),
                                DropdownButtonFormField<String>(
                                  value: _selectedTimeSlot,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(8),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: _timeSlots.map((slot) {
                                    return DropdownMenuItem(
                                      value: slot,
                                      child: Text(slot),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedTimeSlot = val);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(16),

                      // Payment & Financials
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Type',
                                  style: context.fonts.black14w600,
                                ),
                                context.verticalSpace(8),
                                DropdownButtonFormField<String>(
                                  value: _paymentType,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(8),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: _paymentTypes.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type.toUpperCase()),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _paymentType = val);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Payment Status',
                                  style: context.fonts.black14w600,
                                ),
                                context.verticalSpace(8),
                                DropdownButtonFormField<String>(
                                  value: _paymentStatus,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(8),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: _paymentStatuses.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(status.toUpperCase()),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _paymentStatus = val);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(16),

                      // Financial summary
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Discount Type',
                                  style: context.fonts.black14w600,
                                ),
                                context.verticalSpace(8),
                                DropdownButtonFormField<String>(
                                  value: _discountType,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        context.r(8),
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  items: _discountTypes.map((dt) {
                                    return DropdownMenuItem(
                                      value: dt,
                                      child: Text(dt.toUpperCase()),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _discountType = val);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: BuildTextField(
                              label: 'Discount Value',
                              controller: _discountController,
                              hintText: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: BuildTextField(
                              label: 'Amount Paid',
                              controller: _amountPaidController,
                              hintText: '0',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(20),

                      Text(
                        'Total Treatment Cost: \$${totalCost.toStringAsFixed(2)}',
                        style: context.fonts.purple14w700,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: CustomColors.border),

            // Footer Actions
            Padding(
              padding: EdgeInsets.all(context.w(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  context.horizontalSpace(12),
                  CustomPrimaryButton(
                    label: 'Create Appointment',
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;

                      final discount =
                          double.tryParse(_discountController.text) ?? 0.0;
                      final amountPaid =
                          double.tryParse(_amountPaidController.text) ?? 0.0;
                      final payable = totalCost - discount;

                      final request = CreateAppointmentRequest(
                        practitioners: [
                          AppointmentPractitionerRequest(id: 682, role: 'doctor'),
                        ],
                        patientId: req?.userId ?? req?.id ?? 42,
                        date: 1788739200,
                        startTime: 1725528000,
                        endTime: 1725531600,
                        appointmentTypeId: 1,
                        bookingType: 'walk-in',
                        simulations: AppointmentSimulationsRequest(
                          frontImageBefore: req?.frontImageBefore ??
                              'https://firebasestorage.googleapis.com/v0/b/skinsync-2aa8e.firebasestorage.app/o/production%2F42%2Ftreatment_option%2Ffront%2Fbefore%2Fcropped_1788790348482.jpg?alt=media&token=ca4dbb8f-30e9-42c3-aa80-40034f04d5a8',
                          frontImageAfter: req?.frontImageAfter ??
                              'https://firebasestorage.googleapis.com/v0/b/skinsync-2aa8e.firebasestorage.app/o/production%2F42%2Ftreatment_option%2Ffront%2Fafter%2Fai_front_1788790385314.jpg?alt=media&token=ca5e807c-be93-4e07-b49b-9ce108131332',
                          rightImageBefore: req?.rightImageBefore ??
                              'https://firebasestorage.googleapis.com/v0/b/skinsync-2aa8e.firebasestorage.app/o/production%2F42%2Ftreatment_option%2Fbefore%2Fright%2Fcropped_1788790364564.jpg?alt=media&token=9409ca66-d444-48bb-b9ff-4e9b8309b20d',
                          rightImageAfter: req?.rightImageAfter ??
                              'https://firebasestorage.googleapis.com/v0/b/skinsync-2aa8e.firebasestorage.app/o/production%2F42%2Ftreatment_option%2Fafter%2Fright%2Fai_right_1788790385314.jpg?alt=media&token=e974bb41-03e4-4eba-b4cc-8ec7e1b11b8e',
                          leftImageBefore: req?.leftImageBefore ??
                              'https://firebasestorage.googleapis.com/v0/b/skinsync-2aa8e.firebasestorage.app/o/production%2F42%2Ftreatment_option%2Fbefore%2Fleft%2Fcropped_1788790355506.jpg?alt=media&token=df88fced-8828-425d-baf5-fd9c9bcf27cd',
                          leftImageAfter: req?.leftImageAfter ??
                              'https://firebasestorage.googleapis.com/v0/b/skinsync-2aa8e.firebasestorage.app/o/production%2F42%2Ftreatment_option%2Fafter%2Fleft%2Fai_left_1788790385314.jpg?alt=media&token=640055ab-49bd-4e3e-9dd7-a35f83c6bba5',
                        ),
                        treatment: req != null && req.treatments.isNotEmpty
                            ? req.treatments.expand((t) {
                                return t.areas.map(
                                  (a) => AppointmentTreatmentItemRequest(
                                    treatmentId: t.treatmentId,
                                    areaId: a.areaId,
                                    treatmentCost: a.price ?? 850.00,
                                    material: AppointmentMaterialItemRequest(
                                      id: 0,
                                      selectedQuantity: 1,
                                    ),
                                  ),
                                );
                              }).toList()
                            : [
                                AppointmentTreatmentItemRequest(
                                  treatmentId: 23,
                                  areaId: 27,
                                  treatmentCost: 850.00,
                                  material: AppointmentMaterialItemRequest(
                                    id: 0,
                                    selectedQuantity: 1,
                                  ),
                                ),
                              ],
                        treatmentTotal: totalCost > 0 ? totalCost : 850.00,
                        paymentType: AppointmentPaymentTypeRequest(
                          type: _paymentType,
                          status: _paymentStatus,
                        ),
                        discountType: _discountType,
                        discount: discount,
                        amountPaid: amountPaid,
                        payable: payable,
                      );

                      EasyLoading.show(status: 'Creating appointment...');
                      final success = await ref
                          .read(appointmentCreationProvider.notifier)
                          .createAppointment(request: request);
                      EasyLoading.dismiss();

                      if (success) {
                        EasyLoading.showSuccess(
                          'Appointment created successfully',
                        );
                        if (context.mounted) {
                          context.pop();
                        }
                      } else {
                        EasyLoading.showError('Failed to create appointment');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
