import 'dart:async';

import '../models/requests/add_treatment_req_model.dart';
import '../models/responses/base_response_model.dart';
import '../models/treatment_model.dart';
import '../repositories/treatment_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class TreatmentServices implements TreatmentRepository {
  final ApiBaseService _api;

  TreatmentServices({required ApiBaseService api}) : _api = api;

  @override
  Future<List<TreatmentModel>> getClinicTreatments() async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.getClinicTreatments,
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

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
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

    if (!response.status) {
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

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.data ?? [];
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

    if (!response.status) {
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

    if (!response.status) {
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

    if (!response.status) {
      throw BadRequestException(response.message);
    }
    return response.status;
  }
}
