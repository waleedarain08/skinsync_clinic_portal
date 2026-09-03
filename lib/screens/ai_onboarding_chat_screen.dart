import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/theme.dart';
import '../view_models/ai_onboarding_chat_view_model.dart';
import '../widgets/ai_chat/ai_chat_header_widget.dart';
import '../widgets/ai_chat/ai_chat_message_bubble.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/gradient_scaffold.dart';

class AiOnboardingChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/ai-onboarding-chat-screen';

  final bool showBackButton;
  final String? initialMessage; // 1. Added parameter

  const AiOnboardingChatScreen({
    super.key,
    this.showBackButton = true,
    this.initialMessage, // 2. Added constructor argument
  });

  @override
  ConsumerState<AiOnboardingChatScreen> createState() =>
      _AiOnboardingChatScreenState();
}

class _AiOnboardingChatScreenState
    extends ConsumerState<AiOnboardingChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 3. Trigger initial message after the first frame completes
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(showLoading: false, customText: widget.initialMessage);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({bool showLoading = true, String? customText}) {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    ref
        .read(aiOnboardingChatViewModel.notifier)
        .sendMessage(text, showLoading: showLoading);

    // Clear text controller if message came from user input
    if (customText == null) {
      _messageController.clear();
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiOnboardingChatViewModel);

    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            AiChatHeaderWidget(
              userName: state.userName,
              showBackButton: widget.showBackButton,
            ),
            context.verticalSpace(16),
            Expanded(
              child: BorderdContainerWidget(
                padding: context.appEdgeInsets(all: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: state.loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: CustomColors.purple,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                return AiChatMessageBubble(
                                  message: message,
                                  onOptionTap: (option) => _sendMessage(
                                    customText: option,
                                    showLoading: false,
                                  ),
                                );
                              },
                            ),
                    ),
                    context.verticalSpace(12),
                    _buildInputBar(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            style: context.fonts.black14w400,
            decoration: AppDecorations.input(
              context,
              hint: 'Ask AI Onboarding Assistant...',
            ),
            onSubmitted: (value) => _sendMessage(),
          ),
        ),
        context.horizontalSpace(12),
        Material(
          color: CustomColors.purple,
          borderRadius: BorderRadius.circular(context.r(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(context.r(12)),
            onTap: () => _sendMessage(),
            child: Padding(
              padding: context.appEdgeInsets(all: 12),
              child: Icon(
                Icons.send_rounded,
                color: CustomColors.white,
                size: context.sp(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
