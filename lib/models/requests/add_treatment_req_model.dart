import '../treatment_model.dart';
import 'base_request.dart';

class AddTreatmentReqModel extends BaseRequest {
  final int treatmentId;
  final double treatmentPrice;
  final List<SideAreaModel> sideareas;

  AddTreatmentReqModel({
    required this.treatmentId,
    required this.sideareas,
    required this.treatmentPrice,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'treatment_price': treatmentPrice,
      'side_area': sideareas
          .map(
            (area) => {'side_area_id': area.id, 'price': area.perSyringePrice},
          )
          .toList(),
    };
  }
}
