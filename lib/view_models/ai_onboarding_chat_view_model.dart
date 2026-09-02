import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ai_chat_message_model.dart';
import '../repositories/ai_onboarding_chat_repository.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final aiOnboardingChatViewModel = NotifierProvider.autoDispose<
    AiOnboardingChatViewModel, AiOnboardingChatState>(
  () => AiOnboardingChatViewModel._(),
);

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

class AiOnboardingChatViewModel extends BaseViewModel<AiOnboardingChatState> {
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
    final user = await locator<SecureStorageService>().getUser();
    final name = user?.name ?? 'Doctor';
    state = state.copyWith(userName: name);
    await loadInitialMessages(name);
  }

  Future<void> loadInitialMessages(String userName) async {
    state = state.copyWith(loading: true);
    final response = await _repository.getAiOnboardingMessages();
    List<AiChatMessageModel> list = response.data?.items ?? [];

    if (list.isEmpty) {
      list = [
        AiChatMessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: 'SkinSync AI',
          time: 'Just now',
          isAi: true,
          isMe: false,
          messageType: AiChatMessageType.optionSelection,
          text:
              'Hello $userName! Welcome to SkinSync AI Onboarding Assistant. I am here to help you set up your clinic treatments, pricing, and protocols. What would you like to configure first?',
          options: const [
            'Create Botox Treatment Template',
            'Configure Dermal Fillers',
            'Set Aftercare Protocols',
            'Setup Allowed Provider Roles',
          ],
        ),
      ];
    } else {
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
              'Hello $userName! Welcome to SkinSync AI Onboarding Assistant. I am here to help you set up your clinic treatments, pricing, and protocols. What would you like to configure first?',
          options: first.options,
          treatmentDraftData: first.treatmentDraftData,
        );
      }
    }

    state = state.copyWith(loading: false, messages: list);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final userMsg = AiChatMessageModel(
      id: now.millisecondsSinceEpoch.toString(),
      senderName: 'You',
      time: timeStr,
      isAi: false,
      isMe: true,
      messageType: AiChatMessageType.text,
      text: text.trim(),
    );

    final updated = List<AiChatMessageModel>.from(state.messages)..add(userMsg);
    state = state.copyWith(messages: updated);

    _generateAiReply(text.trim());
  }

  void _generateAiReply(String userQuery) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      final now = DateTime.now();
      final timeStr =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      late final AiChatMessageModel aiReply;
      final query = userQuery.toLowerCase();

      if (query.contains('botox') ||
          query.contains('template') ||
          query.contains('create')) {
        aiReply = AiChatMessageModel(
          id: now.millisecondsSinceEpoch.toString(),
          senderName: 'SkinSync AI',
          time: timeStr,
          isAi: true,
          isMe: false,
          messageType: AiChatMessageType.treatmentDraft,
          text:
              'Here is the automated draft generated for your requested treatment template:',
          treatmentDraftData: AiTreatmentDraftData(
            treatmentName: 'Botox Anti-Wrinkle Treatment',
            category: 'Injectables',
            subcategory: 'Neuromodulators',
            price: '\$150.00 / syringe',
            sessions: 1,
            downtime: 'None',
            allowedRoles: 'Injector, MD, Nurse',
          ),
        );
      } else if (query.contains('price') ||
          query.contains('pricing') ||
          query.contains('cost')) {
        aiReply = AiChatMessageModel(
          id: now.millisecondsSinceEpoch.toString(),
          senderName: 'SkinSync AI',
          time: timeStr,
          isAi: true,
          isMe: false,
          messageType: AiChatMessageType.optionSelection,
          text:
              'I can help you configure base pricing, sub-area overrides, and package discounts. Which pricing model do you prefer?',
          options: const [
            'Flat Per-Syringe Pricing',
            'Dynamic Unit Calculation',
            'Tiered Package Pricing',
          ],
        );
      } else {
        aiReply = AiChatMessageModel(
          id: now.millisecondsSinceEpoch.toString(),
          senderName: 'SkinSync AI',
          time: timeStr,
          isAi: true,
          isMe: false,
          messageType: AiChatMessageType.text,
          text:
              'Understood! I have updated your onboarding preferences for "$userQuery". What would you like to set up next?',
        );
      }

      final newMessages = List<AiChatMessageModel>.from(state.messages)
        ..add(aiReply);
      state = state.copyWith(messages: newMessages);
    });
  }
}
