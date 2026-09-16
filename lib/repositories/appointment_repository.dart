

import '../models/requests/appointments_availability_request.dart';
import '../models/requests/create_appointment_request.dart';
import '../models/responses/appointment_detail_response.dart';
import '../models/responses/appointment_list_response.dart';
import '../models/responses/appointments_availability_response.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/booking_methods_response.dart';
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
  Future<List<BookingMethodItem>> getBookingMethods();
  Future<BaseResponse<AppointmentDetailData>> createAppointment({
    required CreateAppointmentRequest request,
  });
   Future<AvailabilityResponse> appointmentsAvailability({
    required AvailabilityRequest request,
  });
}
