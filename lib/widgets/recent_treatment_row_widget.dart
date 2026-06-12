import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'recent_treatment_card_widget.dart';

class RecentTreatmentRowWidget extends StatelessWidget {
  const RecentTreatmentRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        'title': 'Botox Treatment',
        'date': 'October 20, 2023, 10:00 AM',
        'image': PngAssets.treatmentImage,
        'nextAppointment': 'Next appointment in 4 hours',
      },
      {
        'title': 'Laser Treatment',
        'date': 'October 20, 2023, 10:00 AM',
        'image': PngAssets.treatmentImage,
        'nextAppointment': 'Next appointment in 4 hours',
      },
      {
        'title': 'Chemical Peels',
        'date': 'October 20, 2023, 10:00 AM',
        'image': PngAssets.treatmentImage,
        'nextAppointment': 'Next appointment in 4 hours',
      },
    ];

    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(268),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(appointments.length, (index) {
        return RecentTreatmentCardWidget(
          title: appointments[index]['title']!,
          date: appointments[index]['date']!,
          image: appointments[index]['image']!,
          nextAppointment: appointments[index]['nextAppointment']!,
        );
      }),
    );
  }
}
