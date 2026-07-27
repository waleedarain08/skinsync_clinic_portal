
import '../models/requests/create_area_request.dart';
import '../models/requests/update_area_request.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/base_response_model.dart';
import '../repositories/area_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class AreaServices implements AreaRepository {
 

  @override
  Future<List<AreaModel>> getAreas() async {
    final jsonResponse =  await locator<ApiBaseService>().httpRequest(requestType: RequestType.get ,endPoint:  Endpoint.areas);
    final response = AreaListResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }

  // @override
  // Future<AreaModel> createArea(AreaRequest request) async {
  //   final jsonResponse = await _api.post(
  //     Endpoint.areas,
  //     body: request.toJson(),
  //   );
  //   final response = AreaResponse.fromJson(jsonResponse,

  // );

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.data!;
  // }

  @override
  Future<BaseResponse> createArea(CreateAreaRequest request) async {
    final jsonResponse = await locator<ApiBaseService>().httpRequest(
    endPoint:   Endpoint.areas,
    requestType: RequestType.post,
      requestBody: request,
    );
    final response = BaseResponse.fromJson(jsonResponse , (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> updateArea({
    required UpdateAreaRequest request,
    required int id,
  }) async {
    final jsonResponse = await locator<ApiBaseService>().httpRequest(
     requestType: RequestType.patch,endPoint:
      Endpoint.updateAreas,
      requestBody: request,
      pathParams: {'id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse , (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
   @override
  Future<BaseResponse> deleteArea({
   
    required int id,
  }) async {
    final jsonResponse = await locator<ApiBaseService>().httpRequest(
      requestType: RequestType.delete,endPoint: 
      Endpoint.updateAreas,
    
      pathParams: {'id': id.toString()},
    );
   final response = BaseResponse.fromJson(jsonResponse , (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
