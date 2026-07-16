import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../utils/theme.dart';
import '../../view_models/session_view_model.dart';
import '../build_textfield.dart';
import 'instruction_attachments_widget.dart';

class PreInstructionsStep extends ConsumerWidget {
  const PreInstructionsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildTextField(
          label: 'Pre-Treatment Instructions',
          controller: viewModel.preTreatmentInstructionsController,
          hintText: 'Instructions for the patient before their procedure...',
          maxLines: 8,
        ),
        context.verticalSpace(32),
        InstructionAttachmentsWidget(
          files: state.existingPreAttachments,
          onPick: () => viewModel.pickAttachments(true),
          onRemove: (idx) => viewModel.removeExistingAttachment(true, idx),
        ),
      ],
    );
  }
}
