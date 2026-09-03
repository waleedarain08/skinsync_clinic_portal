class AiOnboardingChatMessageResponse  {
  final String? reply;
  final int? progress;

  AiOnboardingChatMessageResponse({this.reply, this.progress});

  factory AiOnboardingChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      AiOnboardingChatMessageResponse(
        reply: json["reply"],
        progress: json["progress"],
      );
}
