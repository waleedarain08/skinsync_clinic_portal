import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T>? items;
  final Function(T?) onChanged;
  final Widget Function(T)? builder;
  final double? height;
  final Color? fillColor;
  final Color? borderColor;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.height,
    this.builder,
    this.fillColor,
    this.borderColor

  });

  @override
  Widget build(BuildContext context) {
    final dropdownItems = items ?? [];
    return SizedBox(
      height: height ?? context.h(55),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        value: value,
        style: CustomFonts.black14w400,
        decoration: InputDecoration(
          fillColor:fillColor?? CustomColors.softGrey,
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: context.w(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.r(10)),
            borderSide:  BorderSide(color:borderColor?? CustomColors.softGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.r(10)),
            borderSide:  BorderSide(color:borderColor?? CustomColors.softGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(context.r(10)),
            borderSide:  BorderSide(color:borderColor?? CustomColors.softGrey),
          ),
        ),
        hint: Text(hint, style: CustomFonts.grey14w400),
        items: dropdownItems
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: builder?.call(item) ??
                    Text(item.toString(), style: CustomFonts.black14w400),
              ),
            )
            .toList(),
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(height: context.h(55), width: null),
        menuItemStyleData: MenuItemStyleData(
          height: context.h(48),
          padding: EdgeInsets.symmetric(horizontal: context.w(12)),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.r(14)),
            color: CustomColors.white,
          ),
          maxHeight: context.h(300),
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down, color: CustomColors.grey),
          iconSize: context.r(24),
        ),
      ),
    );
  }
}
