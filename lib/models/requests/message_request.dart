import 'base_request.dart';

class SendAiMessageRequest extends BaseRequest {
  final String? threadId;
  final String? message;
  final String? clinicToken;

  SendAiMessageRequest({
    this.threadId,
    this.message,
    this.clinicToken,
  });

  @override
  Map<String, dynamic> toJson() => {
        "thread_id": threadId,
        "message": message,
        "clinic_token": clinicToken,
      };
}