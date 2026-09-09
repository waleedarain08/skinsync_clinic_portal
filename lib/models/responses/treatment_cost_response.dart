import 'base_response_model.dart';

class TreatmentCostResponse extends BaseApiResponseModel<TreatmentCostData> {
  const TreatmentCostResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory TreatmentCostResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentCostResponse(
        success: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : TreatmentCostData.fromJson(json['data'] as Map<String, dynamic>),
      );
}

class TreatmentCostData {
  final num treatmentCost;

  TreatmentCostData({
    required this.treatmentCost,
  });

  factory TreatmentCostData.fromJson(Map<String, dynamic> json) {
    return TreatmentCostData(
      treatmentCost: (json['treatment_cost'] as num?) ?? 0,
    );
  }
}
