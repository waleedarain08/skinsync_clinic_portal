import 'package:flutter/material.dart';

enum FormComponentType {
  textLabel,
  textField,
  textArea,
  checkbox,
  toggle,
  dropdown,
  datePicker,
  signaturePad,
  imagePlaceholder,
  divider,
  pageBreak,
}

class FormComponent {
  final String id;
  final FormComponentType type;
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

  // Coordinate-based positioning
  double dx; // X position (logical pixels on canvas)
  double dy; // Y position (logical pixels on canvas)
  double width;
  double height;

  FormComponent({
    required this.id,
    required this.type,
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
    this.dx = 0,
    this.dy = 0,
    this.width = 200,
    this.height = 50,
  });

  FormComponent copyWith({
    String? label,
    String? placeholder,
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
    double? dx,
    double? dy,
    double? width,
    double? height,
  }) {
    return FormComponent(
      id: id,
      type: type,
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
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }
}
