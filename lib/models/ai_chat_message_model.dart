import '../utils/enums.dart';

class AiChatMessageModel {
  final String id;
  final String senderName;
  final String time;
  final bool isAi;
  final bool isMe;
  final String text;
  final AiChatMessageType messageType;
  final List<String>? options;
  final AiTreatmentDraftData? treatmentDraftData;

  AiChatMessageModel({
    required this.id,
    required this.senderName,
    required this.time,
    this.isAi = true,
    required this.isMe,
    this.text = '',
    this.messageType = AiChatMessageType.text,
    this.options,
    this.treatmentDraftData,
  });

  factory AiChatMessageModel.fromJson(Map<String, dynamic> json) {
    return AiChatMessageModel(
      id: json['id']?.toString() ?? '',
      senderName: json['sender_name'] ?? 'SkinSync AI',
      time: json['time'] ?? '',
      isAi: json['is_ai'] ?? true,
      isMe: json['is_me'] ?? false,
      text: json['text'] ?? '',
      messageType: AiChatMessageType.fromValue(json['message_type']),
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      treatmentDraftData: json['treatment_draft_data'] != null
          ? AiTreatmentDraftData.fromJson(json['treatment_draft_data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_name': senderName,
        'time': time,
        'is_ai': isAi,
        'is_me': isMe,
        'text': text,
        'message_type': messageType.value,
        if (options != null) 'options': options,
        if (treatmentDraftData != null)
          'treatment_draft_data': treatmentDraftData!.toJson(),
      };
}

class AiTreatmentDraftData {
  final String treatmentName;
  final String category;
  final String subcategory;
  final String price;
  final int sessions;
  final String downtime;
  final String allowedRoles;

  AiTreatmentDraftData({
    required this.treatmentName,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.sessions,
    required this.downtime,
    required this.allowedRoles,
  });

  factory AiTreatmentDraftData.fromJson(Map<String, dynamic> json) {
    return AiTreatmentDraftData(
      treatmentName: json['treatment_name'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      price: json['price'] ?? '',
      sessions: json['sessions'] ?? 1,
      downtime: json['downtime'] ?? 'None',
      allowedRoles: json['allowed_roles'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'treatment_name': treatmentName,
        'category': category,
        'subcategory': subcategory,
        'price': price,
        'sessions': sessions,
        'downtime': downtime,
        'allowed_roles': allowedRoles,
      };
}
