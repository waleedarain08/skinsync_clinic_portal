import '../models/requests/add_treatment_req_model.dart';
import '../models/requests/session_status_request.dart';
import '../models/requests/status_request.dart';
import '../models/responses/admin_treatment_response.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/treatment_detail_response.dart';
import '../models/responses/treatment_template_list_response.dart';
import '../models/responses/clinic_treatment_list_response.dart';
import '../models/treatment_model.dart';

abstract class TreatmentRepository {
  Future<ClinicTreatmentListResponse> getClinicTreatments({
    required int page,
    int limit = 10,
    String? search,
    String? status,
  });
  Future<List<AdminTreatment>> getAdminTreatments(
    {
    required int page,
    int limit = 10,
    String? search,
  }
  );
  Future<List<SideAreaModel>> getTreatmentsSideArea(int treatmentId);
  Future<BaseResponse> addTreatment(AddTreatmentReqModel req);
  Future<TreatmentModel> editTreatment(AddTreatmentReqModel req);
  Future<bool> deleteTreatment(int treatmentId);
  Future<BaseResponse> updateTreatmentStatus({
    required int treatmentId,
    required StatusRequest status,
  });

  Future<TreatmentTemplateListResponse> getTreatmentTemplates({
    required int page,
    int limit = 10,
    String? search,
  });

   Future<TreatmentDetailResponse> getTreatmentDetail({required int id});
    Future<BaseResponse> changeSessionStatus({
    required SessionStatusRequest request,
  });
}
