import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/widgets/custom_outlined_button.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../utils/theme.dart';

/// Shows the E-Signature dialog.
/// Usage: ESignatureDialog.show(context);
class ESignatureDialog extends StatefulWidget {
  const ESignatureDialog({super.key});

  static Future<ui.Image?> show(BuildContext context) {
    return showDialog<ui.Image?>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const ESignatureDialog(),
    );
  }

  @override
  State<ESignatureDialog> createState() => _ESignatureDialogState();
}

class _ESignatureDialogState extends State<ESignatureDialog> {
  final GlobalKey<SfSignaturePadState> _signatureKey =
      GlobalKey<SfSignaturePadState>();

  // Toolbar state
  double _strokeSize = 3.0;
  Color _strokeColor = CustomColors.black;
  Color _backgroundColor = CustomColors.white;

  // Which toolbar tab is active
  int _activeTab = -1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.w(24),
        vertical: context.h(40),
      ),
      child: Container(
        width: context.w(540),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            _buildSignaturePad(context),
            _buildToolbar(context),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(16),
        context.w(12),
        context.h(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E - Signature',
                  style: CustomFonts.black16w600,
                ),
                SizedBox(height: context.h(2)),
                Text(
                  'Draw Your E - signature for the onboarding form',
                  style: CustomFonts.grey12w400,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(context, null),
            borderRadius: BorderRadius.circular(context.r(20)),
            child: Container(
              width: context.w(28),
              height: context.w(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: CustomColors.border),
              ),
              child: Icon(
                Icons.close,
                size: context.r(16),
                color: CustomColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Signature Pad ────────────────────────────────────────────────────────────

  Widget _buildSignaturePad(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        height: context.h(220),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: CustomColors.border),
          borderRadius: BorderRadius.circular(context.r(6)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.r(6)),
          child: SfSignaturePad(
            key: _signatureKey,
            backgroundColor: _backgroundColor,
            strokeColor: _strokeColor,
            minimumStrokeWidth: _strokeSize * 0.8,
            maximumStrokeWidth: _strokeSize * 1.6,
          ),
        ),
      ),
    );
  }

  // ── Toolbar ──────────────────────────────────────────────────────────────────

  Widget _buildToolbar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(8),
      ),
      child: Row(
        children: [
          _toolbarButton(
            context: context,
            icon: Icons.format_size,
            label: 'Size',
            index: 0,
            onTap: () => _showSizeOptions(context),
          ),
          _toolbarButton(
            context: context,
            icon: Icons.palette_outlined,
            label: 'Color',
            index: 1,
            onTap: () => _showColorOptions(context),
          ),
          _toolbarButton(
            context: context,
            icon: Icons.style_outlined,
            label: 'Style',
            index: 2,
            onTap: () {},
          ),
          _toolbarButton(
            context: context,
            icon: Icons.wallpaper_outlined,
            label: 'Background',
            index: 3,
            onTap: () => _showBackgroundOptions(context),
          ),
          _toolbarButton(
            context: context,
            icon: Icons.gesture,
            label: 'Swash',
            index: 4,
            onTap: () {},
          ),
          const Spacer(),
          // Undo
          IconButton(
            onPressed: () => _signatureKey.currentState?.clear(),
            icon: Icon(Icons.undo, size: context.r(20), color: CustomColors.grey),
            tooltip: 'Clear',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          // Redo placeholder
          IconButton(
            onPressed: null,
            icon: Icon(Icons.redo, size: context.r(20), color: CustomColors.lightGrey),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _toolbarButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool active = _activeTab == index;
    return InkWell(
      onTap: () {
        setState(() => _activeTab = active ? -1 : index);
        onTap();
      },
      borderRadius: BorderRadius.circular(context.r(6)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(8),
          vertical: context.h(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.r(20),
              color: active ? CustomColors.black : CustomColors.grey,
            ),
            SizedBox(height: context.h(2)),
            Text(
              label,
              style: TextStyle(
                fontSize: context.sp(10),
                color: active ? CustomColors.black : CustomColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────────

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(16),
        0,
        context.w(16),
        context.h(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomPrimaryButton(
              onTap: _onDone,
              label: 'Done',
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: CustomOutlinedButton(
              onTap: () => Navigator.pop(context, null),
              label: 'Cancel',
            ),
          ),
        ],
      ),
    );
  }

  // ── Option Popups ─────────────────────────────────────────────────────────────

  void _showSizeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => Padding(
          padding: EdgeInsets.all(context.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stroke Size',
                style: CustomFonts.black16w600,
              ),
              SizedBox(height: context.h(16)),
              Slider(
                value: _strokeSize,
                min: 1,
                max: 10,
                divisions: 9,
                label: _strokeSize.toStringAsFixed(1),
                activeColor: CustomColors.black,
                onChanged: (v) {
                  setLocal(() {});
                  setState(() => _strokeSize = v);
                },
              ),
              SizedBox(height: context.h(8)),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorOptions(BuildContext context) {
    final colors = [
      CustomColors.black,
      CustomColors.blue,
      CustomColors.red,
      CustomColors.green,
      CustomColors.purple,
      CustomColors.amber,
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stroke Color',
              style: CustomFonts.black16w600,
            ),
            SizedBox(height: context.h(16)),
            Wrap(
              spacing: context.w(12),
              children: colors.map((c) {
                final selected = _strokeColor == c;
                return GestureDetector(
                  onTap: () {
                    setState(() => _strokeColor = c);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: context.w(40),
                    height: context.w(40),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: CustomColors.grey, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: context.h(8)),
          ],
        ),
      ),
    );
  }

  void _showBackgroundOptions(BuildContext context) {
    final colors = [
      CustomColors.white,
      CustomColors.whiteGrey,
      CustomColors.softGrey,
      CustomColors.lightPurple2,
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Background Color',
              style: CustomFonts.black16w600,
            ),
            SizedBox(height: context.h(16)),
            Wrap(
              spacing: context.w(12),
              children: colors.map((c) {
                final selected = _backgroundColor == c;
                return GestureDetector(
                  onTap: () {
                    setState(() => _backgroundColor = c);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: context.w(40),
                    height: context.w(40),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? CustomColors.grey : CustomColors.border,
                        width: selected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: context.h(8)),
          ],
        ),
      ),
    );
  }

  // ── Done handler ──────────────────────────────────────────────────────────────

  Future<void> _onDone() async {
    final image = await _signatureKey.currentState?.toImage(pixelRatio: 3.0);
    if (mounted) Navigator.pop(context, image);
  }
}
