import 'dart:convert';

class FormTemplate {
  final String id;
  String name;
  final String filePath;
  final DateTime createdAt;
  final bool isUserCreated;

  FormTemplate({
    required this.id,
    required this.name,
    required this.filePath,
    required this.createdAt,
    required this.isUserCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'isUserCreated': isUserCreated,
    };
  }

  factory FormTemplate.fromMap(Map<String, dynamic> map) {
    return FormTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      filePath: map['filePath'] ?? '',
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
