import 'dart:async';

import '../models/requests/add_treatment_req_model.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/treatment_detail_response.dart';
import '../models/responses/treatment_template_list_response.dart';
import '../models/responses/clinic_treatment_list_response.dart';
import '../models/treatment_model.dart';
import '../repositories/treatment_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class TreatmentServices implements TreatmentRepository {
  final ApiBaseService _api;

  TreatmentServices({required ApiBaseService api}) : _api = api;

  @override
  Future<ClinicTreatmentListResponse> getClinicTreatments({
    required int page,
    int limit = 10,
    String? search,
    String? status,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.getClinicTreatments,
      requestType: RequestType.get,
      queryParams: queryParams,
    );

    final response = ClinicTreatmentListResponse.fromJson(jsonResponse);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<List<TreatmentModel>> getAdminTreatments() async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.getAdminTreatments,
      requestType: RequestType.get,
    );
    final response = BaseResponse<List<TreatmentModel>>.fromJson(jsonResponse, (
      treatmentList,
    ) {
      treatmentList as List;
      return treatmentList
          .map((json) => TreatmentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }

  @override
  Future<List<SideAreaModel>> getTreatmentsSideArea(int treatmentId) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.getAdminTreatmentsSideAreas,
      requestType: RequestType.get,
      pathParams: {'treatmentId': treatmentId.toString()},
    );
    final response = BaseResponse<List<SideAreaModel>>.fromJson(jsonResponse, (
      sideAreaList,
    ) {
      sideAreaList as List;
      return sideAreaList
          .map((json) => SideAreaModel.fromJson(json as Map<String, dynamic>))
          .toList();
    });

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
  }

    @override
  Future<TreatmentDetailResponse> getTreatmentDetail({
    required int id,
  }) async {
   final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.treatmentDetail,
      requestType: RequestType.get,
      pathParams: {'id': id.toString()}
    );
    final response = TreatmentDetailResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<TreatmentModel> addTreatment(AddTreatmentReqModel req) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.addClinicTreatment,
      requestType: RequestType.post,
      requestBody: req,
    );
    final response = BaseResponse<TreatmentModel>.fromJson(
      jsonResponse,
      (treatment) => TreatmentModel.fromJson(treatment as Map<String, dynamic>),
    );

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<TreatmentModel> editTreatment(AddTreatmentReqModel req) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.addClinicTreatment,
      requestType: RequestType.patch,
      requestBody: req,
    );
    final response = BaseResponse<TreatmentModel>.fromJson(
      jsonResponse,
      (treatment) => TreatmentModel.fromJson(treatment as Map<String, dynamic>),
    );

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response.data!;
  }

  @override
  Future<bool> deleteTreatment(int treatmentId) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.deleteTreatment,
      requestType: RequestType.delete,
      pathParams: {"treatment_id": treatmentId.toString()},
    );
    final response = BaseResponse<TreatmentModel>.fromJson(
      jsonResponse,
      (treatment) => TreatmentModel.fromJson(treatment as Map<String, dynamic>),
    );

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response.success;
  }

  @override
  Future<TreatmentTemplateListResponse> getTreatmentTemplates({
    required int page,
    int limit = 10,
    String? search,
  }) async {
    final Map<String, String> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.getTreatmentTemplates,
      requestType: RequestType.get,
      queryParams: queryParams,
    );

    final response = TreatmentTemplateListResponse.fromJson(jsonResponse);

    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
