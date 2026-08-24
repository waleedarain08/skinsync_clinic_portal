import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/subscription_plan_model.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../widgets/borderd_container_widget.dart';

class ClinicAiPlansScreen extends ConsumerStatefulWidget {
  const ClinicAiPlansScreen({super.key});

  static const String routeName = '/dashboard/ai-plans';

  @override
  ConsumerState<ClinicAiPlansScreen> createState() =>
      _ClinicAiPlansScreenState();
}

class _ClinicAiPlansScreenState extends ConsumerState<ClinicAiPlansScreen> {
  final List<ClinicSubscriptionPlanModel> dummyPlans = [
    ClinicSubscriptionPlanModel(
      id: 0,
      name: 'Free Plan',
      basePrice: 0.00,
      doctorSeats: 2,
      staffSeats: 5,
      standardBookingCommissionPercent: 12,
      dynamicBookingCommissionPercent: 18,
      technologyFeePerTreatment: 8,
      isActive: true,
      benefits: [
        PlanBenefit(title: 'Initial free access', enabled: true),
        PlanBenefit(title: 'Basic patient records', enabled: true),
      ],
    ),
    ClinicSubscriptionPlanModel(
      id: 1,
      name: 'Basic Plan',
      basePrice: 49.99,
      doctorSeats: 5,
      unlimitedDoctors: false,
      staffSeats: 10,
      unlimitedStaff: false,
      standardBookingCommissionPercent: 10,
      dynamicBookingCommissionPercent: 15,
      technologyFeePerTreatment: 5,
      isActive: true,
      benefits: [
        PlanBenefit(title: 'Patient records and treatment history', enabled: true),
        PlanBenefit(title: 'Automated invoices', enabled: true),
      ],
    ),
    ClinicSubscriptionPlanModel(
      id: 2,
      name: 'Premium Plan',
      basePrice: 149.99,
      doctorSeats: 0,
      unlimitedDoctors: true,
      staffSeats: 30,
      unlimitedStaff: false,
      standardBookingCommissionPercent: 8,
      dynamicBookingCommissionPercent: 12,
      technologyFeePerTreatment: 3,
      isActive: true,
      benefits: [
        PlanBenefit(title: 'AI consultation and treatment tools', enabled: true),
        PlanBenefit(title: 'Before/after simulations', enabled: true),
        PlanBenefit(title: 'Dynamic pricing system', enabled: true),
      ],
    ),
    ClinicSubscriptionPlanModel(
      id: 3,
      name: 'Gold Plan',
      basePrice: 299.99,
      doctorSeats: 0,
      unlimitedDoctors: true,
      staffSeats: 0,
      unlimitedStaff: true,
      standardBookingCommissionPercent: 5,
      dynamicBookingCommissionPercent: 10,
      technologyFeePerTreatment: 2,
      isActive: true,
      benefits: [
        PlanBenefit(title: 'Multi-user clinic access', enabled: true),
        PlanBenefit(title: 'Priority onboarding and support', enabled: true),
        PlanBenefit(title: 'Custom branding', enabled: true),
      ],
    ),
  ];

  int selectedPlanId = 0; // Free Plan selected by default

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.appEdgeInsets(all: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subscription Plans",
            style: context.fonts.black26w700,
          ),
          context.verticalSpace(8),
          Text(
            "Upgrade your clinic with AI capabilities and advanced management tools.",
            style: context.fonts.grey14w400,
          ),
          context.verticalSpace(32),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: dummyPlans.map((plan) {
              final isSelected = plan.id == selectedPlanId;
              return SizedBox(
                width: context.isDesktop ? context.w(300) : double.infinity,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlanId = plan.id!;
                    });
                  },
                  child: BorderdContainerWidget(
                    padding: context.appEdgeInsets(all: 24),
                    backgroundColor: isSelected
                        ? CustomColors.purple.withValues(alpha: 0.05)
                        : CustomColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                plan.name ?? '',
                                style: context.fonts.black18w600.copyWith(
                                  color: isSelected
                                      ? CustomColors.purple
                                      : CustomColors.black,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Iconsax.tick_circle5,
                                color: CustomColors.purple,
                              ),
                          ],
                        ),
                        context.verticalSpace(12),
                        Text(
                          plan.basePrice == 0
                              ? "Free"
                              : "\$${plan.basePrice}/month",
                          style: context.fonts.black20w600.copyWith(
                            color: isSelected
                                ? CustomColors.purple
                                : CustomColors.black,
                          ),
                        ),
                        const Divider(height: 32, color: CustomColors.border),
                        _buildDetailRow(
                          context,
                          "Doctors: ${plan.unlimitedDoctors ? 'Unlimited' : plan.doctorSeats}",
                        ),
                        _buildDetailRow(
                          context,
                          "Staff: ${plan.unlimitedStaff ? 'Unlimited' : plan.staffSeats}",
                        ),
                        _buildDetailRow(
                          context,
                          "Booking Fee: ${plan.standardBookingCommissionPercent}%",
                        ),
                        if (plan.benefits != null)
                          ...plan.benefits!
                              .where((b) => b.enabled)
                              .map((b) => _buildDetailRow(context, b.title ?? '')),
                        context.verticalSpace(24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedPlanId = plan.id!;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? CustomColors.purple
                                  : CustomColors.softGrey,
                              foregroundColor: isSelected
                                  ? CustomColors.white
                                  : CustomColors.grey,
                            ),
                            child: Text(
                              isSelected ? "Current Plan" : "Upgrade Plan",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 16,
            color: CustomColors.purple,
          ),
          context.horizontalSpace(12),
          Expanded(
            child: Text(
              text,
              style: context.fonts.black14w400,
            ),
          ),
        ],
      ),
    );
  }
}
