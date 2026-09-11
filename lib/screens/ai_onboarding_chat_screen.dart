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
  final String? initialMessage;

  const AiOnboardingChatScreen({
    super.key,
    this.showBackButton = true,
    this.initialMessage,
  });

  @override
  ConsumerState<AiOnboardingChatScreen> createState() =>
      _AiOnboardingChatScreenState();
}

class _AiOnboardingChatScreenState
    extends ConsumerState<AiOnboardingChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();

    if (widget.initialMessage != null &&
        widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(
          showLoading: false,
          customText: widget.initialMessage,
        );
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // SEND MESSAGE
  // ---------------------------------------------------------------------------

  void _sendMessage({
    bool showLoading = true,
    String? customText,
  }) {
    final text =
        (customText ?? _messageController.text).trim();

    if (text.isEmpty) return;

    ref
        .read(aiOnboardingChatViewModel.notifier)
        .sendMessage(
          text,
          showLoading: showLoading,
        );

    // Clear text only when user typed manually.
    if (customText == null) {
      _messageController.clear();
    }

    // Clear selected options after sending.
    if (_selectedOptions.isNotEmpty) {
      setState(() {
        _selectedOptions.clear();
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        if (!_scrollController.hasClients) return;

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiOnboardingChatViewModel);

    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(
          horizontal: 24,
          vertical: 24,
        ),
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
                    // ---------------------------------------------------------
                    // MESSAGES
                    // ---------------------------------------------------------

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
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                final message =
                                    state.messages[index];

                                return AiChatMessageBubble(
                                  message: message,
                                  onOptionTap: (option) {
                                    _sendMessage(
                                      customText: option,
                                      showLoading: false,
                                    );
                                  },
                                );
                              },
                            ),
                    ),

                    context.verticalSpace(12),

                    // ---------------------------------------------------------
                    // DYNAMIC INPUT
                    // ---------------------------------------------------------

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

  // ---------------------------------------------------------------------------
  // DYNAMIC INPUT BAR
  // ---------------------------------------------------------------------------

  Widget _buildInputBar(BuildContext context) {
    final state = ref.watch(aiOnboardingChatViewModel);

    // Questionnaire completed.
    if (state.completed) {
      return const SizedBox.shrink();
    }

    switch (state.inputType) {
      case 'text':
        return _buildTextInput(context);

      case 'number':
        return _buildNumberInput(context);

      case 'multi_select':
        return _buildMultiSelectInput(
          context,
          state.inputOptions,
        );

      case 'time_picker':
        return _buildTimePickerInput(context);

      case 'date_picker':
        return _buildDatePickerInput(context);

      default:
        // Before first AI response, show normal text input.
        return _buildTextInput(context);
    }
  }

  // ---------------------------------------------------------------------------
  // TEXT INPUT
  // ---------------------------------------------------------------------------

  Widget _buildTextInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            style: context.fonts.black14w400,
            textInputAction: TextInputAction.send,
            decoration: AppDecorations.input(
              context,
              hint: 'Enter your answer...',
            ),
            onSubmitted: (_) {
              _sendMessage();
            },
          ),
        ),

        context.horizontalSpace(12),

        _buildSendButton(context),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NUMBER INPUT
  // ---------------------------------------------------------------------------

  Widget _buildNumberInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.send,
            style: context.fonts.black14w400,
            decoration: AppDecorations.input(
              context,
              hint: 'Enter number...',
            ),
            onSubmitted: (_) {
              _sendMessage();
            },
          ),
        ),

        context.horizontalSpace(12),

        _buildSendButton(context),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SEND BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildSendButton(BuildContext context) {
    return Material(
      color: CustomColors.purple,
      borderRadius: BorderRadius.circular(
        context.r(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          context.r(12),
        ),
        onTap: () {
          _sendMessage();
        },
        child: Padding(
          padding: context.appEdgeInsets(all: 12),
          child: Icon(
            Icons.send_rounded,
            color: CustomColors.white,
            size: context.sp(20),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MULTI SELECT
  // ---------------------------------------------------------------------------

  Widget _buildMultiSelectInput(
    BuildContext context,
    List<String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final selected =
                _selectedOptions.contains(option);

            return FilterChip(
              label: Text(option),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    if (!_selectedOptions.contains(option)) {
                      _selectedOptions.add(option);
                    }
                  } else {
                    _selectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),

        context.verticalSpace(12),

        Align(
          alignment: Alignment.centerRight,
          child: _buildContinueButton(context),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MULTI SELECT CONTINUE
  // ---------------------------------------------------------------------------

  Widget _buildContinueButton(BuildContext context) {
    final hasSelection = _selectedOptions.isNotEmpty;

    return Material(
      color: hasSelection
          ? CustomColors.purple
          : Colors.grey,
      borderRadius: BorderRadius.circular(
        context.r(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          context.r(12),
        ),
        onTap: hasSelection
            ? () {
                final value =
                    _selectedOptions.join(', ');

                _sendMessage(
                  customText: value,
                  showLoading: false,
                );
              }
            : null,
        child: Padding(
          padding: context.appEdgeInsets(
            horizontal: 20,
            vertical: 12,
          ),
          child: Text(
            'Continue',
            style: context.fonts.white14w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TIME PICKER
  // ---------------------------------------------------------------------------

  Widget _buildTimePickerInput(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: CustomColors.purple,
        borderRadius: BorderRadius.circular(
          context.r(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            context.r(12),
          ),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (time == null) return;

            final formatted = time.format(context);

            _sendMessage(
              customText: formatted,
              showLoading: false,
            );
          },
          child: Padding(
            padding: context.appEdgeInsets(
              horizontal: 20,
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time,
                  color: CustomColors.white,
                ),

                context.horizontalSpace(8),

                Text(
                  'Select Time',
                  style: context.fonts.white14w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE PICKER
  // ---------------------------------------------------------------------------

  Widget _buildDatePickerInput(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: CustomColors.purple,
        borderRadius: BorderRadius.circular(
          context.r(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            context.r(12),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );

            if (date == null) return;

            final formatted =
                '${date.year}-'
                '${date.month.toString().padLeft(2, '0')}-'
                '${date.day.toString().padLeft(2, '0')}';

            _sendMessage(
              customText: formatted,
              showLoading: false,
            );
          },
          child: Padding(
            padding: context.appEdgeInsets(
              horizontal: 20,
              vertical: 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: CustomColors.white,
                ),

                context.horizontalSpace(8),

                Text(
                  'Select Date',
                  style: context.fonts.white14w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  