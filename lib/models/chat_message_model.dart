import '../utils/enums.dart';

class ChatMediaModel {
  final String? mediaUrl;
  final String? assetPath;
  final String? caption;
  final String? fileSize;

  const ChatMediaModel({
    this.mediaUrl,
    this.assetPath,
    this.caption,
    this.fileSize,
  });
}

class ChatDocumentModel {
  final String fileName;
  final String fileSize;
  final String? fileUrl;
  final String fileExtension;

  const ChatDocumentModel({
    required this.fileName,
    required this.fileSize,
    this.fileUrl,
    this.fileExtension = 'pdf',
  });
}

class ChatSharedRequestModel {
  final int requestId;
  final String patientName;
  final String treatmentName;
  final String status;
  final String requestedDate;
  final String? notes;

  const ChatSharedRequestModel({
    required this.requestId,
    required this.patientName,
    required this.treatmentName,
    required this.status,
    required this.requestedDate,
    this.notes,
  });
}

class ChatAppointmentModel {
  final int appointmentId;
  final String patientName;
  final String doctorName;
  final String treatmentName;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final String clinicLocation;

  const ChatAppointmentModel({
    required this.appointmentId,
    required this.patientName,
    required this.doctorName,
    required this.treatmentName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.clinicLocation,
  });
}

class ChatMessageModel {
  final String id;
  final String senderName;
  final ChatMessageType type;
  final String? text;
  final String time;
  final bool isMe;
  final bool isRead;
  final ChatMediaModel? media;
  final ChatDocumentModel? document;
  final ChatSharedRequestModel? sharedRequest;
  final ChatAppointmentModel? appointment;

  const ChatMessageModel({
    required this.id,
    required this.senderName,
    required this.type,
    this.text,
    required this.time,
    required this.isMe,
    this.isRead = false,
    this.media,
    this.document,
    this.sharedRequest,
    this.appointment,
  });
}

final List<ChatMessageModel> dummyChatMessages = [
  const ChatMessageModel(
    id: '1',
    senderName: 'Jane Cooper',
    type: ChatMessageType.text,
    text: 'Hello doctor, I received the simulation results for Option 1.',
    time: '10:15 AM',
    isMe: false,
  ),
  const ChatMessageModel(
    id: '2',
    senderName: 'You',
    type: ChatMessageType.text,
    text:
        'Hi Jane! Great. Have you had a chance to review the before/after comparison?',
    time: '10:18 AM',
    isMe: true,
    isRead: true,
  ),
  const ChatMessageModel(
    id: '3',
    senderName: 'Jane Cooper',
    type: ChatMessageType.media,
    text: 'Yes, here is the photo of the treatment area I wanted to clarify.',
    time: '10:19 AM',
    isMe: false,
    media: ChatMediaModel(
      assetPath: 'assets/png/before_after.png',
      caption: 'Pre-treatment area snapshot',
      fileSize: '2.8 MB',
    ),
  ),
  const ChatMessageModel(
    id: '4',
    senderName: 'Jane Cooper',
    type: ChatMessageType.document,
    text: 'Here is the simulation summary document I was referring to.',
    time: '10:21 AM',
    isMe: false,
    document: ChatDocumentModel(
      fileName: 'Facial_Rejuvenation_Option_1.pdf',
      fileSize: '1.4 MB',
      fileExtension: 'pdf',
    ),
  ),
  const ChatMessageModel(
    id: '5',
    senderName: 'You',
    type: ChatMessageType.sharedRequest,
    text:
        'I have created a shared treatment request for your case. Please review the details below.',
    time: '10:22 AM',
    isMe: true,
    isRead: true,
    sharedRequest: ChatSharedRequestModel(
      requestId: 104,
      patientName: 'Jane Cooper',
      treatmentName: 'Botox & Dermal Fillers Protocol',
      status: 'Pending Review',
      requestedDate: 'Aug 28, 2026',
      notes: 'Plan includes 2 sessions with 4-week gap between injections.',
    ),
  ),
  const ChatMessageModel(
    id: '6',
    senderName: 'You',
    type: ChatMessageType.appointment,
    text: 'I have scheduled your upcoming session slot.',
    time: '10:25 AM',
    isMe: true,
    isRead: true,
    appointment: ChatAppointmentModel(
      appointmentId: 308,
      patientName: 'Jane Cooper',
      doctorName: 'Dr. Sarah Jenkins',
      treatmentName: 'Botox Consultation & Injection',
      appointmentDate: 'Sep 05, 2026',
      appointmentTime: '10:00 AM - 10:45 AM',
      status: 'Confirmed',
      clinicLocation: 'Main MedSpa Suite 3B',
    ),
  ),
];
