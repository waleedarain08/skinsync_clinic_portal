import '../models/requests/create_staff_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/staff__list_response.dart';
import '../repositories/staff_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class StaffService implements StaffRepository {
  final ApiBaseService _api;

  StaffService({required this._api});

  @override
  Future<BaseResponse> createStaff({
    required CreateStaffRequest request,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: RequestType.post,
      requestBody: request,
      endPoint: Endpoint.createStaff,
    );
    final response = BaseResponse.fromJson(jsonResponse, (json) => json);
    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<StaffListResponse> getStaff({
    required int page,
    int limit = 10,
    String? search,
  }) async {
    final jsonResponse = await _api.httpRequest(
      requestType: RequestType.get,
      endPoint: Endpoint.staff,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        'search': search ?? '',
      },
    );
    final response = StaffListResponse.fromJson(jsonResponse);
    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
