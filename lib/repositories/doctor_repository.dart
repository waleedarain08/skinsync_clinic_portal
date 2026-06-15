import '../models/requests/register_doctor_request.dart';
import '../models/requests/update_doctors_treament_request.dart';

import '../models/responses/register_doctor_response.dart';

abstract class DoctorRepository {
  Future<void> register({required RegisterDoctorRequest request});

  Future<List<Doctor>> fetchDoctors();
  Future<void> updateDoctorTreatment({required UpdateDoctorRequest request});
}
