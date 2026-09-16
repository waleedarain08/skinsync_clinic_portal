import 'base_request.dart';

class AvailabilityRequest extends BaseRequest{
  final int doctorId;
  final int date;
  final List<int> sessionIds;

  AvailabilityRequest({
    required this.doctorId,
    required this.date,
    required this.sessionIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'date': date,
      'session_ids': sessionIds,
    };
  }
}