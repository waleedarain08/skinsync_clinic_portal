import '../models/responses/appointment_response.dart';
import '../repositories/appointment_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class AppointmentService extends AppointmentRepository {
  @override
  Future<AppointmentResponse> appointmentList({
    required int page,
    // String? customerId,
    // AppointmentStatus? status,
    // AppointmentFilter? filter,
    // String? search,
    // String? doctorId,
  }) async {
  // final aStatus = status == AppointmentStatus.allStatus ? null : status?.name;
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.getAppointment,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        "limit": "10",
        // "customer_id": ?customerId,
        // "doctor_id": ?doctorId,
        // 'type': ?filter?.name,
        // 'status': ?aStatus,
        // 'search': ?search,
      },
    );
    final model = AppointmentResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }
}
