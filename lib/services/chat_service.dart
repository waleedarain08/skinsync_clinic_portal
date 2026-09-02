import '../models/responses/chats_message_list_response.dart';
import '../repositories/chat_repository.dart';
import '../utils/clinic_dummy_data.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class ChatService extends ChatRepository {
  final ApiBaseService? api;

  ChatService({this.api});

  @override
  Future<ChatsMessageListResponse> getChatMessages({
    int page = 1,
    int limit = 10,
    String? search,
    String? chatId,
  }) async {
    try {
      final apiService = api ?? locator<ApiBaseService>();
      final response = await apiService.httpRequest(
        endPoint: Endpoint.chatMessages,
        requestType: RequestType.get,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
          if (chatId != null && chatId.isNotEmpty) 'chat_id': chatId,
        },
      );

      final model = ChatsMessageListResponse.fromJson(response);
      if (model.success) {
        return model;
      }
    } catch (_) {
      // Fallback to dummy data if API endpoint is unavailable
    }

    return getDummyChatMessagesResponse(page: page, limit: limit, search: search);
  }

  /// Returns a paginated dummy response using ClinicDummyData
  ChatsMessageListResponse getDummyChatMessagesResponse({
    int page = 1,
    int limit = 10,
    String? search,
  }) {
    var messages = ClinicDummyData.chatDummyMessages;

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      messages = messages
          .where((m) =>
              m.text.toLowerCase().contains(query) ||
              m.senderName.toLowerCase().contains(query))
          .toList();
    }

    final allDummyItems = messages.map((msg) {
      return ChatMessageListItem(
        id: msg.id,
        senderName: msg.senderName,
        time: msg.time,
        isMe: msg.isMe,
        isRead: msg.isRead,
        messageType: msg.messageType.value,
        text: msg.text,
        mediaUrl: msg.mediaUrl,
        mediaCaption: msg.mediaCaption,
        documentName: msg.documentName,
        documentSize: msg.documentSize,
        documentUrl: msg.documentUrl,
      );
    }).toList();

    // Calculate pagination slice
    final startIndex = (page - 1) * limit;
    List<ChatMessageListItem> pagedItems = [];
    if (startIndex < allDummyItems.length) {
      final endIndex = (startIndex + limit).clamp(0, allDummyItems.length);
      pagedItems = allDummyItems.sublist(startIndex, endIndex);
    }

    final total = allDummyItems.length;
    final totalPages = (total / limit).ceil();

    return ChatsMessageListResponse(
      success: true,
      message: "Chat messages fetched successfully",
      data: ChatsMessageListData(
        items: pagedItems,
        limit: limit,
        page: page,
        total: total,
        totalPages: totalPages > 0 ? totalPages : 1,
      ),
    );
  }
}
