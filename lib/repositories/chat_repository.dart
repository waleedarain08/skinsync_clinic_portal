import '../models/dummy/chat_dummy_model.dart';
import '../models/responses/chats_response.dart';

abstract class ChatRepository {
  Future<ChatsData> getChats({int page = 1, int limit = 10, String? search});

  Future<MessagesData> getMessages({
    required int chatId,
    int page = 1,
    int limit = 1,
    String? search,
  });
}
