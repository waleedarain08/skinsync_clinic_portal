import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import 'patient_treatment_request_widget.dart';

class TreatmentRequestRowWidget extends StatelessWidget {
  const TreatmentRequestRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
 final List<PatientTreatmentRequestListModel> treatmentRequests = [
  PatientTreatmentRequestListModel(
    id: 1,
    treatmentName: 'Botox Treatment',
    areaNames: [
      'Forehead',
      'Crow Feet',
    ],
    requestDate: 'October 20, 2023',
  ),
  PatientTreatmentRequestListModel(
    id: 2,
    treatmentName: 'Laser Treatment',
    areaNames: [
      'Full Face',
    ],
    requestDate: 'October 21, 2023',
  ),
  PatientTreatmentRequestListModel(
    id: 3,
    treatmentName: 'Chemical Peel',
    areaNames: [
      'Face',
      'Neck',
    ],
    requestDate: 'October 22, 2023',
  ),
  PatientTreatmentRequestListModel(
    id: 4,
    treatmentName: 'Dermal Fillers',
    areaNames: [
      'Lips',
      'Cheeks',
    ],
    requestDate: 'October 23, 2023',
  ),
  PatientTreatmentRequestListModel(
    id: 5,
    treatmentName: 'Microneedling',
    areaNames: [
      'Face',
    ],
    requestDate: 'October 24, 2023',
  ),
];
    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(150),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(treatmentRequests.length, (index) {
        return PatientTreatmentRequestCard(
        data:  treatmentRequests[index],
        );
      }),
    );
  }
}
class PatientTreatmentRequestListModel {
  final int id;
  final String treatmentName;
  final List<String> areaNames;
  final String? requestDate;

  PatientTreatmentRequestListModel({
    required this.id,
    required this.treatmentName,
    required this.areaNames,
    this.requestDate,
  });

  factory PatientTreatmentRequestListModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientTreatmentRequestListModel(
      id: json['id'] ?? 0,
      treatmentName: json['treatment_name'] ?? '',
      areaNames: json['areas'] != null
          ? (json['areas'] as List)
              .map((e) {
                if (e is String) return e;
                return e['name']?.toString() ?? '';
              })
              .where((name) => name.isNotEmpty)
              .toList()
          : [],
      requestDate: json['request_date'],
    );
  }
}