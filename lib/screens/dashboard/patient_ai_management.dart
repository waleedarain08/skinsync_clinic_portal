import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';
import 'package:skinsync_clinic_portal/widgets/patient_mangement_widget.dart';
import 'package:skinsync_clinic_portal/widgets/patient_selection_tile.dart';

import '../../utils/theme.dart';

class PatientAiManagementScreen extends StatefulWidget {
  static const String routeName = '/patient-ai-management';
  const PatientAiManagementScreen({super.key});

  @override
  State<PatientAiManagementScreen> createState() =>
      _PatientAiManagementScreenState();
}

class _PatientAiManagementScreenState extends State<PatientAiManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(20)),
            Text('Patient Management', style: context.fonts.black20w600),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(50)),
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
      width: context.w(386),
      child: Column(
        children: [
          const CupertinoSearchTextField(backgroundColor: CustomColors.softGrey),
          SizedBox(height: context.h(20)),
          ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: context.h(12)),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return const PatientSelectionTile(
                title: "Sarah Johnson",
                subTitle: "sarah.johnson@email.com",
              );
            },
          ),
        ],
      ),
    );
  }
}
