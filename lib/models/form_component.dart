import 'package:flutter/material.dart';

enum FormComponentType {
  textField,
  textArea,
  checkbox,
  toggle,
  dropdown,
  datePicker,
  signaturePad,
  imagePlaceholder,
  divider,
}

class FormComponent {
  final String id;
  final FormComponentType type;
  final double boxWidth;
  String label;
  String placeholder;
  bool isRequired;
  double fontSize;
  bool isBold;
  bool isItalic;
  TextAlign alignment;
  int? maxChars;
  bool defaultValue;
  List<String> options;
  String? boxHeight; // small, medium, large
  double? aspectRatio;
  dynamic value;

  // Position in document text
  int textOffset;

  FormComponent({
    required this.id,
    required this.type,
    required this.boxWidth,
    this.label = '',
    this.placeholder = '',
    this.isRequired = false,
    this.fontSize = 14.0,
    this.isBold = false,
    this.isItalic = false,
    this.alignment = TextAlign.left,
    this.maxChars,
    this.defaultValue = false,
    this.options = const [],
    this.boxHeight = 'medium',
    this.aspectRatio = 1.0,
    this.value,
    this.textOffset = 0,
  });

  FormComponent copyWith({
    String? label,
    String? placeholder,
    double? boxWidth,
    bool? isRequired,
    double? fontSize,
    bool? isBold,
    bool? isItalic,
    TextAlign? alignment,
    int? maxChars,
    bool? defaultValue,
    List<String>? options,
    String? boxHeight,
    double? aspectRatio,
    dynamic value,
    int? textOffset,
  }) {
    return FormComponent(
      id: id,
      type: type,
      boxWidth: boxWidth ?? this.boxWidth,
      label: label ?? this.label,
      placeholder: placeholder ?? this.placeholder,
      isRequired: isRequired ?? this.isRequired,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      alignment: alignment ?? this.alignment,
      maxChars: maxChars ?? this.maxChars,
      defaultValue: defaultValue ?? this.defaultValue,
      options: options ?? this.options,
      boxHeight: boxHeight ?? this.boxHeight,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      value: value ?? this.value,
      textOffset: textOffset ?? this.textOffset,
    );
  }
}
