import 'base_request.dart';

class AddChatPractitionerRequest extends BaseRequest {
  final int chatId;
  final int practitionerId;

  AddChatPractitionerRequest({required this.chatId, required this.practitionerId});

  @override
  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'practitioner_id': practitionerId,
    };
  }
}