import '../models/responses/patient_detail_response.dart';
import '../models/responses/patient_list_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../repositories/patient_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class PatientService extends PatientRepository {
  @override
  Future<PatientListResponse> getPatients({
    required int page,
    required int limit,
    String? search,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.patients,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty)
          'search': search,
      },
    );

    final model = PatientListResponse.fromJson(response);

    if (!model.success) {
      throw Exception(model.message);
    }

    return model;
  }

  @override
  Future<PatientDetailResponse> getPatientDetail({
    required int patientId,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.patientDetail,
      requestType: RequestType.get,
      pathParams: {
        'id': patientId.toString(),
      },
    );

    final model = PatientDetailResponse.fromJson(response);

    if (!model.success) {
      throw Exception(model.message);
    }

    return model;
  }

  @override
  Future<PatientTreatmentRequestResponse>
      getPatientTreatmentRequests({
    required int page,
    required int limit,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.patientTreatmentRequest,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    final model =
        PatientTreatmentRequestResponse.fromJson(response);

    if (!model.success) {
      throw Exception(model.message);
    }

    return model;
  }
}