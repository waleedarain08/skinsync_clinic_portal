import 'dart:developer';

import '../models/requests/fetch_practitioner_by_email_request.dart';
import '../models/requests/register_practitioner_request.dart';
import '../models/requests/status_request.dart';
import '../models/requests/update_practitioner_treament_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/fetch_practitioner_by_email_response.dart';
import '../models/responses/practitioner_list_response.dart';
import '../models/responses/practitioner_detail_response.dart';
import '../models/responses/register_practitioner_response.dart';
import '../repositories/practitioner_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class PractitionerService extends PractitionerRepository {
  @override
  Future<Practitioner> register({
    required RegisterPractitionerRequest request,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.createDoctor,
      requestType: RequestType.post,
      requestBody: request,
    );
    log('RESPONSE: $response');
    final model = RegisterPractitionerResponse.fromJson(response);
    if (!model.success || model.data == null) {
      throw Exception(model.message);
    }
    return model.data!;
  }

  @override
  Future<PractitionerListData?> fetchPractitioner({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final Map<String, String?> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.getPractitioners,
      requestType: RequestType.get,
      queryParams: queryParams,
    );
    final model = PractitionerListResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model.data;
  }

  @override
  Future<PractitionerDetailResponse> fetchPractitionerDetail({
    required int id,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.practitionersID,
      requestType: RequestType.get,
      pathParams: {'id': id.toString()},
    );
    final model = PractitionerDetailResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<BaseResponse> deletePractitioner({required int id}) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.practitionersID,
      requestType: RequestType.delete,
      pathParams: {'id': id.toString()},
    );
    final model = BaseResponse.fromJson(response, (json) => json);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<BaseResponse> updatePractitionerStatus({
    required int id,
    required StatusRequest request,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.practitionerStatus,
      requestType: RequestType.patch,
      requestBody: request,
      pathParams: {'id': id.toString()},
    );
    final model = BaseResponse.fromJson(response, (json) => json);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<void> updatePractitioner({
    required UpdatePractitionerRequest request,
    required int practitionerID,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.practitionersID,
      requestType: RequestType.patch,
      requestBody: request,
      pathParams: {'id': practitionerID.toString()},
    );

    if (response['is_success'] != true) {
      throw Exception(response['message']);
    }
  }

  @override
  Future<FetchPractitionerByEmailResponse> fetchPractitionerByEmail({
    required FetchPractitionerByEmailRequest request,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.fetchPractitionerByEmail,
      requestType: RequestType.get,
      requestBody: request,
      queryParams: {'email': request.email},
    );
    return FetchPractitionerByEmailResponse.fromJson(response);
  }
}
