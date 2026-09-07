import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'borderd_container_widget.dart';

class TreatmentHistoryItem {
  final String treatmentName;
  final String treatedArea;
  final String materialUsed;
  final String date;
  final String generalNotes;
  final String treatmentNotes;
  final String intakeDoc;
  final String consentsDoc;
  final String carePlan;
  final String billingInfo;

  TreatmentHistoryItem({
    required this.treatmentName,
    required this.treatedArea,
    required this.materialUsed,
    required this.date,
    required this.generalNotes,
    required this.treatmentNotes,
    required this.intakeDoc,
    required this.consentsDoc,
    required this.carePlan,
    required this.billingInfo,
  });
}

class PatientTreatmentHistoryWidget extends StatelessWidget {
  const PatientTreatmentHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TreatmentHistoryItem> history = [
      TreatmentHistoryItem(
        treatmentName: 'Advanced Botox Rejuvenation',
        treatedArea: 'Forehead & Glabella',
        materialUsed: 'Botox Cosmetic 50U',
        date: 'Oct 12, 2025',
        generalNotes:
            'Patient presented with dynamic glabellar lines and mild forehead creases.',
        treatmentNotes:
            'Injected 20U total. Distributed evenly across 5 sites. Tolerated well.',
        intakeDoc: 'Intake_Form_Oct2025.pdf (Verified)',
        consentsDoc: 'Signed Consent & Risk Acknowledgment (Form #C-881)',
        carePlan: 'Avoid lying down for 4 hours, no strenuous exercise for 24h.',
        billingInfo: 'Invoice #INV-4920 - Paid \$450.00 (Credit Card)',
      ),
      TreatmentHistoryItem(
        treatmentName: 'Hyaluronic Acid Dermal Filler',
        treatedArea: 'Nasolabial Folds & Lips',
        materialUsed: 'Juvederm Ultra XC (1.0 mL)',
        date: 'Sep 04, 2025',
        generalNotes:
            'Patient requested subtle lip volume enhancement and fold smoothing.',
        treatmentNotes:
            'Cannula technique used for nasolabial folds; needle for lips. Ice pack applied.',
        intakeDoc: 'Intake_Form_Sep2025.pdf (Verified)',
        consentsDoc: 'Filler Consent Form (Form #C-712)',
        carePlan:
            'Apply cold compress for swelling, avoid extreme heat for 48h.',
        billingInfo: 'Invoice #INV-4412 - Paid \$750.00 (Stripe)',
      ),
    ];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.history_edu_rounded,
                color: CustomColors.purple,
                size: 22,
              ),
              context.horizontalSpace(10),
              Text('Treatment History', style: context.fonts.subHeading),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          ...history.map(
            (item) => Container(
              margin: EdgeInsets.only(bottom: context.h(16)),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.border),
                borderRadius: BorderRadius.circular(context.r(16)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(16)),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.r(16)),
                ),
                tilePadding: EdgeInsets.symmetric(
                  horizontal: context.w(20),
                  vertical: context.h(8),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    color: CustomColors.purple,
                    size: 20,
                  ),
                ),
                title: Text(
                  item.treatmentName,
                  style: context.fonts.black14w600,
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: context.h(4)),
                  child: Text(
                    'Area: ${item.treatedArea}  •  Date: ${item.date}',
                    style: context.fonts.grey12w400,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.lightPurple,
                    borderRadius: BorderRadius.circular(context.r(16)),
                    border: Border.all(
                      color: CustomColors.purple.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    item.materialUsed,
                    style: context.fonts.purple12w700,
                  ),
                ),
                childrenPadding: EdgeInsets.symmetric(
                  horizontal: context.w(24),
                  vertical: context.h(20),
                ),
                children: [
                  const Divider(color: CustomColors.border, height: 1),
                  context.verticalSpace(16),
                  // Medical Information Section
                  _buildSectionHeader(
                    context,
                    Icons.healing_outlined,
                    'Medical Information',
                  ),
                  context.verticalSpace(12),
                  _infoRow(context, 'General Notes', item.generalNotes),
                  _infoRow(context, 'Treatment Notes', item.treatmentNotes),
                  context.verticalSpace(20),
                  // Documents Section
                  _buildSectionHeader(
                    context,
                    Icons.folder_shared_outlined,
                    'Documents & Financials',
                  ),
                  context.verticalSpace(12),
                  _infoRow(
                    context,
                    'Patient Intake & Background',
                    item.intakeDoc,
                  ),
                  _infoRow(context, 'Consents & Formals', item.consentsDoc),
                  _infoRow(context, 'Care Plan Instructions', item.carePlan),
                  _infoRow(context, 'Billing & Financials', item.billingInfo),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: CustomColors.purple),
        context.horizontalSpace(8),
        Text(
          title,
          style: context.fonts.black14w600.copyWith(color: CustomColors.purple),
        ),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.w(200),
            child: Text(label, style: context.fonts.grey12w400),
          ),
          Expanded(
            child: Text(value, style: context.fonts.black14w400),
          ),
        ],
      ),
    );
  }
}
