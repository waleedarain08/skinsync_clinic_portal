import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/theme.dart';
import '../../view_models/session_view_model.dart';

class ConsentStep extends ConsumerWidget {
  const ConsentStep({super.key});

  Widget _buildConsentFormSection(
    BuildContext context,
    PlatformFile? file,
    VoidCallback onPick,
    VoidCallback onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Patient Consent Form (PDF)', style: context.fonts.black14w600),
        context.verticalSpace(12),
        if (file == null)
          InkWell(
            onTap: onPick,
            child: Container(
              width: double.infinity,
              padding: context.appEdgeInsets(vertical: 24),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 12),
                border: Border.all(
                  color: CustomColors.border,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: CustomColors.purple,
                    size: 28,
                  ),
                  context.verticalSpace(8),
                  Text(
                    'Upload Treatment Consent Form',
                    style: context.fonts.purple14w600,
                  ),
                  context.verticalSpace(4),
                  Text(
                    'Patients must sign this before procedure',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: context.appEdgeInsets(all: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 12),
              border: Border.all(
                color: CustomColors.purple.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.purple.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 10),
                  decoration: BoxDecoration(
                    color: CustomColors.red.withValues(alpha: 0.1),
                    borderRadius: context.appBorderRadius(all: 8),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: CustomColors.red,
                    size: 24,
                  ),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: context.fonts.black14w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${(file.size / 1024).toStringAsFixed(1)} KB',
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: CustomColors.red,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SessionState state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Consent Form Selection', style: context.fonts.black18w600),
        context.verticalSpace(24),
        _buildConsentFormSection(
          context,
          state.preTreatmentConsentForm,
          viewModel.pickConsentForm,
          viewModel.removeConsentForm,
        ),
        context.verticalSpace(24),
        Text(
          'Patients must digitally sign the selected consent form before the procedure begins.',
          style: context.fonts.grey14w400,
        ),
      ],
    );
  }
}
