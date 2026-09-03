import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../screens/ai_onboarding_chat_screen.dart';
import '../utils/theme.dart';
import 'custom_primary_button.dart';

class AiOnboardingButton extends StatefulWidget {
  final String initialMessage;
  final String buttonText;
  final bool isBorder;

  const AiOnboardingButton({
    super.key,
    required this.initialMessage,
    required this.buttonText,
    this.isBorder = false,
  });

  @override
  State<AiOnboardingButton> createState() => AiOnboardingButtonState();
}

class AiOnboardingButtonState extends State<AiOnboardingButton> {
  // bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // final effectiveBgColor = widget.backgroundColor ??
    //     (_hovered ? CustomColors.purple : CustomColors.lightPurple);

    return MouseRegion(
      // onEnter: (_) => setState(() => _hovered = true),
      // onExit: (_) => setState(() => _hovered = false),
      child: Container(
        margin: context.appEdgeInsets(right: 12),
        child: CustomPrimaryButton(
          isBorder: widget.isBorder,
          onTap: () {
            context.pushNamed(
              AiOnboardingChatScreen.routeName,
              queryParameters: {
                'showBackButton': 'true',
                'initialMessage': widget.initialMessage,
              },
              extra: widget.initialMessage,
            );
          },
          icon: Iconsax.magicpen,

          label: widget.buttonText,
        ),
      ),
    );
  }
}
