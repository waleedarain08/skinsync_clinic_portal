class TreatmentDetail {
  final int? treatmentId;
  final String? treatmentName;
  final int? areaId;
  final String? areaName;
  final double? treatmentCost;
  final MaterialDetail? material;

  TreatmentDetail({
    this.treatmentId,
    this.treatmentName,
    this.areaId,
    this.areaName,
    this.treatmentCost,
    this.material,
  });

  factory TreatmentDetail.fromJson(Map<String, dynamic> json) => TreatmentDetail(
        treatmentId: json["treatment_id"],
        treatmentName: json["treatment_name"],
        areaId: json["area_id"],
        areaName: json["area_name"],
        treatmentCost: json["treatment_cost"]?.toDouble(),
        material: json["material"] == null
            ? null
            : MaterialDetail.fromJson(json["material"]),
      );

  Map<String, dynamic> toJson() => {
        "treatment_id": treatmentId,
        "treatment_name": treatmentName,
        "area_id": areaId,
        "area_name": areaName,
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
  final int? selectedQuantity;

  MaterialDetail({
    this.id,
    this.selectedQuantity,
  });

  factory MaterialDetail.fromJson(Map<String, dynamic> json) => MaterialDetail(
        id: json["id"],
        selectedQuantity: json["selected_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "selected_quantity": selectedQuantity,
      };
}
