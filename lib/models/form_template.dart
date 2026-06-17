import 'dart:convert';

import 'package:camera/camera.dart';

class FormTemplate {
  final String id;
  final String name;
  final XFile file;
  final DateTime createdAt;
  final bool isUserCreated;

  FormTemplate({
    required this.id,
    required this.name,
    required this.file,
    required this.createdAt,
    required this.isUserCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': file.path,
      'createdAt': createdAt.toIso8601String(),
      'isUserCreated': isUserCreated,
    };
  }

  factory FormTemplate.fromMap(Map<String, dynamic> map) {
    return FormTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      file: XFile(map['filePath'], mimeType: 'application/pdf'),
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isUserCreated: map['isUserCreated'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory FormTemplate.fromJson(String source) =>
      FormTemplate.fromMap(json.decode(source));
}
