import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/theme.dart';

class PhoneWidget extends ConsumerWidget {
  final TextEditingController controller;
  final ValueSetter<String>? onChanged;
  final ValueSetter<CountryCode>? onCountryChanged;
  final String? initialCountryCode;

  final bool showLabel;
  final bool filled;
  final bool removeValidation;
  final bool isEditable;

  PhoneWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCountryChanged,
    this.initialCountryCode,
    this.isEditable = false,
    this.showLabel = true,
    this.filled = false,
    this.removeValidation = false,
  });

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          readOnly: isEditable,
          controller: controller,
          onChanged: onChanged,
          autofocus: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            } else if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontFamily: "General Sans"),
          onTapOutside: (_) {
            _focusNode.unfocus();
          },
          keyboardType: TextInputType.phone,
          decoration: AppDecorations.input(
            context,
            hint: '921 - 2341 -99908',
            prefixIcon: _buildPhoneNumberPicker(context: context, ref: ref),
            fillColor: filled ? CustomColors.softGrey : CustomColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberPicker({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {},
            child: CountryCodePicker(
              onChanged: onCountryChanged,
              dialogSize: Size(context.w(400), context.w(600)),
              textStyle: CustomFonts.black14w500,
              initialSelection: initialCountryCode ?? "US",
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.h(14.3)),
            child: const VerticalDivider(
              color: Color(0xffE2E5E8),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
