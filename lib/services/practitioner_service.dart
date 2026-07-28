import 'dart:developer';

import '../models/requests/register_practitioner_request.dart';
import '../models/requests/status_request.dart';
import '../models/requests/update_practitioner_treament_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/get_practitioner_response.dart';
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
  Future<List<Practitioner>> fetchPractitioner() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.getPractitioners,
      requestType: RequestType.get,
    );
    final model = GetPractitionerResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model.data!;
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
  Future<void> updatepractitionerTreatment({
    required UpdatePractitionerRequest request,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.updateDoctorTreatment,
      requestType: RequestType.patch,
      requestBody: request,
    );

    if (response['is_success'] != true) {
      throw Exception(response['message']);
    }
  }
}
