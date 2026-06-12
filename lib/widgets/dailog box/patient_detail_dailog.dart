import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/widgets/patient_mangement_widget.dart';

import '../../utils/theme.dart';

class PatientDetailDailog extends StatelessWidget {
  const PatientDetailDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              children: [
                Text("Patient Profile", style: CustomFonts.black16w600),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: context.w(32),
                    width: context.w(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Icon(Icons.close, size: context.r(18), color: CustomColors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h(20)),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: const SingleChildScrollView(
                child: PatientMangementWidget(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: context.h(20)),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(12),
                          vertical: context.h(16),
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.black,
                          borderRadius: BorderRadius.circular(context.r(8)),
                        ),
                        child: Center(
                          child: Text(
                            "Continue",
                            style: CustomFonts.white14w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(15)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(12),
                          vertical: context.h(16),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: CustomColors.border),
                          borderRadius: BorderRadius.circular(context.r(8)),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: CustomFonts.black14w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
