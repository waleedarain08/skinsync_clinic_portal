import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

class PatientTreatmentSelectionTile extends StatelessWidget {
  final VoidCallback? onTap;
  const PatientTreatmentSelectionTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(15)),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(15)),
          border: Border.all(color: CustomColors.border),
        ),
        child: Row(
          children: [
            Container(
              height: context.w(80),
              width: context.w(88),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(10)),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(PngAssets.treatmentImage),
                ),
              ),
            ),
            SizedBox(width: context.w(15)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sarah Johnson", style: CustomFonts.black18w600),
                  SizedBox(height: context.h(4)),
                  Text(
                    "sarah.johnson@email.com",
                    style: CustomFonts.grey14w400,
                  ),
                  SizedBox(height: context.h(8)),
                  Text("8 Sessions", style: CustomFonts.grey14w600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
