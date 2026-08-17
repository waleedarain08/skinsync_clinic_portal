import 'base_request.dart';
import 'register_practitioner_request.dart';

class UpdatePractitionerRequest extends BaseRequest {
  final String role;
  final ClinicAccess clinicAccess;
  final AvailabilityInfo availabilityInfo;
  final FinancialInfo financialInfo;

  UpdatePractitionerRequest({
    required this.role,
    required this.clinicAccess,
    required this.availabilityInfo,
    required this.financialInfo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'clinic_access': clinicAccess.toJson(),
      'availability_info': availabilityInfo.toJson(),
      'financial_info': financialInfo.toJson(),
    };
  }
}

