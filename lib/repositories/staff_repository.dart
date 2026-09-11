
import '../models/requests/create_staff_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/staff__list_response.dart';

abstract class StaffRepository {
  Future<BaseResponse> createStaff({required CreateStaffRequest request});
   Future<StaffListResponse> getStaff({required int page,
    int limit = 10,
    String? search,
   });
}