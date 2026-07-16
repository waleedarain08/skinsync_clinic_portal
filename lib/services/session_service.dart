
import '../models/responses/session_detail_response.dart';
import '../models/responses/treatment_products_response.dart';
import '../repositories/session_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class SessionServices implements SessionRepository {
 final ApiBaseService _api;

  SessionServices({required ApiBaseService api}) : _api = api;


 @override
  Future<TreatmentProductsResponse> getProductsByTreatment(
    // List<int> categoryIds,
  ) async {
   // final String idsParam = categoryIds.join(',');
    final jsonResponse = await _api.httpRequest(
      requestType: RequestType.get, endPoint: 
      Endpoint.clinicProducts,
      // queryParams: {'category_ids': idsParam},
    );
    final response = TreatmentProductsResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }



 
  // @override
  // Future<BaseResponse> productUsage({
  //   required ProductUsagesRequest request,
  //   required int id,
  // }) async {
  //   final jsonResponse = await _api.httpRequest(
  //     endPoint:   Endpoint.sessionUpdate,
  //     requestType: RequestType.patch,
  //     requestBody: request,
  //     queryParams: {'session_id': id.toString()},
  //   );
  //   final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

  //   if (!response.success) {
  //     throw BadRequestException(response.message);
  //   }

  //   return response;
  // }

//    Future<BaseResponse> createSchedule(
//     TreatmentScheduleRequest request,
//     int id,
//   ) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,
//       body: request.toJson(),
//       queryParams: {'session_id': id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     ;

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }
//  @override
//   Future<BaseResponse> stepPricing({
//     required StepPricingRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//        final response = BaseResponse.fromJson(jsonResponse,(json) => json,);


//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }



//    @override
//   Future<BaseResponse> protocol({
//     required ProtocolRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//        final response = BaseResponse.fromJson(jsonResponse,(json) => json,);


//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }

  
//   @override
//   Future<BaseResponse> preTreatmentInstructions({
//     required PreTreatmentInstructionsRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//       final response = BaseResponse.fromJson(jsonResponse,(json) => json,);


//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }

//   @override
//   Future<BaseResponse> postTreatmentInstructions({
//     required PostTreatmentInstructionsRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//      final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }

//   @override
//   Future<BaseResponse> postTreatmentPhotos({
//     required int id,
//     required bool requirePostPhotos,
//     required int count,
//     required List<PhotoMilestone> configs,
//     required int stepNumber,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,
//       body: PostPhotosRequest(
//         stepNumber: stepNumber,
//         requirePostTreatmentPhotos: requirePostPhotos,
//         photoMilestone: configs,
//       ),
//       queryParams: {'session_id': id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }

//   @override
//   Future<BaseResponse> downTimeLevels({
//     required DownTimeLevelRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }

//   @override
//   Future<BaseResponse> allowedProviderRoles({
//     required AllowedProviderRolesRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }

//   @override
//   Future<BaseResponse> consentFormSelection({
//     required ConsentFormSelectionRequest request,
//     required int id,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,

//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }

//     return response;
//   }

 
//   @override
//   Future<BaseResponse> phaseNotifications({
//     required int id,
//     required PhaseNotificationsRequest request,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,
//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }

// @override
//   Future<BaseResponse<dynamic>> followUpConfig({
//     required int id,
//     required FollowUpRequest request,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,
//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//   final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }

// @override
//   Future<BaseResponse> finalFinish({
//     required int id,
//     required FinalFinishRequest request,
//   }) async {
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionUpdate,
//       body: request,
//       queryParams: {'session_id': id.toString()},
//     );
//      final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }

  @override
  Future<SessionDetailResponse> getSessionDetail({
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      endPoint:  Endpoint.sessionDetail,
      pathParams: {'id': id.toString()},
      requestType: RequestType.get
    );
    final response = SessionDetailResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

//   @override
//   Future<BaseResponse> deleteSession({
//     required int id,
//   }) async {
//     final jsonResponse = await _api.delete(
//       Endpoint.deleteSession,
//       pathParams: {'id':id.toString()},
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }
//   @override
// Future<BaseResponse> changeSessionStatus({
//     required SessionStatusRequest request,
//   }) async{
//     final jsonResponse = await _api.patch(
//       Endpoint.sessionStatus,
//       body: request
//     );
//     final response = BaseResponse.fromJson(jsonResponse,(json) => json,);

//     if (!response.success) {
//       throw BadRequestException(response.message);
//     }
//     return response;
//   }


}