import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/theme.dart';

class BuildTextField extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle, hintStyle;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;

  const BuildTextField({
    super.key,
    required this.label,
    this.labelStyle,
    this.hintStyle,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.prefixIcon,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle ?? CustomFonts.black14w500),
        SizedBox(height: context.h(10)),
        TextFormField(
          inputFormatters: inputFormatters,
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          style: CustomFonts.black14w400,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            hintText: hintText,
            hintStyle: hintStyle ?? CustomFonts.grey14w400,
            filled: true,
            fillColor: CustomColors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(14),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: const BorderSide(color: CustomColors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: const BorderSide(color: CustomColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: const BorderSide(color: CustomColors.purple, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
