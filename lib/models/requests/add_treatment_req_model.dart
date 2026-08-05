import 'base_request.dart';

class AddTreatmentReqModel extends BaseRequest {
  final List<Treatment>? treatments;

  AddTreatmentReqModel({this.treatments});

  @override
  Map<String, dynamic> toJson() => {
    "treatments": treatments == null
        ? []
        : List<dynamic>.from(treatments!.map((x) => x.toJson())),
  };
}

class Treatment {
  final int? treatmentId;
  final List<int>? areasId;

  Treatment({this.treatmentId, this.areasId});

  Map<String, dynamic> toJson() => {
    "treatment_id": treatmentId,
    "areas_id": areasId == null
        ? []
        : List<dynamic>.from(areasId!.map((x) => x)),
  };
}
