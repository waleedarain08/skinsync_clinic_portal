import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_chat_message_model.dart';
import '../models/requests/message_request.dart';
import '../models/responses/ai_onboarding_chat_message_response.dart';
import '../repositories/ai_onboarding_chat_repository.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final aiOnboardingChatViewModel =
    NotifierProvider.autoDispose<
      AiOnboardingChatViewModel,
      AiOnboardingChatState
    >(() => AiOnboardingChatViewModel._());

class AiOnboardingChatState {
  final List<AiChatMessageModel> messages;
  final bool loading;
  final String userName;

  const AiOnboardingChatState({
    this.messages = const [],
    this.loading = false,
    this.userName = 'Doctor',
  });

  AiOnboardingChatState copyWith({
    List<AiChatMessageModel>? messages,
    bool? loading,
    String? userName,
  }) {
    return AiOnboardingChatState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
      userName: userName ?? this.userName,
    );
  }
}

class AiOnboardingChatViewModel
    extends BaseViewModel<AiOnboardingChatState> {
  AiOnboardingChatViewModel._();

  final AiOnboardingChatRepository _repository =
      locator<AiOnboardingChatRepository>();

  @override
  AiOnboardingChatState build() {
    init();

    ref.onDispose(dispose);

    _initChat();

    return const AiOnboardingChatState();
  }

  Future<void> _initChat() async {
    try {
      final user =
          await locator<SecureStorageService>().getUser();

      final name = user?.name ?? 'Doctor';

      state = state.copyWith(userName: name);

      await loadInitialMessages(name);
    } catch (e) {
      state = state.copyWith(loading: false);
    }
  }

  Future<void> loadInitialMessages(String userName) async {
    state = state.copyWith(loading: true);

    try {
      final response =
          await _repository.getAiOnboardingMessages();

      final list =
          List<AiChatMessageModel>.from(
        response.data?.items ?? [],
      );

      if (list.isEmpty) {
        // No dummy listing here.
        state = state.copyWith(
          loading: false,
          messages: [],
        );
        return;
      }

      final first = list.first;

      if (first.isAi && first.id == 'ai_1') {
        list[0] = AiChatMessageModel(
          id: first.id,
          senderName: first.senderName,
          time: first.time,
          isAi: true,
          isMe: false,
          messageType: first.messageType,
          text:
              'Hello $userName! Welcome to SkinSync AI Onboarding Assistant. '
              'I am here to help you set up your clinic treatments, pricing, '
              'and protocols. What would you like to configure first?',
          options: first.options,
          treatmentDraftData: first.treatmentDraftData,
        );
      }

      state = state.copyWith(
        loading: false,
        messages: list,
      );
    } catch (e) {
      // IMPORTANT:
      // Always stop the loader if API fails.
      state = state.copyWith(
        loading: false,
        messages: [],
      );
    }
  }

  Future<void> sendMessage(String text,{bool showLoading = false}) async {
    final message = text.trim();

    if (message.isEmpty) return;

    final now = DateTime.now();

    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}";

    try {
      final aiReply = await sendAIMessage(message, showLoading: showLoading);

      if (aiReply == null) {
        return;
      }

      final userMsg = AiChatMessageModel(
        id: now.millisecondsSinceEpoch.toString(),
        senderName: 'You',
        time: timeStr,
        isAi: false,
        isMe: true,
        messageType: AiChatMessageType.text,
        text: message,
      );

      final updated =
          List<AiChatMessageModel>.from(state.messages)
            ..add(userMsg);

      // Add user's message.
      state = state.copyWith(
        messages: updated,
      );

      // Add actual AI response from API.
      final aiMessage = AiChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderName: 'SkinSync AI',
        time: timeStr,
        isAi: true,
        isMe: false,
        messageType: AiChatMessageType.text,
        text: aiReply.reply ?? '',
      );

      final messagesWithReply =
          List<AiChatMessageModel>.from(state.messages)
            ..add(aiMessage);

      state = state.copyWith(
        messages: messagesWithReply,
      );
    } catch (e) {
      // Do not leave anything loading.
      state = state.copyWith(
        loading: false,
      );
    }
  }

  Future<AiOnboardingChatMessageResponse?> sendAIMessage(
    String message,
    {bool showLoading = true}
  ) async {
    return await runSafely(showLoading: showLoading,() async {
      final response = await _repository.sendMessage(
        request: MessageRequest(
          message: message,
        ),
      );

      return response;
    });
  }
}