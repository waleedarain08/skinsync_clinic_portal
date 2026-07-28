

import '../models/responses/appointment_detail_response.dart';
import '../models/responses/filters_response.dart';

abstract class AppointmentRepository {
  Future<void> appointmentList({required int page});
  Future<AppointmentDetailResponse> appointmentDetail({required int id});
  Future<FiltersResponse> getAppointmentTypes();
  Future<FiltersResponse> getAppointmentStatus();
  


}
