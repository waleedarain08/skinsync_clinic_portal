import '../ai_chat_message_model.dart';
import 'base_response_model.dart';

class AiOnboardingChatListResponse
    extends BaseResponse<AiOnboardingChatListData> {
  const AiOnboardingChatListResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AiOnboardingChatListResponse.fromJson(Map<String, dynamic> json) =>
      AiOnboardingChatListResponse(
        data: json["data"] == null
            ? null
            : AiOnboardingChatListData.fromJson(json["data"]),
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "is_success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class AiOnboardingChatListData {
  final List<AiChatMessageModel> items;
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  AiOnboardingChatListData({
    required this.items,
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory AiOnboardingChatListData.fromJson(Map<String, dynamic> json) =>
      AiOnboardingChatListData(
        items: json["items"] == null
            ? []
            : List<AiChatMessageModel>.from(
                json["items"].map((x) => AiChatMessageModel.fromJson(x)),
              ),
        limit: json["limit"] ?? 0,
        page: json["page"] ?? 0,
        total: json["total"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "items": items.map((x) => x.toJson()).toList(),
        "limit": limit,
        "page": page,
        "total": total,
        "total_pages": totalPages,
      };
}
