import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../view_models/auth_view_model.dart';
import 'treatment_container.dart';

class TreatmentListWidget extends ConsumerWidget {
  const TreatmentListWidget({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
      final treatmentList = ref.watch(authViewModelProvider).dashboard?.treatments ?? [];

    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(268),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(
        treatmentList.length,
        (index) {
          return TreatmentContainer(
            treatment: treatmentList[index],
          );
        },
      ),
    );
  }
}