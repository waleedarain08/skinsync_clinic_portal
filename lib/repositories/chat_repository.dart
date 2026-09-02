import '../models/responses/chats_message_list_response.dart';

abstract class ChatRepository {
  Future<ChatsMessageListResponse> getChatMessages({
    int page = 1,
    int limit = 10,
    String? search,
    String? chatId,
  });
}
