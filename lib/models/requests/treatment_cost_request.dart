import 'base_request.dart';

class TreatmentCostRequest extends BaseRequest {
  final int treatmentId;
  final int areaId;
  final int sessionId;
  final List<TreatmentCostMaterialRequest> material;

  TreatmentCostRequest({
    required this.treatmentId,
    required this.areaId,
    required this.sessionId,
    required this.material,
  });

  @override
  Map<String, dynamic> toJson() => {
        'treatment_id': treatmentId,
        'area_id': areaId,
        'session_id': sessionId,
        'material': material.map((e) => e.toJson()).toList(),
      };
}

class TreatmentCostMaterialRequest {
  final int id;
  final int selectedQuantity;

  TreatmentCostMaterialRequest({
    required this.id,
    required this.selectedQuantity,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'selected_quantity': selectedQuantity,
      };
}
