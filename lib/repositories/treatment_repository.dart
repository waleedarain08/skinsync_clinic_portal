import '../models/requests/add_treatment_req_model.dart';
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
  Future<List<TreatmentModel>> getAdminTreatments();
  Future<List<SideAreaModel>> getTreatmentsSideArea(int treatmentId);
  Future<TreatmentModel> addTreatment(AddTreatmentReqModel req);
  Future<TreatmentModel> editTreatment(AddTreatmentReqModel req);
  Future<bool> deleteTreatment(int treatmentId);
  Future<TreatmentTemplateListResponse> getTreatmentTemplates({
    required int page,
    int limit = 10,
    String? search,
  });

   Future<TreatmentDetailResponse> getTreatmentDetail({required int id});
}
