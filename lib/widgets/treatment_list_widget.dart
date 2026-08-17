import 'package:flutter/material.dart';

import '../models/responses/login_response_model.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import 'treatment_container.dart';

class TreatmentListWidget extends StatelessWidget {
  const TreatmentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardTreatmentModel> treatments = [
      DashboardTreatmentModel(
        id: 1,
        name: 'Botox Treatment',
        shortDescription: 'Reduce fine lines and wrinkles.',
        image: 'https://via.placeholder.com/800x600',
        icon: 'https://via.placeholder.com/100',
        sku: 'BOT-001',
      ),
      DashboardTreatmentModel(
        id: 2,
        name: 'Laser Treatment',
        shortDescription: 'Rejuvenate and refresh your skin.',
        image: 'https://via.placeholder.com/800x600',
        icon: 'https://via.placeholder.com/100',
        sku: 'LAS-002',
      ),
      DashboardTreatmentModel(
        id: 3,
        name: 'Chemical Peels',
        shortDescription: 'Improve skin texture and tone.',
        image: 'https://via.placeholder.com/800x600',
        icon: 'https://via.placeholder.com/100',
        sku: 'PEE-003',
      ),
      DashboardTreatmentModel(
        id: 4,
        name: 'Dermal Fillers',
        shortDescription: 'Restore volume and enhance facial contours.',
        image: 'https://via.placeholder.com/800x600',
        icon: 'https://via.placeholder.com/100',
        sku: 'FIL-004',
      ),
      DashboardTreatmentModel(
        id: 5,
        name: 'Microneedling',
        shortDescription: 'Improve skin texture and reduce scars.',
        image: 'https://via.placeholder.com/800x600',
        icon: 'https://via.placeholder.com/100',
        sku: 'MIC-005',
      ),
    ];

    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(268),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(
        treatments.length,
        (index) {
          return TreatmentContainer(
            treatment: treatments[index],
          );
        },
      ),
    );
  }
}