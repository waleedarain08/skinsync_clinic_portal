import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient_model.dart';
import '../models/requests/create_appointment_request.dart';
import '../repositories/appointment_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final appointmentCreationProvider =
    NotifierProvider<AppointmentCreationViewModel, AppointmentCreationState>(
        AppointmentCreationViewModel.new);

class AppointmentCreationState {
  final PatientModel? selectedPatient;
  final List<PatientModel> searchResults;
  final bool isLoading;
  final String searchQuery;

  AppointmentCreationState({
    this.selectedPatient,
    this.searchResults = const [],
    this.isLoading = false,
    this.searchQuery = '',
  });

  AppointmentCreationState copyWith({
    PatientModel? selectedPatient,
    List<PatientModel>? searchResults,
    bool? isLoading,
    String? searchQuery,
  }) {
    return AppointmentCreationState(
      selectedPatient: selectedPatient ?? this.selectedPatient,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AppointmentCreationViewModel
    extends BaseViewModel<AppointmentCreationState> {
  @override
  AppointmentCreationState build() {
    return AppointmentCreationState();
  }

  // Dummy patients data for search
  final List<PatientModel> _dummyPatients = [
    PatientModel(
      id: 12,
      name: 'Sarah Johnson',
      email: 'sarah.johnson@email.com',
      phone: '+1 (555) 0192',
      gender: 'Female',
    ),
    PatientModel(
      id: 2,
      name: 'Michael Brown',
      email: 'michael.brown@email.com',
      phone: '+1 (555) 0143',
      gender: 'Male',
    ),
    PatientModel(
      id: 3,
      name: 'Alyssa Davis',
      email: 'alyssa.davis@email.com',
      phone: '+1 (555) 0188',
      gender: 'Female',
    ),
    PatientModel(
      id: 4,
      name: 'Emily Wilson',
      email: 'emily.wilson@email.com',
      phone: '+1 (555) 0177',
      gender: 'Female',
    ),
    PatientModel(
      id: 5,
      name: 'James Taylor',
      email: 'james.taylor@email.com',
      phone: '+1 (555) 0199',
      gender: 'Male',
    ),
  ];

  void searchPatients(String query) {
    state = state.copyWith(searchQuery: query);
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    final results = _dummyPatients.where((p) {
      final q = query.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.email.toLowerCase().contains(q) ||
          p.phone.contains(q);
    }).toList();

    state = state.copyWith(searchResults: results);
  }

  void selectPatient(PatientModel patient) {
    state = state.copyWith(selectedPatient: patient);
  }

  void registerNewPatient({
    required String name,
    required String email,
    required String phone,
  }) {
    final newPatient = PatientModel(
      id: _dummyPatients.length + 12,
      name: name,
      email: email,
      phone: phone,
    );
    state = state.copyWith(selectedPatient: newPatient);
  }

  void clearSelection() {
    state = state.copyWith(selectedPatient: null);
  }

  Future<bool> createAppointment({
    required CreateAppointmentRequest request,
  }) async {
    final result = await runSafely(() async {
      state = state.copyWith(isLoading: true);
      final repository = locator<AppointmentRepository>();
      final response = await repository.createAppointment(request: request);
      state = state.copyWith(isLoading: false);
      return response.success;
    });

    state = state.copyWith(isLoading: false);
    return result ?? false;
  }
}
