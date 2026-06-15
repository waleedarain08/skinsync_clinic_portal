import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../screens/dashboard/patient_management_detail.dart';
import '../utils/assets.dart';

import '../utils/theme.dart';

class TreatmentContainer extends StatelessWidget {
  const TreatmentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(PatientManagementDetailScreen.routeName);
      },
      child: Container(
        padding: EdgeInsets.all(context.w(15)),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(context.r(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.r(15)),
              child: Image.asset(
                PngAssets.treatmentImage,
                height: context.h(248),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: context.h(19)),
            Text(
              "Botox - Forehead",
              style: CustomFonts.grey18w400.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.h(19)),
            Text("Provider: Dr. Smith", style: CustomFonts.grey14w500),
            SizedBox(height: context.h(9)),
            Text("Oct 29, 2025", style: CustomFonts.grey14w500),
          ],
        ),
      ),
    );
  }
}
