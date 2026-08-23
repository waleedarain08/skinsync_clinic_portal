
import '../../../utils/enums.dart';
import '../base_request.dart';

class AllowedProviderRolesRequest extends BaseRequest {
  final int stepNumber;
  final List<String>? allowedRoles;
  final bool isCatDefualt;

  AllowedProviderRolesRequest({required this.stepNumber, this.allowedRoles,required this.isCatDefualt});

  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.allowedProviderRoles.name],
    'is_cat_default': isCatDefualt,
    'allowed_roles': allowedRoles == null
        ? []
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}
