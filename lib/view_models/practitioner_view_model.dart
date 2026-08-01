import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../exceptions/app_exception.dart';
import '../models/requests/register_practitioner_request.dart';
import '../models/requests/status_request.dart';
import '../models/requests/update_practitioner_treament_request.dart';
import '../models/responses/practitioner_list_response.dart';
import '../models/responses/register_practitioner_response.dart';
import '../models/treatment_model.dart';
import '../services/locator.dart';
import '../services/media_service.dart';

    
import '../services/practitioner_service.dart';
import 'base_view_model.dart';

final practitionerProvider =
    NotifierProvider.autoDispose<PractitionerViewModel, PractitionerState>(
      () => PractitionerViewModel._(),
    );

class PractitionerViewModel extends BaseViewModel<PractitionerState> {
  PractitionerViewModel._();
  final ImagePicker _picker = ImagePicker();
  @override
  PractitionerState build() {
    init();
    ref.onDispose(dispose);
    return PractitionerState(country: CountryCode.fromCountryCode('US'));
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

  void removeDocument(String url) {
    final docs = List<String>.from(state.documents);
    docs.remove(url);

    state = state.copyWith(documents: docs);
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

  Future<String?> pickAndUploadDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final file = result.files.first;

    return await runSafely(() async {
      final url = await MediaService().uploadMedia(
        path: 'doctor/doucment/',
        file: file,
      );

      if (url == null) {
        throw const UnknownException(message: 'Failed to upload document');
      }

      state = state.copyWith(documents: [...state.documents, url]);

      return url;
    });
  }

  void clearDocuments() {
    state = state.copyWith(documents: []);
  }

  Future<void> registerPractitioner({
    required BasicInfo basicInfo,
    required ContactInfo contactInfo,
    required LicenseInfo licenseInfo,
    required ClinicAccess clinicAccess,
    required AvailabilityInfo availabilityInfo,
    required FinancialInfo financialInfo,
  }) async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);

      await locator<PractitionerService>().register(
        request: RegisterPractitionerRequest(
          basicInfo: basicInfo,
          contactInfo: contactInfo,
          licenseInfo: licenseInfo,
          clinicAccess: clinicAccess,
          availabilityInfo: availabilityInfo,
          financialInfo: financialInfo,
        ),
      );
      state = state.copyWith(loading: false, success: true);
    });
  }

  Future<void> getPractitioner({ bool showLoading = true}) async {
    return await runSafely(() async {
      state = state.copyWith(loading: showLoading);
      final doctors = await locator<PractitionerService>().fetchPractitioner();
      state = state.copyWith(loading: false, doctors: doctors);
    }, showLoading: false);
  }

  Future<void> getPractitionerDetail({required int id}) async {
    return await runSafely(() async {
      final doctors = await locator<PractitionerService>()
          .fetchPractitionerDetail(id: id);
      if (doctors.isSuccess) {
        state = state.copyWith(practitioner: doctors.data);
      }
    });
  }

    Future<void> deletePractitioner({required int id}) async {
    return await runSafely(() async {
      final doctors = await locator<PractitionerService>()
          .deletePractitioner(id: id);
      if (doctors.success) {
        await getPractitioner(showLoading: false);
      }
    });
  }
    Future<void> updatePractitionerStatus({required int id,required StatusRequest request}) async {
    return await runSafely(() async {
      final doctors = await locator<PractitionerService>()
          .updatePractitionerStatus(id: id,request: request);
      if (doctors.success) {
      await getPractitioner(showLoading: false);
      }
    });
  }


  Future<void> updatePractitionerTreatment({
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
      final request = UpdatePractitionerRequest(
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

      await locator<PractitionerService>().updatePractitionerTreatment(
        request: request,
      );

      state = state.copyWith(loading: false, success: true);
    });
  }

  void setSelectedDoctor(PractitionerListItem doctor) {
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

class PractitionerState {
  final bool loading;
  final String? role;
  final List<TreatmentModel> treatments;
  final List<PractitionerListItem> doctors;
  final PractitionerListItem? selectedDoctor;
  final Practitioner? practitioner;
  final bool success;
  final List<Availability> availability;
  final CountryCode country;
  final String? cc;
  final String? countryCode;
  final List<String> documents;

  const PractitionerState({
    this.role,
    this.loading = false,
    this.treatments = const [],
    this.doctors = const [],
    this.selectedDoctor,
    this.success = false,
    this.availability = const [],
    required this.country,
    this.documents = const [],
    this.cc,
    this.countryCode,
    this.practitioner,
  });

  PractitionerState copyWith({
    bool? loading,
    String? role,
    List<TreatmentModel>? treatments,
    List<PractitionerListItem>? doctors,
    PractitionerListItem? selectedDoctor,
    bool? success,
    List<Availability>? availability,
    CountryCode? country,
    String? cc,
    String? countryIso,
    List<String>? documents,
    Practitioner? practitioner,
  }) {
    return PractitionerState(
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
      documents: documents ?? this.documents,
      practitioner: practitioner ?? this.practitioner,
    );
  }

  PractitionerState copyWithNull({
    bool? loading,
    String? role,
    List<TreatmentModel>? treatments,
    List<PractitionerListItem>? doctors,
    Practitioner? practitioner,
    List<String>? documents,
    bool? success,
  }) {
    return PractitionerState(
      loading: loading ?? this.loading,
      role: role,
      treatments: treatments ?? this.treatments,
      doctors: doctors ?? this.doctors,
      practitioner: practitioner ?? this.practitioner,
      success: success ?? false,
      country: country,
      cc: cc,
      countryCode: countryCode,
      documents: documents ?? this.documents,
    );
  }
}
