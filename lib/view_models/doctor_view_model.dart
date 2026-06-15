import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/requests/register_doctor_request.dart';
import '../models/requests/update_doctors_treament_request.dart';
import '../models/treatment_model.dart';
import '../services/locator.dart';
import '../services/media_service.dart';

import '../models/responses/register_doctor_response.dart';
import '../services/doctor_service.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final doctorProvider =
    NotifierProvider.autoDispose<DoctorViewModel, DoctorState>(
  () => DoctorViewModel._(),
);

class DoctorViewModel extends BaseViewModel<DoctorState> {
  DoctorViewModel._();

  @override
  DoctorState build() {
    init();
    ref.onDispose(dispose);
    return const DoctorState();
  }

  void changeRole(DoctorRole? role) {
    if (state.role == role) {
      return;
    }
    state = state.copyWith(role: role);
  }

  void setCountry(CountryCode? country) {
    state = state.copyWith(
      country: country,
      cc: country?.dialCode,
      countryIso: country?.code,
    );
  }

  void setInitialTreatments(List<TreatmentModel> treatments) {
    state = state.copyWith(treatments: treatments);
  }

  void toggleSelectedTreatment(TreatmentModel treatment) {
    // If treatment with same id exists, update/replace it instead of removing.
    final index = state.treatments.indexWhere((t) => t.id == treatment.id);
    if (index != -1) {
      final newList = List<TreatmentModel>.from(state.treatments);
      newList[index] = treatment;
      state = state.copyWith(treatments: newList);
      return;
    }

    // Otherwise, add as a new treatment.
    if (treatment.id == null) {
      return;
    }
    state = state.copyWith(treatments: [treatment, ...state.treatments]);
  }

  Future<void> registerDoctor({
    required String name,
    required String specialization,
    required String email,
    required String phone,
    required int consultationFee,
    XFile? image,
  }) async {
    return await runSafely(() async {
      if (state.role == null) {
        throw Exception('Role not selected!');
      }
      if (state.treatments.isEmpty) {
        throw Exception('Add treatments first!');
      }
      if (state.availability.isEmpty) {
        throw Exception('Add slots first!');
      }
      state = state.copyWith(loading: true);
      String? imageUrl;
      if (image != null) {
        imageUrl = await locator<MediaService>().uploadImage(email, image);
      }
      await locator<DoctorService>().register(
        request: RegisterDoctorRequest(
          role: state.role!,
          name: name,
          image: imageUrl,
          specialization: specialization,
          contactInfo: ContactInfo(
            email: email,
            phone: phone,
            cc: state.cc!,
            country: state.countryCode!,
          ),
          treatments: state.treatments,
          availability: state.availability,
          consultationFee: consultationFee,
        ),
      );
      state = state.copyWith(loading: false, success: true);
    });
  }

  Future<void> getDoctors() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final doctors = await locator<DoctorService>().fetchDoctors();
      state = state.copyWith(
        loading: false,
        doctors: doctors,
        selectedDoctor: doctors.firstOrNull,
      );
    }, showLoading: false);
  }

  Future<void> updateDoctorTreatment({
    required String email,
    required int clinicUserId,
    required String name,
    required String specialization,
    required String phone,
    XFile? image,
  }) async {
    return await runSafely(() async {
      if (state.treatments.isEmpty) {
        throw Exception('Add treatments first!');
      }
      if (state.availability.isEmpty) {
        throw Exception('Add at least one slot!');
      }

      state = state.copyWith(loading: true);
      String? imageUrl;
      if (image != null) {
        imageUrl = await locator<MediaService>().uploadImage(email, image);
      }
      final request = UpdateDoctorRequest(
        clinicUserId: clinicUserId,
        name: name,
        specialization: specialization,
        phone: phone,
        cc: state.cc,
        country: state.countryCode,
        availability: state.availability,
        image: imageUrl,
        treatments: state.treatments.map((t) {
          return UpdateTreatmentRequest(
            treatmentId: t.id!,
            treatmentsSubSecId: t.sideAreas?.map((s) => s.id!).toList() ?? [],
          );
        }).toList(),
      );

      await locator<DoctorService>().updateDoctorTreatment(request: request);

      state = state.copyWith(loading: false, success: true);
    });
  }

  void setSelectedDoctor(Doctor doctor) {
    state = state.copyWith(selectedDoctor: doctor);
  }

  void clearData() {
    state = state.copyWithNull(treatments: [], role: null);
  }

  void setInitialAvailability(List<Availability>? availability) {
    if (availability == null) {
      return;
    }
    state = state.copyWith(availability: availability);
  }

  void setAvailability(Availability? availability) {
    if (availability == null) {
      log('No availability');
      return;
    }
    state = state.copyWith(availability: [availability, ...state.availability]);
  }

  void deleteAvailability(Availability availability) {
    final newList = List.of(state.availability);
    newList.remove(availability);
    state = state.copyWith(availability: newList);
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}

class DoctorState {
  final bool loading;
  final DoctorRole? role;
  final List<TreatmentModel> treatments;
  final List<Doctor> doctors;
  final Doctor? selectedDoctor;
  final bool success;
  final List<Availability> availability;
  final CountryCode? country;
  final String? cc;
  final String? countryCode;

  const DoctorState({
    this.role,
    this.loading = false,
    this.treatments = const [],
    this.doctors = const [],
    this.selectedDoctor,
    this.success = false,
    this.availability = const [],
    this.country,
    this.cc,
    this.countryCode,
  });

  DoctorState copyWith({
    bool? loading,
    DoctorRole? role,
    List<TreatmentModel>? treatments,
    List<Doctor>? doctors,
    Doctor? selectedDoctor,
    bool? success,
    List<Availability>? availability,
    CountryCode? country,
    String? cc,
    String? countryIso,
  }) {
    return DoctorState(
      loading: loading ?? this.loading,
      role: role ?? this.role,
      treatments: treatments ?? this.treatments,
      doctors: doctors ?? this.doctors,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      success: success ?? false,
      availability: availability ?? this.availability,
      country: country ?? this.country,
      cc: cc ?? this.cc,
      countryCode: countryIso ?? countryCode,
    );
  }

  DoctorState copyWithNull({
    bool? loading,
    DoctorRole? role,
    List<TreatmentModel>? treatments,
    List<Doctor>? doctors,
    bool? success,
  }) {
    return DoctorState(
      loading: loading ?? this.loading,
      role: role,
      treatments: treatments ?? this.treatments,
      doctors: doctors ?? this.doctors,
      success: success ?? false,
    );
  }
}
