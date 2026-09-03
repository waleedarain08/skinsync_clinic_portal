import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/chats_message_list_response.dart';
import '../repositories/chat_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final chatProvider = NotifierProvider.autoDispose(() {
  return ChatViewModel( repo: locator<ChatRepository>());
});

class ChatViewModel extends BaseViewModel<ChatState> {
  final ChatRepository _repo;

  ChatViewModel({required this._repo});

  @override
  ChatState build() {
    return ChatState();
  }

  Future<void> loadChats({String? query}) async {
    return await runSafely(() async {
      EasyLoading.show(status: 'Loading chats...');
      final data = await _repo.getChatMessages(search: query);
      state = state.copyWith(chatsData: data, loading: false);
      EasyLoading.dismiss();
    });
  }
}

class ChatState {
  final bool loading;
  final ChatsData? chatsData;

  ChatState({this.loading = false, this.chatsData});

  ChatState copyWith({bool? loading, ChatsData? chatsData}) {
    return ChatState(
      loading: loading ?? this.loading,
      chatsData: chatsData ?? this.chatsData,
    );
  }
}
