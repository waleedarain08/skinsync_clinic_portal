import 'package:flutter/material.dart';

import '../models/responses/login_response_model.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import 'patient_treatment_request_widget.dart';

class TreatmentRequestRowWidget extends StatelessWidget {
  const TreatmentRequestRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RequestClinicTreatmentModel> treatmentRequests = [
      RequestClinicTreatmentModel(
        id: 1,
        patientName: 'John Doe',
        patientEmail: 'john.doe@gmail.com',
        image: 'https://i.pravatar.cc/150?img=12',
        totalTreatmentCount: 3,
      ),
      RequestClinicTreatmentModel(
        id: 2,
        patientName: 'Sarah Wilson',
        patientEmail: 'sarah.wilson@gmail.com',
        image: 'https://i.pravatar.cc/150?img=47',
        totalTreatmentCount: 2,
      ),
      RequestClinicTreatmentModel(
        id: 3,
        patientName: 'Michael Smith',
        patientEmail: 'michael.smith@gmail.com',
        image: 'https://i.pravatar.cc/150?img=11',
        totalTreatmentCount: 5,
      ),
      RequestClinicTreatmentModel(
        id: 4,
        patientName: 'Emily Johnson',
        patientEmail: 'emily.johnson@gmail.com',
        image: 'https://i.pravatar.cc/150?img=32',
        totalTreatmentCount: 1,
      ),
      RequestClinicTreatmentModel(
        id: 5,
        patientName: 'David Brown',
        patientEmail: 'david.brown@gmail.com',
        image: 'https://i.pravatar.cc/150?img=13',
        totalTreatmentCount: 4,
      ),
    ];

    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(150),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(
        treatmentRequests.length,
        (index) {
          return PatientTreatmentRequestCard(
            data: treatmentRequests[index],
          );
        },
      ),
    );
  }
}