import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'patient_management.dart';
import '../../utils/theme.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/patient_mangement_widget.dart';

class PatientManagementDetailScreen extends StatelessWidget {
  static const String path = 'details';
  static const String routeName =
      '${PatientManagementScreen.routeName}/details';
  const PatientManagementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.screenWidth > 1200;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Patient EHR Profile', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: CustomColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.w(isDesktop ? 800 : 900),
            ),
            child: const PatientMangementWidget(),
          ),
        ),
      ),
    );
  }
}
