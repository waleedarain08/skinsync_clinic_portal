import 'package:flutter/material.dart';
import '../patient_mangement_widget.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class PatientDetailDailog extends StatelessWidget {
  const PatientDetailDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Patient Profile",
      width: 700.w, // Max width for complex detail view
      content: const Expanded(
        child: SingleChildScrollView(child: PatientMangementWidget()),
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.pop(context),
          label: "Cancel",
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context),
          label: "Continue",
          width: 120.w,
        ),
      ],
    );
  }
}
