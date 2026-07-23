import '../../utils/enums.dart';

final List<AppointmentModel> dummyAppointments = [
  const AppointmentModel(
    patientName: 'Sarah Johnson',
    treatment: 'Botox',
    date: '10/29/2025',
    time: '10:00 AM',
    doctor: 'Dr. Smith',
    amount: 350,
    status: AppointmentStatus.arrived,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'Emma Davis',
    treatment: 'Filler',
    date: '10/30/2025',
    time: '11:00 AM',
    doctor: 'Dr. Lee',
    amount: 450,
    status: AppointmentStatus.ongoing,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'James Brown',
    treatment: 'Laser',
    date: '04/16/2026',
    time: '09:00 AM',
    doctor: 'Dr. Smith',
    amount: 600,
    status: AppointmentStatus.delayed,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Olivia White',
    treatment: 'Hydrafacial',
    date: '04/16/2026',
    time: '02:00 PM',
    doctor: 'Dr. Adams',
    amount: 250,
    status: AppointmentStatus.noShow,
    isToday: true,
  ),
  const AppointmentModel(
    patientName: 'Liam Wilson',
    treatment: 'Microneedling',
    date: '04/17/2026',
    time: '03:00 PM',
    doctor: 'Dr. Lee',
    amount: 300,
    status: AppointmentStatus.completed,
    isToday: false,
  ),
  const AppointmentModel(
    patientName: 'Sophia Moore',
    treatment: 'Chemical Peel',
    date: '04/15/2026',
    time: '01:00 PM',
    doctor: 'Dr. Adams',
    amount: 200,
    status: AppointmentStatus.ongoing,
    isToday: false,
  ),
];

class AppointmentModel {
  final String patientName;
  final String treatment;
  final String date;
  final String time;
  final String doctor;
  final double amount;
  final AppointmentStatus status;
  final bool isToday;

  const AppointmentModel({
    required this.patientName,
    required this.treatment,
    required this.date,
    required this.time,
    required this.doctor,
    required this.amount,
    required this.status,
    required this.isToday,
  });
}
