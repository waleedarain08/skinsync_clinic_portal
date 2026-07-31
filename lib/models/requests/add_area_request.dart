import 'base_request.dart';

class AddAreaRequest extends BaseRequest {
  final int? areaId;

  AddAreaRequest({this.areaId});

  @override
  Map<String, dynamic> toJson() => {"area_id": areaId};
}
