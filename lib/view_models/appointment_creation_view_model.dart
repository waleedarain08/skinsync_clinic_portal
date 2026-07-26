import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient_model.dart';
import 'base_view_model.dart';

final appointmentCreationProvider =
    NotifierProvider<AppointmentCreationViewModel, AppointmentCreationState>(
        AppointmentCreationViewModel.new);

class AppointmentCreationState {
  final int currentStep;
  final PatientModel? selectedPatient;
  final List<PatientModel> searchResults;
  final bool isLoading;
  final String searchQuery;

  AppointmentCreationState({
    this.currentStep = 0,
    this.selectedPatient,
    this.searchResults = const [],
    this.isLoading = false,
    this.searchQuery = '',
  });

  AppointmentCreationState copyWith({
    int? currentStep,
    PatientModel? selectedPatient,
    List<PatientModel>? searchResults,
    bool? isLoading,
    String? searchQuery,
  }) {
    return AppointmentCreationState(
      currentStep: currentStep ?? this.currentStep,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class AppointmentCreationViewModel extends BaseViewModel<AppointmentCreationState> {
  @override
  AppointmentCreationState build() {
    return AppointmentCreationState();
  }

  // Dummy patients data
  final List<PatientModel> _dummyPatients = [
    PatientModel(
      id: 1,
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

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

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
      id: _dummyPatients.length + 1, // temporary ID
      name: name,
      email: email,
      phone: phone,
    );
    // In a real app, this would be an API call
    state = state.copyWith(selectedPatient: newPatient);
  }

  void clearSelection() {
    state = state.copyWith(selectedPatient: null);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
}
