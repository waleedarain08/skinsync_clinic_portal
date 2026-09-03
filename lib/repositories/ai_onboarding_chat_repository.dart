import '../models/requests/message_request.dart';
import '../models/responses/ai_onboarding_chat_list_response.dart';
import '../models/responses/ai_onboarding_chat_message_response.dart';

abstract class AiOnboardingChatRepository {
  Future<AiOnboardingChatListResponse> getAiOnboardingMessages({
    int page = 1,
    int limit = 10,
    String? search,
  });

   Future<AiOnboardingChatMessageResponse> sendMessage({
    required MessageRequest request
  });
}
