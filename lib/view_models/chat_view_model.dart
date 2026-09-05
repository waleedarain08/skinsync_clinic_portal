import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dummy/chat_dummy_model.dart';
import '../models/responses/chats_response.dart';
import '../models/responses/messages_response.dart';
import '../repositories/chat_repository.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../services/websocket_service.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'base_view_model.dart';

final chatProvider = NotifierProvider.autoDispose<ChatViewModel, ChatState>(() {
  return ChatViewModel(repo: locator<ChatRepository>());
});

class ChatViewModel extends BaseViewModel<ChatState> {
  final ChatRepository _repo;
  StreamSubscription<WsEvent>? _wsSubscription;

  ChatViewModel({required this._repo});

  @override
  ChatState build() {
    return const ChatState();
  }

  Future<void> loadChats({String? query}) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Loading chats...');
      final data = await _repo.getChats(search: query);
      state = state.copyWith(chatsData: data, loading: false);
      EasyLoading.dismiss();
    });
  }

  Future<void> loadMessages() async {
    return await runSafely(() async {
      final chatId = state.selectedChat?.id;
      if (chatId == null) {
        throw const UnknownException('No chat selected');
      }
      EasyLoading.show(status: 'Loading messages...');
      final data = await _repo.getMessages(chatId: chatId);
      state = state.copyWith(messagesData: data, loading: false);
      EasyLoading.dismiss();
    });
  }

  Future<void> addMessage(Message message) async {
    final existingMessages = List<Message>.from(
      state.messagesData?.messages ?? <Message>[],
    );
    final alreadyExists = existingMessages.any((m) => m.id == message.id);
    if (alreadyExists) return;
    final user = await SecureStorageService().getUser();

    final updatedMessages = [
      message.copyWith(userId: user?.id),
      ...existingMessages,
    ];
    final currentData = state.messagesData ?? MessagesData(messages: const []);
    state = state.copyWith(
      messagesData: currentData.copyWith(messages: updatedMessages),
    );
  }

  Future<void> sendChatMessage({
    required MessageType type,
    required String content,
    String? mediaUrl,
    String? documentUrl,
  }) async {
    return await runSafely(() async {
      final chatId = state.selectedChat?.id;
      if (chatId == null) {
        throw const UnknownException('No chat selected');
      }

      await _repo.sendChatMessage(
        chatId: chatId,
        type: type,
        content: content,
        mediaUrl: mediaUrl,
        documentUrl: documentUrl,
      );
    }, showLoading: false);
  }

  void selectChat(Chat? chat) {
    state = state.copyWith(selectedChat: chat);
  }

  Future<void> clearSelectedChatAndMessages() async {
    await _wsSubscription?.cancel();
    _wsSubscription = null;
    state = state.copyWithNull(selectedChat: true, messagesData: true);
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    super.dispose();
  }
}

class ChatState {
  final bool loading;
  final ChatsData? chatsData;
  final Chat? selectedChat;
  final MessagesData? messagesData;

  const ChatState({
    this.loading = false,
    this.chatsData,
    this.selectedChat,
    this.messagesData,
  });

  ChatState copyWith({
    bool? loading,
    ChatsData? chatsData,
    Chat? selectedChat,
    MessagesData? messagesData,
  }) {
    return ChatState(
      loading: loading ?? this.loading,
      chatsData: chatsData ?? this.chatsData,
      selectedChat: selectedChat ?? this.selectedChat,
      messagesData: messagesData ?? this.messagesData,
    );
  }

  ChatState copyWithNull({
    bool chatsData = false,
    bool selectedChat = false,
    bool messagesData = false,
  }) {
    return ChatState(
      loading: this.loading,
      chatsData: chatsData ? null : this.chatsData,
      selectedChat: selectedChat ? null : this.selectedChat,
      messagesData: messagesData ? null : this.messagesData,
    );
  }
}
