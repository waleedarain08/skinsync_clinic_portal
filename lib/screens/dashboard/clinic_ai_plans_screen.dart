import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/subscription_plan_model.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../view_models/subscription_view_model.dart';
import '../../widgets/borderd_container_widget.dart';

class ClinicAiPlansScreen extends ConsumerStatefulWidget {
  const ClinicAiPlansScreen({super.key});

  static const String routeName = '/dashboard/ai-plans';

  @override
  ConsumerState<ClinicAiPlansScreen> createState() =>
      _ClinicAiPlansScreenState();
}

class _ClinicAiPlansScreenState extends ConsumerState<ClinicAiPlansScreen> {
  String? selectedPlanId;

  Future<void> _handleUpgrade(ClinicSubscriptionPlanModel plan) async {
    String? durationId;

    if (plan.durationOptions == null || plan.durationOptions!.isEmpty) {
      durationId = null;
    } else if (plan.durationOptions!.length == 1) {
      durationId = plan.durationOptions!.first.id;
    } else {
      durationId = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: CustomColors.white,
            surfaceTintColor: Colors.transparent,
            title: Text(
              "Select Duration Option",
              style: context.fonts.black18w600,
            ),
            content: SizedBox(
              width: context.w(400),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: plan.durationOptions!.length,
                separatorBuilder: (_, __) => const Divider(color: CustomColors.border),
                itemBuilder: (context, index) {
                  final option = plan.durationOptions![index];
                  final intervalName = option.interval ?? 'Option';
                  final priceAmount = option.amount ?? 0.0;
                  return ListTile(
                    title: Text(
                      intervalName.toUpperCase(),
                      style: context.fonts.black16w400,
                    ),
                    trailing: Text(
                      "\$$priceAmount",
                      style: context.fonts.black16w600.copyWith(
                        color: CustomColors.purple,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop(option.id);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: CustomColors.grey),
                ),
              ),
            ],
          );
        },
      );

      if (durationId == null) {
        return; // User canceled the option selection dialog
      }
    }

    final stripeUrl = await ref
        .read(subscriptionViewModelProvider.notifier)
        .subscribeToPlan(
          planId: plan.id!,
          durationId: durationId,
        );
    if (stripeUrl != null) {
      html.window.location.href = stripeUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionViewModelProvider);
    final currentPlanData = subState.currentPlanData;

    if (currentPlanData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: CustomColors.purple,
          ),
        ),
      );
    }

    final plans = currentPlanData.plans ?? [];
    final currentPlanDetails = currentPlanData.currentPlan;

    return SingleChildScrollView(
      padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subscription Plans",
            style: context.fonts.level1Heading,
          ),
          context.verticalSpace(6),
          Text(
            "Upgrade your clinic with AI capabilities and advanced management tools.",
            style: context.fonts.grey13w500,
          ),
          context.verticalSpace(32),
          if (plans.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "No subscription plans available at the moment.",
                style: context.fonts.black14w400,
              ),
            )
          else
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: plans.map((plan) {
                final isCurrentPlan = currentPlanDetails?.planId == plan.id;
                final isSelected = plan.id == (selectedPlanId ?? currentPlanDetails?.planId);
                
                double displayPrice = 0.0;
                String intervalName = 'month';

                if (plan.durationOptions != null && plan.durationOptions!.isNotEmpty) {
                  final firstDuration = plan.durationOptions!.first;
                  displayPrice = firstDuration.amount ?? 0.0;
                  intervalName = firstDuration.interval ?? 'month';
                } else {
                  displayPrice = plan.basePrice ?? 199.99;
                }

                return SizedBox(
                  width: context.isDesktop ? context.w(300) : double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlanId = plan.id;
                      });
                    },
                    child: BorderdContainerWidget(
                      height: context.isDesktop ? context.h(580) : null,
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
                              if (isCurrentPlan)
                                const ContainerBadge(text: "Active")
                              else if (isSelected)
                                const Icon(
                                  Iconsax.tick_circle5,
                                  color: CustomColors.purple,
                                ),
                            ],
                          ),
                          context.verticalSpace(12),
                          Text(
                            displayPrice == 0 ? "Free" : "\$$displayPrice/$intervalName",
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
                          _buildDetailRow(
                            context,
                            "Dynamic Booking Fee: ${plan.dynamicBookingCommissionPercent}%",
                          ),
                          _buildDetailRow(
                            context,
                            "Technology Fee: \$$themeTechnologyFee",
                          ),
                          if (plan.benefits != null)
                            ...plan.benefits!
                                .map((b) => _buildDetailRow(context, b.title ?? b.description ?? '')),
                          const Spacer(),
                          context.verticalSpace(24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isCurrentPlan
                                  ? null
                                  : () async {
                                      setState(() {
                                        selectedPlanId = plan.id;
                                      });
                                      await _handleUpgrade(plan);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCurrentPlan
                                    ? CustomColors.grey
                                    : isSelected
                                        ? CustomColors.purple
                                        : CustomColors.softGrey,
                                foregroundColor: isCurrentPlan
                                    ? CustomColors.white
                                    : isSelected
                                        ? CustomColors.white
                                        : CustomColors.grey,
                              ),
                              child: Text(
                                isCurrentPlan ? "Current Plan" : "Upgrade Plan",
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

  double get themeTechnologyFee => 2.5;

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

class ContainerBadge extends StatelessWidget {
  final String text;
  const ContainerBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomColors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: CustomColors.purple,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
