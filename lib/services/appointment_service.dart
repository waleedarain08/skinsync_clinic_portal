import '../models/responses/appointment_response.dart';
import '../models/responses/appointment_status_response.dart';
import '../models/responses/filters_response.dart';
import '../repositories/appointment_repository.dart';
import '../utils/enums.dart' hide AppointmentStatus;
import 'api_base_helper.dart';
import 'locator.dart';

class AppointmentService extends AppointmentRepository {
  @override
  Future<AppointmentResponse> appointmentList({
    required int page,
    // String? customerId,
    AppointmentStatus? status,
    Filters? filter,
     String? search,
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
        'appointment_type_id': ?filter?.id.toString(),
        'status': ?status?.id,
        'search': ?search,
      },
    );
    final model = AppointmentResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }
  @override
  Future<AppointmentStatusResponse> getAppointmentStatus() async {
   
     final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.appointmentStatuses,
      requestType: RequestType.get,
      
    );
    final model = AppointmentStatusResponse.fromJson(response);
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
