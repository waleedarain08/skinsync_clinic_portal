class TreatmentDetail {
  final int? treatmentId;
  final String? treatmentName;
  final int? areaId;
  final String? areaName;
  final String? sessionName;
  final double? treatmentCost;
  final MaterialDetail? material;

  TreatmentDetail({
    this.treatmentId,
    this.treatmentName,
    this.areaId,
    this.areaName,
    this.sessionName,
    this.treatmentCost,
    this.material,
  });

  factory TreatmentDetail.fromJson(Map<String, dynamic> json) => TreatmentDetail(
        treatmentId: json["treatment_id"] ?? json["id"],
        treatmentName: json["treatment_name"] ??
            json["name"] ??
            json["title"] ??
            (json["treatment"] is Map
                ? (json["treatment"]["name"] ?? json["treatment"]["title"])
                : null),
        areaId: json["area_id"] ??
            (json["area"] is Map ? json["area"]["id"] : null),
        areaName: json["area_name"] ??
            json["area_title"] ??
            (json["area"] is Map
                ? (json["area"]["name"] ?? json["area"]["title"])
                : null),
        sessionName: json["session_name"] ??
            (json["session"] is Map
                ? (json["session"]["session_name"] ?? json["session"]["name"])
                : null),
        treatmentCost:
            (json["treatment_cost"] ?? json["cost"] ?? json["price"])
                ?.toDouble(),
        material: json["material"] == null
            ? null
            : MaterialDetail.fromJson(
                json["material"] is Map ? json["material"] as Map<String, dynamic> : {}),
      );

  Map<String, dynamic> toJson() => {
        "treatment_id": treatmentId,
        "treatment_name": treatmentName,
        "area_id": areaId,
        "area_name": areaName,
        "session_name": sessionName,
        "treatment_cost": treatmentCost,
        "material": material?.toJson(),
      };

  String get formattedName {
    if (treatmentName == null || treatmentName!.isEmpty) return '';
    if (areaName != null && areaName!.isNotEmpty) {
      return '$treatmentName ($areaName)';
    }
    return treatmentName!;
  }
}

class MaterialDetail {
  final int? id;
  final String? materialName;
  final String? unitType;
  final int? selectedQuantity;

  MaterialDetail({
    this.id,
    this.materialName,
    this.unitType,
    this.selectedQuantity,
  });

  factory MaterialDetail.fromJson(Map<String, dynamic> json) => MaterialDetail(
        id: json["id"] ?? json["material_id"],
        materialName: json["material_name"] ??
            json["name"] ??
            json["unit_type"] ??
            json["unitType"],
        unitType: json["unit_type"] ?? json["unitType"],
        selectedQuantity: json["selected_quantity"] ??
            json["selectedQuantity"] ??
            json["quantity"] ??
            json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "material_name": materialName,
        "unit_type": unitType,
        "selected_quantity": selectedQuantity,
      };
}
