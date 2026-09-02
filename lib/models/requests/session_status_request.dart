import 'base_request.dart';

class SessionStatusRequest extends BaseRequest {
  final int? sessionId;
  final String? status;

  SessionStatusRequest({this.sessionId, this.status});

  @override
  Map<String, dynamic> toJson() => {"session_id": sessionId, "status": status};
}
