import '../../utils/enums.dart';

class AppointmentModel {
  final String patientName;
  final String appointmentType;
  final String treatment;
  final String date;
  final String time;
  final String doctor;
  final double amount;
  final AppointmentStatus status;
  final bool isToday;

  const AppointmentModel({
    required this.patientName,
    this.appointmentType = 'Consultation',
    required this.treatment,
    required this.date,
    required this.time,
    required this.doctor,
    required this.amount,
    required this.status,
    required this.isToday,
  });
}

final List<AppointmentModel> dummyAppointments = [
  const AppointmentModel(
    patientName: 'Sarah Johnson',
    appointmentType: 'Consultation & Session',
    treatment: 'Botox (Lips), Botox (Cheeks), Dermal Filler (Eyes)',
    date: '10/29/2025',
    time: '10:00 AM',
    doctor: 'Dr. Sarah Smith',
    amount: 350,
    status: AppointmentStatus.arrived,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Emma Davis',
    appointmentType: 'Treatment Session',
    treatment: 'Botox (Forehead), Juvederm (Lips)',
    date: '10/30/2025',
    time: '11:00 AM',
    doctor: 'Dr. Michael Lee',
    amount: 450,
    status: AppointmentStatus.ongoing,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'James Brown',
    appointmentType: 'Follow-Up Session',
    treatment: 'Laser Treatment (Full Face), Healing Serum (Cheeks)',
    date: '04/16/2026',
    time: '09:00 AM',
    doctor: 'Dr. Sarah Smith',
    amount: 600,
    status: AppointmentStatus.delayed,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Olivia White',
    appointmentType: 'In-Person Consultation',
    treatment: 'Hydrafacial (T-Zone), Botox (Crow\'s Feet)',
    date: '04/16/2026',
    time: '02:00 PM',
    doctor: 'Dr. Adams',
    amount: 250,
    status: AppointmentStatus.noShow,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Liam Wilson',
    appointmentType: 'Treatment Session',
    treatment: 'Microneedling (Full Face), PRP (Scalp)',
    date: '04/17/2026',
    time: '03:00 PM',
    doctor: 'Dr. Michael Lee',
    amount: 300,
    status: AppointmentStatus.completed,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'Sophia Moore',
    appointmentType: 'Virtual Consultation',
    treatment: 'Chemical Peel (Face), Retinol Gel (Cheeks)',
    date: '04/15/2026',
    time: '01:00 PM',
    doctor: 'Dr. Adams',
    amount: 200,
    status: AppointmentStatus.ongoing,
    isToday: false,
  ),
];
