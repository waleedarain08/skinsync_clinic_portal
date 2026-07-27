

import '../models/responses/appointment_status_response.dart';
import '../models/responses/filters_response.dart';

abstract class AppointmentRepository {
  Future<void> appointmentList({required int page});
  Future<FiltersResponse> getAppointmentTypes();
  Future<AppointmentStatusResponse> getAppointmentStatus();


}
