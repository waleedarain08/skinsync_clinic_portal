import '../models/requests/register_patient_request.dart';
import '../models/responses/patient_clinical_journey_response.dart';
import '../models/responses/patient_detail_response.dart';
import '../models/responses/patient_list_response.dart';
import '../models/responses/patient_treatment_progress_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../models/responses/register_patient_response.dart';

abstract class PatientRepository {
  Future<PatientListResponse> getPatients({
    required int page,
    required int limit,
    String? search,
  });

  Future<PatientDetailResponse> getPatientDetail({
    required int patientId,
  });

  Future<PatientTreatmentRequestResponse> getPatientTreatmentRequests({
    required int page,
    required int limit,
    int? patientId,
  });

  Future<RegisterPatientResponse> registerPatient({
    required RegisterPatientRequest request,
  });

  Future<PatientTreatmentProgressResponse> getPatientTreatmentProgress({
    required int patientId,
  });

  Future<PatientClinicalJourneyResponse> getPatientClinicalJourney({
    required int patientId,
  });
}
