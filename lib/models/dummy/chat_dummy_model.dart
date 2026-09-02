import '../../utils/enums.dart';

class ChatMessageModel {
  final String id;
  final String senderName;
  final String time;
  final bool isMe;
  final bool isRead;
  final ChatMessageType messageType;
  final String text;

  // Media attachment fields
  final String? mediaUrl;
  final String? mediaCaption;

  // Document attachment fields
  final String? documentName;
  final String? documentSize;
  final String? documentUrl;

  // Shared Request fields
  final ChatSharedRequestData? sharedRequestData;

  // Appointment fields
  final ChatAppointmentData? appointmentData;

  ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.messageType = ChatMessageType.normal,
    this.text = '',
    this.mediaUrl,
    this.mediaCaption,
    this.documentName,
    this.documentSize,
    this.documentUrl,
    this.sharedRequestData,
    this.appointmentData,
  });
}

class ChatSharedRequestData {
  final int requestId;
  final String patientName;
  final String treatmentName;
  final String dateShared;
  final String status;
  final String clinicName;

  ChatSharedRequestData({
    required this.requestId,
    required this.patientName,
    required this.treatmentName,
    required this.dateShared,
    required this.status,
    required this.clinicName,
  });
}

class ChatAppointmentData {
  final int appointmentId;
  final String patientName;
  final String serviceName;
  final String date;
  final String time;
  final String practitionerName;
  final String status;

  ChatAppointmentData({
    required this.appointmentId,
    required this.patientName,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.practitionerName,
    required this.status,
  });
}

/// Dummy messages list demonstrating all 5 chat types
final List<ChatMessageModel> dummyChatMessages = [
  ChatMessageModel(
    id: '1',
    senderName: 'Jane Cooper',
    time: '10:15 AM',
    isMe: false,
    messageType: ChatMessageType.normal,
    text: 'Hello doctor, I received the simulation results for Option 1.',
  ),
  ChatMessageModel(
    id: '2',
    senderName: 'You',
    time: '10:18 AM',
    isMe: true,
    isRead: true,
    messageType: ChatMessageType.normal,
    text:
        'Hi Jane! Great. Have you had a chance to review the before/after comparison?',
  ),
  ChatMessageModel(
    id: '3',
    senderName: 'Jane Cooper',
    time: '10:20 AM',
    isMe: false,
    messageType: ChatMessageType.media,
    text: 'Here is my current progress photo for your review.',
    mediaUrl:
        'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80',
    mediaCaption: 'Pre-treatment Skin Assessment Photo',
  ),
  ChatMessageModel(
    id: '4',
    senderName: 'You',
    time: '10:22 AM',
    isMe: true,
    isRead: true,
    messageType: ChatMessageType.document,
    text: 'Here is the detailed PDF outline for your upcoming treatment plan.',
    documentName: 'Facial_Rejuvenation_Option_1.pdf',
    documentSize: '1.4 MB',
  ),
  ChatMessageModel(
    id: '5',
    senderName: 'Jane Cooper',
    time: '10:25 AM',
    isMe: false,
    messageType: ChatMessageType.sharedRequest,
    text: 'I submitted a shared treatment request from Aesthetic Partner Clinic.',
    sharedRequestData: ChatSharedRequestData(
      requestId: 102,
      patientName: 'Jane Cooper',
      treatmentName: 'Botox & Dermal Fillers Combo',
      dateShared: 'Aug 28, 2026',
      status: 'Pending Review',
      clinicName: 'Aesthetic Beauty Center',
    ),
  ),
  ChatMessageModel(
    id: '6',
    senderName: 'You',
    time: '10:28 AM',
    isMe: true,
    isRead: true,
    messageType: ChatMessageType.appointment,
    text: 'I have scheduled your next follow-up appointment below.',
    appointmentData: ChatAppointmentData(
      appointmentId: 405,
      patientName: 'Jane Cooper',
      serviceName: 'Botox Follow-up & Touch-up Session',
      date: 'Sep 05, 2026',
      time: '10:00 AM',
      practitionerName: 'Dr. Sarah Johnson',
      status: 'Confirmed',
    ),
  ),
];
