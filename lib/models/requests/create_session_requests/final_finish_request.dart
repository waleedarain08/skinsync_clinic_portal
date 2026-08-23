import '../../../utils/enums.dart';
import '../base_request.dart';

class FinalFinishRequest extends BaseRequest {
  final String? status;
  final bool? isCompleted;

  FinalFinishRequest({
    this.status,
    this.isCompleted,
  });

  @override
  Map<String, dynamic> toJson() => {
        'keys': [CreateTreatmentSteps.status.name],
        'status': status,
        'is_completed': isCompleted,
      };
}