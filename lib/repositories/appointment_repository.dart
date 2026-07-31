

import '../models/responses/appointment_detail_response.dart';
import '../models/responses/appointment_list_response.dart';
import '../models/responses/filters_response.dart';

abstract class AppointmentRepository {
  Future<AppointmentListResponse> appointmentList({
    required int page,
    Filters? status,
    Filters? filter,
    String? search,
    int? practitionerId,
  });
  Future<AppointmentDetailResponse> appointmentDetail({required int id});
  Future<FiltersResponse> getAppointmentTypes();
  Future<FiltersResponse> getAppointmentStatus();
  


}
