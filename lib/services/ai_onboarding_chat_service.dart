import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/requests/message_request.dart';
import '../models/responses/ai_onboarding_chat_list_response.dart';
import '../models/responses/ai_onboarding_chat_message_response.dart';
import '../repositories/ai_onboarding_chat_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
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
      // API error
    }

    // Dummy AI onboarding chat listing disabled
    /*
    return getDummyAiOnboardingResponse(
      page: page,
      limit: limit,
      search: search,
    );
    */

    throw const BadRequestException(
      'Failed to fetch AI onboarding chat messages',
    );
  }

  // Dummy AI onboarding chat listing disabled
  /*
  AiOnboardingChatListResponse getDummyAiOnboardingResponse({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    var messages = ClinicDummyData.aiOnboardingDummyMessages;

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();

      messages = messages
          .where(
            (m) => m.text.toLowerCase().contains(query),
          )
          .toList();
    }

    final startIndex = (page - 1) * limit;

    List<AiChatMessageModel> pagedItems = [];

    if (startIndex < messages.length) {
      final endIndex = (startIndex + limit).clamp(
        0,
        messages.length,
      );

      pagedItems = messages.sublist(
        startIndex,
        endIndex,
      );
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
  */

  @override
  Future<AiOnboardingChatMessageResponse> sendMessage({
    required MessageRequest request,
  }) async {
    try {
      final uri = Uri.parse(
        'https://parchment-repressed-outskirts.ngrok-free.dev/api/v1/onboarding/message',
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const BadRequestException('Failed to send message');
      }

      final data = AiOnboardingChatMessageResponse.fromJson(jsonResponse);

      if (data.reply == null) {
        throw const BadRequestException('Failed to send message');
      }

      return data;
    } catch (e) {
      if (e is BadRequestException) {
        rethrow;
      }

      throw BadRequestException('Failed to send message: ${e.toString()}');
    }
  }
}
