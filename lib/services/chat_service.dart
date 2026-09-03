import '../exceptions/app_exception.dart';
import '../models/responses/chats_message_list_response.dart';
import '../repositories/chat_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class ChatService extends ChatRepository {
  final ApiBaseService? api;

  ChatService({this.api});

  @override
  Future<ChatsData> getChatMessages({
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
}
