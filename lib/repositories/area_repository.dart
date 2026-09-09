

import '../models/requests/add_area_request.dart';
import '../models/requests/treatment_cost_request.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/session_materials_response.dart';

abstract class AreaRepository {
  Future<List<AreaModel>> getAvailableAreas({required int treatmentId});
  Future<List<AreaModel>> getClinicAreas({required int treatmentId});
  Future<List<SessionMaterialData>> getSessionMaterials({
    required int treatmentId,
    required int areaId,
  });
  Future<num?> calculateTreatmentCost({
    required TreatmentCostRequest request,
  });
  Future<BaseResponse> addAreas({
    required AddAreaRequest request,
    required int treatmentId,
  });
}
