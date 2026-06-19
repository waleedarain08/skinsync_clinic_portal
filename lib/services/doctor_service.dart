import 'dart:developer';

import '../models/requests/register_doctor_request.dart';
import '../models/requests/update_doctors_treament_request.dart';
import '../models/responses/get_doctors_response.dart';
import '../models/responses/register_doctor_response.dart';
import '../repositories/doctor_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class DoctorService extends DoctorRepository {
  @override
  Future<Doctor> register({required RegisterDoctorRequest request}) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.createDoctor,
      requestType: RequestType.post,
      requestBody: request,
    );
    log('RESPONSE: $response');
    final model = RegisterDoctorResponse.fromJson(response);
    if (!model.success || model.data == null) {
      throw Exception(model.message);
    }
    return model.data!;
  }

  @override
  Future<List<Doctor>> fetchDoctors() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.getDoctors,
      requestType: RequestType.get,
    );
    final model = GetDoctorsResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model.data!;
  }

  @override
  Future<void> updateDoctorTreatment({
    required UpdateDoctorRequest request,
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
