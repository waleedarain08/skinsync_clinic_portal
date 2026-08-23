
import '../../../utils/enums.dart';
import '../base_request.dart';

class AllowedProviderRolesRequest extends BaseRequest {
  final int stepNumber;
  final List<String>? allowedRoles;
 

  AllowedProviderRolesRequest({required this.stepNumber, this.allowedRoles,});

  @override
  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.allowedProviderRoles.name],
    'allowed_roles': allowedRoles == null
        ? []
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}
