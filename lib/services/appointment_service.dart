import '../models/responses/appointment_detail_response.dart';
import '../models/responses/appointment_list_response.dart';
import '../models/responses/filters_response.dart';
import '../repositories/appointment_repository.dart';
import '../utils/enums.dart' hide AppointmentStatus;
import 'api_base_helper.dart';
import 'locator.dart';

class AppointmentService extends AppointmentRepository {
  @override
  Future<AppointmentListResponse> appointmentList({
    required int page,
    // String? customerId,
    Filters? status,
    Filters? filter,
    String? search,
    int? practitionerId,
  }) async {
    // final aStatus = status == AppointmentStatus.allStatus ? null : status?.name;
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.getAppointment,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        "limit": "10",
        // "customer_id": ?customerId,
        if (practitionerId != null && practitionerId != 0)
          'doctor_id': practitionerId.toString(),
        'appointment_type_id': ?filter?.id.toString(),
        'status': ?status?.name,
        'search': ?search,
      },
    );
    final model = AppointmentListResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<AppointmentDetailResponse> appointmentDetail({required int id}) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.appointmentId,
      requestType: RequestType.get,
      pathParams: {'id': id.toString()},
    );
    final model = AppointmentDetailResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<FiltersResponse> getAppointmentStatus() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.appointmentStatuses,
      requestType: RequestType.get,
    );
    final model = FiltersResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<FiltersResponse> getAppointmentTypes() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.appointmentTypes,
      requestType: RequestType.get,
    );
    final model = FiltersResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }
}
