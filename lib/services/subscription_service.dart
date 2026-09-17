import '../models/requests/subscribe_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/subscription_plan_model.dart';
import '../repositories/subscription_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class SubscriptionService implements SubscriptionRepository {
  final ApiBaseService _api;

  SubscriptionService({required this._api});

  @override
  Future<ClinicCurrentPlanData> getClinicCurrentPlan() async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.clinicCurrentPlan,
      requestType: RequestType.get,
    );

    final response = BaseResponse<ClinicCurrentPlanData>.fromJson(
      jsonResponse,
      (json) => ClinicCurrentPlanData.fromJson(json as Map<String, dynamic>),
    );

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    if (response.data == null) {
      throw UnknownException(response.message);
    }

    return response.data!;
  }

  @override
  Future<SubscribeResponseData> subscribe({required SubscribeRequest req}) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.subscribe,
      requestType: RequestType.post,
      requestBody: req,
    );

    final response = BaseResponse<SubscribeResponseData>.fromJson(
      jsonResponse,
      (json) => SubscribeResponseData.fromJson(json as Map<String, dynamic>),
    );

    if (!response.success) {
      throw BadRequestException(response.message);
    }

    if (response.data == null) {
      throw UnknownException(response.message);
    }

    return response.data!;
  }
}
