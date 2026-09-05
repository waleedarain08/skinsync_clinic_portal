import 'dart:async';

import '../exceptions/app_exception.dart';
import '../models/dummy/chat_dummy_model.dart';
import '../models/responses/chats_response.dart';
import '../models/responses/messages_response.dart';
import '../repositories/chat_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';
import 'storage_service.dart';

class ChatService extends ChatRepository {
  final ApiBaseService? api;
  // WebSocket handling moved to WebSocketService.

  ChatService({this.api});

  @override
  Future<ChatsData> getChats({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final apiService = api ?? locator<ApiBaseService>();
    final response = await apiService.httpRequest(
      endPoint: Endpoint.chats,
      requestType: RequestType.get,
      queryParams: {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final model = ChatsResponse.fromJson(response);
    if (model.success) {
      return model.data!;
    }
    throw ApiHttpException(message: model.message);
  }

  @override
  Future<MessagesData> getMessages({
    required int chatId,
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final apiService = api ?? locator<ApiBaseService>();
    final response = await apiService.httpRequest(
      endPoint: Endpoint.messages,
      requestType: RequestType.get,
      queryParams: {
        'id': '$chatId',
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );

    final model = MessagesResponse.fromJson(response);
    if (model.success) {
      final user = await SecureStorageService().getUser();
      return model.data!.copyWith(
        messages: model.data?.messages
            ?.map((m) => m.copyWith(userId: user?.id))
            .toList(),
      );
    }
    throw ApiHttpException(message: model.message);
  }
}
