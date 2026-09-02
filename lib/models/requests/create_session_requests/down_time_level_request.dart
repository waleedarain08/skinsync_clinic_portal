
import '../../../utils/enums.dart';
import '../base_request.dart';

class DownTimeLevelRequest extends BaseRequest {
   final int stepNumber;
  final String? downtimeLevel;
  final int? downtimeDays;

  DownTimeLevelRequest({ required this.stepNumber,this.downtimeLevel, this.downtimeDays});

  @override
  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.downtimeLevel.name],
    'downtime_level': downtimeLevel,
    'downtime_days': downtimeDays,
  };
}
