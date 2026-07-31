

import '../models/requests/add_area_request.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/base_response_model.dart';

abstract class AreaRepository {
  Future<List<AreaModel>> getAreas({required int treatmentId});
 Future<BaseResponse> addAreas({required AddAreaRequest request,required int treatmentId});
}
