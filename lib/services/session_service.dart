import '../models/requests/create_session_requests/allowed_provider_role_request.dart';
import '../models/requests/create_session_requests/constent_form_selection_request.dart';
import '../models/requests/create_session_requests/down_time_level_request.dart';
import '../models/requests/create_session_requests/final_finish_request.dart';
import '../models/requests/create_session_requests/follow_up_request.dart';
import '../models/requests/create_session_requests/phase_notifications_request.dart';
import '../models/requests/create_session_requests/post_photos_request.dart';
import '../models/requests/create_session_requests/post_treatment_instruction_request.dart';
import '../models/requests/create_session_requests/pre_treatment_instruction_request.dart';
import '../models/requests/create_session_requests/product_usage_request.dart';
import '../models/requests/create_session_requests/protocol_request.dart';
import '../models/requests/create_session_requests/step_pricing_request.dart';
import '../models/requests/create_session_requests/treatment_schedule_request.dart';
import '../models/requests/session_status_request.dart';
import '../models/responses/base_response_model.dart';
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
      requestType: RequestType.get,
      endPoint: Endpoint.clinicProducts,
      // queryParams: {'category_ids': idsParam},
    );
    final response = TreatmentProductsResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> productUsage({
    required ProductUsagesRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.sessionUpdate,
      requestType: RequestType.patch,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> createSchedule(
    TreatmentScheduleRequest request,
    int id,
  ) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> stepPricing({
    required StepPricingRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(requestType: .patch,endPoint: 
      Endpoint.sessionUpdate,

      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> protocol({
    required ProtocolRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> preTreatmentInstructions({
    required PreTreatmentInstructionsRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> postTreatmentInstructions({
    required PostTreatmentInstructionsRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> postTreatmentPhotos({
    required int id,
    required bool requirePostPhotos,
    required int count,
    required List<PhotoMilestone> configs,
    required int stepNumber,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: PostPhotosRequest(
        stepNumber: stepNumber,
        requirePostTreatmentPhotos: requirePostPhotos,
        photoMilestone: configs,
      ),
      queryParams: {'session_id': id.toString()},
    );

    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> downTimeLevels({
    required DownTimeLevelRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> allowedProviderRoles({
    required AllowedProviderRolesRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> consentFormSelection({
    required ConsentFormSelectionRequest request,
    required int id,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> phaseNotifications({
    required int id,
    required PhaseNotificationsRequest request,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse<dynamic>> followUpConfig({
    required int id,
    required FollowUpRequest request,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> finalFinish({
    required int id,
    required FinalFinishRequest request,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .patch,
      endPoint: Endpoint.sessionUpdate,
      requestBody: request,
      queryParams: {'session_id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<SessionDetailResponse> getSessionDetail({required int id}) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.sessionDetail,
      pathParams: {'id': id.toString()},
      requestType: RequestType.get,
    );
    final response = SessionDetailResponse.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> deleteSession({required int id}) async {
    final jsonResponse = await _api.httpRequest(
      requestType: .delete,
      endPoint: Endpoint.deleteSession,
      pathParams: {'id': id.toString()},
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<BaseResponse> changeSessionStatus({
    required SessionStatusRequest request,
  }) async {
    final jsonResponse = await _api.httpRequest(requestType: .patch,endPoint: 
      Endpoint.sessionStatus,
      requestBody: request,
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
