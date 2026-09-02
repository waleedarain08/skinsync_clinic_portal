import 'base_response_model.dart';

typedef ChatMessageListResponse = ChatsMessageListResponse;

class ChatsMessageListResponse extends BaseResponse<ChatsMessageListData> {
  const ChatsMessageListResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory ChatsMessageListResponse.fromJson(Map<String, dynamic> json) =>
      ChatsMessageListResponse(
        data: json["data"] == null
            ? null
            : ChatsMessageListData.fromJson(json["data"]),
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "is_success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class ChatsMessageListData {
  final List<ChatMessageListItem> items;
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  ChatsMessageListData({
    required this.items,
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory ChatsMessageListData.fromJson(Map<String, dynamic> json) =>
      ChatsMessageListData(
        items: json["items"] == null
            ? []
            : List<ChatMessageListItem>.from(
                json["items"].map((x) => ChatMessageListItem.fromJson(x)),
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

class ChatMessageListItem {
  final String id;
  final String senderName;
  final String time;
  final bool isMe;
  final bool isRead;
  final String messageType;
  final String text;
  final String? mediaUrl;
  final String? mediaCaption;
  final String? documentName;
  final String? documentSize;
  final String? documentUrl;
  final String? createdAt;

  ChatMessageListItem({
    required this.id,
    required this.senderName,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.messageType = 'normal',
    this.text = '',
    this.mediaUrl,
    this.mediaCaption,
    this.documentName,
    this.documentSize,
    this.documentUrl,
    this.createdAt,
  });

  factory ChatMessageListItem.fromJson(Map<String, dynamic> json) =>
      ChatMessageListItem(
        id: json["id"]?.toString() ?? "",
        senderName: json["sender_name"] ?? "",
        time: json["time"] ?? "",
        isMe: json["is_me"] ?? false,
        isRead: json["is_read"] ?? false,
        messageType: json["message_type"] ?? "normal",
        text: json["text"] ?? "",
        mediaUrl: json["media_url"],
        mediaCaption: json["media_caption"],
        documentName: json["document_name"],
        documentSize: json["document_size"],
        documentUrl: json["document_url"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_name": senderName,
        "time": time,
        "is_me": isMe,
        "is_read": isRead,
        "message_type": messageType,
        "text": text,
        "media_url": mediaUrl,
        "media_caption": mediaCaption,
        "document_name": documentName,
        "document_size": documentSize,
        "document_url": documentUrl,
        "created_at": createdAt,
      };
}
