import '../models/responses/ai_onboarding_chat_list_response.dart';

abstract class AiOnboardingChatRepository {
  Future<AiOnboardingChatListResponse> getAiOnboardingMessages({
    int page = 1,
    int limit = 10,
    String? search,
  });
}
