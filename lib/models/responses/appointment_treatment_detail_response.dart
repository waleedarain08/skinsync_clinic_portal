import 'base_response_model.dart';

class AppointmentTreatmentDetailResponse extends BaseApiResponseModel<AppointmentTreatmentDetailData> {
  AppointmentTreatmentDetailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AppointmentTreatmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentTreatmentDetailResponse(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : AppointmentTreatmentDetailData.fromJson(json["data"]),
      );
}

class AppointmentTreatmentDetailData {
  final int? treatmentId;
  final String? treatmentName;
  final String? areaName;
  final String? status;
  final CurrentSession? currentSession;
  final List<TreatmentHistoryItem>? history;

  AppointmentTreatmentDetailData({
    this.treatmentId,
    this.treatmentName,
    this.areaName,
    this.status,
    this.currentSession,
    this.history,
  });

  factory AppointmentTreatmentDetailData.fromJson(Map<String, dynamic> json) => AppointmentTreatmentDetailData(
        treatmentId: json["treatment_id"],
        treatmentName: json["treatment_name"],
        areaName: json["area_name"],
        status: json["status"],
        currentSession: json["current_session"] == null ? null : CurrentSession.fromJson(json["current_session"]),
        history: json["history"] == null
            ? []
            : List<TreatmentHistoryItem>.from(json["history"].map((x) => TreatmentHistoryItem.fromJson(x))),
      );
}

class CurrentSession {
  final int? sessionNumber;
  final String? date;
  final String? consentFormUrl;
  final List<String>? protocols;
  final String? instructions;

  CurrentSession({
    this.sessionNumber,
    this.date,
    this.consentFormUrl,
    this.protocols,
    this.instructions,
  });

  factory CurrentSession.fromJson(Map<String, dynamic> json) => CurrentSession(
        sessionNumber: json["session_number"],
        date: json["date"],
        consentFormUrl: json["consent_form_url"],
        protocols: json["protocols"] == null ? [] : List<String>.from(json["protocols"].map((x) => x)),
        instructions: json["instructions"],
      );
}

class TreatmentHistoryItem {
  final int? id;
  final String? type;
  final String? date;
  final String? provider;
  final String? summary;

  TreatmentHistoryItem({
    this.id,
    this.date,
    this.type,
    this.provider,
    this.summary,
  });

  factory TreatmentHistoryItem.fromJson(Map<String, dynamic> json) => TreatmentHistoryItem(
        id: json["id"],
        type: json["type"],
        date: json["date"],
        provider: json["provider"],
        summary: json["summary"],
      );
}
