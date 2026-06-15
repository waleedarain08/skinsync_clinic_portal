import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'treatment_card_widget.dart';

class AppointmentsListWidget extends StatelessWidget {
  const AppointmentsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        'title': 'Botox Treatment',
        'date': 'October 20, 2023, 10:00 AM',
        'price': 'AED 240',
        'image': PngAssets.treatmentImage,
      },
      {
        'title': 'Laser Treatment',
        'date': 'October 20, 2023, 10:00 AM',
        'price': 'AED 240',
        'image': PngAssets.treatmentImage,
      },
      {
        'title': 'Chemical Peels',
        'date': 'October 20, 2023, 10:00 AM',
        'price': 'AED 240',
        'image': PngAssets.treatmentImage,
      },
    ];
    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(268),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(appointments.length, (index) {
        return TreatmentCardWidget(
          title: appointments[index]['title']!,
          date: appointments[index]['date']!,
          price: appointments[index]['price']!,
          image: appointments[index]['image']!,
        );
      }),
    );
  }
}
