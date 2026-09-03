import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_client/web_socket_client.dart';

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
  final Map<int, WebSocket> _chatSockets = {};
  final Map<int, StreamSubscription<dynamic>> _chatSubscriptions = {};
  final Map<int, StreamSubscription<dynamic>> _connections = {};

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
      pathParams: {'chatId': '$chatId'},
      queryParams: {
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

  @override
  Future<void> connectChatSocket({
    required int chatId,
    required void Function(Message message) onMessage,
  }) async {
    if (_chatSockets.containsKey(chatId)) {
      return;
    }

    final token = await locator<SecureStorageService>().getToken();
    final user = await locator<SecureStorageService>().getUser();
    final baseUrl = api?.baseUrl ?? locator<ApiBaseService>().baseUrl;
    final socketUri = Uri.parse('${baseUrl}chat/$chatId/ws').replace(
      scheme: baseUrl.startsWith('https') ? 'wss' : 'ws',
      queryParameters: {'token': token},
    );
    log('TOKEN: $token');

    final socket = WebSocket(
      socketUri,
      headers: {'Authorization': 'Bearer $token'},
    );

    _chatSockets[chatId] = socket;

    final subscription = socket.messages.listen(
      (event) {
        try {
          final payload = jsonDecode(event as String) as Map<String, dynamic>;
          final message = Message.fromJson(payload).copyWith(userId: user?.id);
          onMessage(message);
        } catch (_) {
          if (event is String) {
            final error = jsonDecode(event)['error'];
            EasyLoading.showError(error);
          } else {
            log('ERROR: $event');
          }
        }
      },
      onDone: () {
        _chatSubscriptions.remove(chatId);
        _chatSockets.remove(chatId);
      },
      onError: (error) {
        EasyLoading.showError(error.toString());
        _chatSubscriptions.remove(chatId);
        _chatSockets.remove(chatId);
      },
    );

    final connection = socket.connection.listen((connection) {
      log('CONNECTION: ${connection.runtimeType}');
      if (connection is Disconnecting) {
        closeChatSocket(chatId: chatId);
      }
    });

    _connections[chatId] = connection;
    _chatSubscriptions[chatId] = subscription;
  }

  @override
  Future<void> closeChatSocket({required int chatId}) async {
    final socket = _chatSockets[chatId];
    socket?.close();
    final subscription = _chatSubscriptions[chatId];
    final connection = _connections[chatId];
    await subscription?.cancel();
    await connection?.cancel();

    _chatSubscriptions.remove(chatId);
    _connections.remove(chatId);
    _chatSockets.remove(chatId);
  }

  @override
  Future<void> sendChatMessage({
    required int chatId,
    required MessageType type,
    required String content,
    String? mediaUrl,
    String? documentUrl,
  }) async {
    final socket = _chatSockets[chatId];
    if (socket == null) {
      throw const ApiHttpException(message: 'Websocket not connected');
    }

    final payload = <String, dynamic>{
      'type': type.value,
      'content': content,
      if (type == MessageType.media) 'media_url': mediaUrl,
      if (type == MessageType.document) 'document_url': documentUrl,
    };

    socket.send(jsonEncode(payload));
  }
}
