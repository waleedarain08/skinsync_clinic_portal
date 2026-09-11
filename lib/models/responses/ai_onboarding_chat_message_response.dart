class AiOnboardingChatMessageResponse {
  final String? reply;
  final int? progress;
  final bool? completed;
  final String? currentField;
  final AiInputModel? input;

  AiOnboardingChatMessageResponse({
    this.reply,
    this.progress,
    this.completed,
    this.currentField,
    this.input,
  });

  factory AiOnboardingChatMessageResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiOnboardingChatMessageResponse(
      reply: json['reply'],
      progress: json['progress'],
      completed: json['completed'],
      currentField: json['current_field'],
      input: json['input'] != null
          ? AiInputModel.fromJson(
              Map<String, dynamic>.from(json['input']),
            )
          : null,
    );
  }
}

class AiInputModel {
  final String? type;
  final List<String> options;

  AiInputModel({
    this.type,
    this.options = const [],
  });

  factory AiInputModel.fromJson(Map<String, dynamic> json) {
    return AiInputModel(
      type: json['type'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : const [],
    );
  }
}