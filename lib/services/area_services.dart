import '../models/requests/add_area_request.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/base_response_model.dart';
import '../repositories/area_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class AreaServices implements AreaRepository {
  @override
  Future<List<AreaModel>> getAreas({required int treatmentId}) async {
    final jsonResponse = await locator<ApiBaseService>().httpRequest(
      requestType: RequestType.get,
      endPoint: Endpoint.areasAvailable,
        pathParams: {'treatmentId' : treatmentId.toString()}
    );
    final response = AreaListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }
   @override
 Future<BaseResponse> addAreas({required AddAreaRequest request,required int treatmentId}) async {
    final jsonResponse = await locator<ApiBaseService>().httpRequest(
      requestType: RequestType.post,
      endPoint: Endpoint.areas,
      requestBody: request,
      pathParams: {'treatmentId' : treatmentId.toString()}
    );
    final response = BaseResponse.fromJson(jsonResponse,(json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
