import '../models/ai_chat_message_model.dart';
import '../models/responses/ai_onboarding_chat_list_response.dart';
import '../repositories/ai_onboarding_chat_repository.dart';
import '../utils/clinic_dummy_data.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class AiOnboardingChatService extends AiOnboardingChatRepository {
  final ApiBaseService? _api;

  AiOnboardingChatService({ApiBaseService? api}) : _api = api;

  @override
  Future<AiOnboardingChatListResponse> getAiOnboardingMessages({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final apiService = _api ?? locator<ApiBaseService>();
      final response = await apiService.httpRequest(
        endPoint: Endpoint.aiOnboardingChat,
        requestType: RequestType.get,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final model = AiOnboardingChatListResponse.fromJson(response);
      if (model.success) {
        return model;
      }
    } catch (_) {
      // Fallback to dummy data
    }

    return getDummyAiOnboardingResponse(
      page: page,
      limit: limit,
      search: search,
    );
  }

  AiOnboardingChatListResponse getDummyAiOnboardingResponse({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    var messages = ClinicDummyData.aiOnboardingDummyMessages;

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      messages = messages
          .where((m) => m.text.toLowerCase().contains(query))
          .toList();
    }

    final startIndex = (page - 1) * limit;
    List<AiChatMessageModel> pagedItems = [];
    if (startIndex < messages.length) {
      final endIndex = (startIndex + limit).clamp(0, messages.length);
      pagedItems = messages.sublist(startIndex, endIndex);
    }

    final total = messages.length;
    final totalPages = (total / limit).ceil();

    return AiOnboardingChatListResponse(
      success: true,
      message: "AI Onboarding chat messages fetched successfully",
      data: AiOnboardingChatListData(
        items: pagedItems,
        limit: limit,
        page: page,
        total: total,
        totalPages: totalPages > 0 ? totalPages : 1,
      ),
    );
  }
}
