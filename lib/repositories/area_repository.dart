
import '../models/requests/create_area_request.dart';
import '../models/requests/update_area_request.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/base_response_model.dart';

abstract class AreaRepository {
  Future<List<AreaModel>> getAreas();
  // Future<AreaModel?> createArea(AreaRequest request);
  Future<BaseResponse> createArea(CreateAreaRequest request);
  Future<BaseResponse> updateArea({
    required UpdateAreaRequest request,
    required int id,
  });
   Future<BaseResponse> deleteArea({
    required int id,
  });
}
