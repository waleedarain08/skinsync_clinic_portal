import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../exceptions/app_exception.dart';
import '../models/requests/register_doctor_request.dart';
import '../models/requests/update_doctors_treament_request.dart';
import '../models/treatment_model.dart';
import '../services/locator.dart';
import '../services/media_service.dart';

import '../models/responses/register_doctor_response.dart';
import '../services/doctor_service.dart';
import 'base_view_model.dart';

final doctorProvider =
    NotifierProvider.autoDispose<DoctorViewModel, DoctorState>(
      () => DoctorViewModel._(),
    );

class DoctorViewModel extends BaseViewModel<DoctorState> {
  DoctorViewModel._();
  final ImagePicker _picker = ImagePicker();
  @override
  DoctorState build() {
    init();
    ref.onDispose(dispose);
    return DoctorState(
      country: CountryCode.fromCountryCode(
        'US',
      ),
    );
  }

  void changeRole(String? role) {
    if (state.role == role) {
      return;
    }
    state = state.copyWith(role: role);
  }

  void setCountry(CountryCode country) {
    state = state.copyWith(
      country: country,
      cc: country.dialCode,
      countryIso: country.code,
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

  Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return await runSafely(() async {
      const path = 'doctor/';
      final String? url = await MediaService().uploadImage(path, image);

      if (url == null) {
        throw const UnknownException(message: 'Failed to upload image');
      }

      return url;
    });
  }

  Future<void> registerDoctor({
    required String name,
    required String specialization,
    required String email,
    required String phone,
    required int consultationFee,
    String? image,
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

      await locator<DoctorService>().register(
        request: RegisterDoctorRequest(
          role: state.role!,
          name: name,
          image: image,
          specialization: specialization,
          contactInfo: ContactInfo(
            email: email,
            phone: phone,
            cc: state.country.dialCode!,
            country: state.country.name!,
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
    String? image,
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
  final String? role;
  final List<TreatmentModel> treatments;
  final List<Doctor> doctors;
  final Doctor? selectedDoctor;
  final bool success;
  final List<Availability> availability;
  final CountryCode country;
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
    required this.country,
    this.cc,
    this.countryCode,
  });

  DoctorState copyWith({
    bool? loading,
    String? role,
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
    String? role,
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
      country: country,
      cc: cc,
      countryCode: countryCode,
    );
  }
}
