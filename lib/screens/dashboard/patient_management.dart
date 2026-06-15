import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/responsive.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/patient_mangement_widget.dart';
import '../../widgets/patient_selection_tile.dart';

import '../../utils/theme.dart';

class PatientManagementScreen extends StatefulWidget {
  static const String routeName = '/patient-management';
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() =>
      _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(28),
          vertical: context.h(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Management', style: CustomFonts.black26w700),
            SizedBox(height: context.h(16)),
            const Divider(color: CustomColors.border, thickness: 1),
            SizedBox(height: context.h(32)),
            context.isLandscape
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      patientSelection(context),
                      SizedBox(width: context.w(24)),
                      const Expanded(
                        child: PatientMangementWidget(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      patientSelection(context),
                      SizedBox(height: context.h(24)),
                      const PatientMangementWidget(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget patientSelection(BuildContext context) {
    return SizedBox(
      width: context.isLandscape ? context.w(386) : double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoSearchTextField(
            backgroundColor: CustomColors.softGrey,
            padding: EdgeInsets.symmetric(
              horizontal: context.w(12),
              vertical: context.h(12),
            ),
            placeholderStyle: CustomFonts.grey14w400,
          ),
          SizedBox(height: context.h(20)),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: context.h(12)),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return PatientSelectionTile(
                title: "Sarah Johnson",
                subTitle: "sarah.johnson@email.com",
                isSelected: index == 0,
              );
            },
          ),
        ],
      ),
    );
  }
}
