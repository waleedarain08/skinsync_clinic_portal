import 'dart:developer';

import '../models/requests/register_practitioner_request.dart';
import '../models/requests/update_practitioner_treament_request.dart';
import '../models/responses/get_practitioner_response.dart';
import '../models/responses/register_practitioner_response.dart';
import '../repositories/Practitioner_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';


class PractitionerService extends PractitionerRepository {
  @override
  Future<Practitioner> register({required RegisterPractitionerRequest request}) async {
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
      endPoint: Endpoint.getDoctors,
      requestType: RequestType.get,
    );
    final model = GetPractitionerResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model.data!;
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
