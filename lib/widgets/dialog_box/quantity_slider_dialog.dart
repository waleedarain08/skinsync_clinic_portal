import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../utils/theme.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class QuantitySliderDialog extends StatefulWidget {
  final String materialName;
  final int minQty;
  final int maxQty;
  final int initialQty;
  final ValueChanged<int> onConfirm;

  const QuantitySliderDialog({
    super.key,
    required this.materialName,
    required this.minQty,
    required this.maxQty,
    required this.initialQty,
    required this.onConfirm,
  });

  @override
  State<QuantitySliderDialog> createState() => _QuantitySliderDialogState();
}

class _QuantitySliderDialogState extends State<QuantitySliderDialog> {
  late int _currentQty;

  @override
  void initState() {
    super.initState();
    _currentQty = widget.initialQty.clamp(widget.minQty, widget.maxQty);
  }

  @override
  Widget build(BuildContext context) {
    final int divisions =
        (widget.maxQty - widget.minQty) > 0 ? (widget.maxQty - widget.minQty) : 1;

    return StandardDialog(
      title: 'Select Quantity for ${widget.materialName}',
      width: 440.w,
      height: 320.h,
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'Cancel',
          height: context.h(40),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        CustomPrimaryButton(
          onTap: () {
            widget.onConfirm(_currentQty);
            Navigator.of(context).pop(true);
          },
          label: 'Confirm',
          height: context.h(40),
          width: context.w(140),
          icon: Icons.check_circle_outline,
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            context.verticalSpace(8),
            Text(
              'Quantity: $_currentQty',
              style: context.fonts.black18w600.copyWith(
                color: CustomColors.purple,
              ),
            ),
            context.verticalSpace(16),
            Slider(
              value: _currentQty.toDouble(),
              min: widget.minQty.toDouble(),
              max: widget.maxQty.toDouble(),
              divisions: divisions,
              activeColor: CustomColors.purple,
              inactiveColor: CustomColors.lightPurple,
              label: '$_currentQty',
              onChanged: (val) {
                setState(() {
                  _currentQty = val.round();
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Min: ${widget.minQty}', style: context.fonts.grey12w400),
                  Text('Max: ${widget.maxQty}', style: context.fonts.grey12w400),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
