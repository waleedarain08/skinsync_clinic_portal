import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../view_models/auth_view_model.dart';
import 'patient_treatment_request_widget.dart';

class TreatmentRequestRowWidget extends ConsumerWidget {
  const TreatmentRequestRowWidget({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final treatmentList = ref.watch(authViewModelProvider).dashboard?.todayTreatmentRequest ?? [];
    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(150),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(
        treatmentList.length,
        (index) {
          return PatientTreatmentRequestCard(
            data: treatmentList[index],
          );
        },
      ),
    );
  }
}