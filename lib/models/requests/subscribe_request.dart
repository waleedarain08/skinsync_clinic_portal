import 'base_request.dart';

class SubscribeRequest extends BaseRequest {
  final String planId;
  final String? durationId;

  SubscribeRequest({required this.planId, this.durationId});

  @override
  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      if (durationId != null) 'duration_id': durationId,
    };
  }
}
