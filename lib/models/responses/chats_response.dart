import 'base_response_model.dart';

class ChatsResponse extends BaseResponse<ChatsData> {
  ChatsResponse({required super.success, required super.message, super.data});

  factory ChatsResponse.fromJson(Map<String, dynamic> json) => ChatsResponse(
    success: json["is_success"],
    message: json["message"],
    data: json["data"] == null ? null : ChatsData.fromJson(json["data"]),
  );
}

class ChatsData {
  final List<Chat>? items;
  final int? limit;
  final int? page;
  final int? total;
  final int? totalPages;

  ChatsData({this.items, this.limit, this.page, this.total, this.totalPages});

  factory ChatsData.fromJson(Map<String, dynamic> json) => ChatsData(
    items: json["items"] == null
        ? []
        : List<Chat>.from(json["items"]!.map((x) => Chat.fromJson(x))),
    limit: json["limit"],
    page: json["page"],
    total: json["total"],
    totalPages: json["total_pages"],
  );
}

class Chat {
  final int? id;
  final String? patientName;
  final String? lastMessage;
  final DateTime? time;
  final int unreadCount;
  final bool isOnline;

  Chat({
    this.id,
    this.patientName,
    this.lastMessage,
    this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    patientName: json["patient_name"],
    lastMessage: json["last_message"],
    time: DateTime.tryParse(json["time"] ?? ''),
    unreadCount: json["unread_count"] ?? 0,
    isOnline: json["is_online"] ?? false,
  );
}
