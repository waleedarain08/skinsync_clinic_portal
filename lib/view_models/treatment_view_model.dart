import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/treatment_model.dart';
import '../models/requests/add_treatment_req_model.dart';
import 'base_view_model.dart';

final treatmentViewModelProvider = NotifierProvider<TreamententViewModel, TreatmentState>(
  () => TreamententViewModel._(),
);

class TreamententViewModel extends BaseViewModel<TreatmentState> {
  TreamententViewModel._();

  @override
  TreatmentState build() {
    init();
    ref.onDispose(dispose);
    return TreatmentState();
  }

  // Pre-configured realistic, high-fidelity medspa dummy treatments
  final List<TreatmentModel> _dummyTreatments = [
    TreatmentModel(
      id: 1,
      name: 'Botox Cosmetic Clinical Edition',
      price: 1500,
      description: 'Premium FDA-approved injectable treatment to temporarily reduce facial fine lines, forehead folds, and crow\'s feet wrinkles.',
      isArea: true,
      sideAreas: [
        SideAreaModel(id: 101, name: 'Forehead', perSyringePrice: 350.0, maxSyringe: 2),
        SideAreaModel(id: 102, name: 'Glabella Line', perSyringePrice: 400.0, maxSyringe: 1),
        SideAreaModel(id: 103, name: 'Crows Feet', perSyringePrice: 300.0, maxSyringe: 2),
      ],
    ),
    TreatmentModel(
      id: 2,
      name: 'Dermal Fillers (Juvederm Ultra)',
      price: 2400,
      description: 'Advanced hyaluronic acid volumizing filler treatment designed to restore skin elasticity, contour cheeks, and restore lip youthfulness.',
      isArea: true,
      sideAreas: [
        SideAreaModel(id: 201, name: 'Temples', perSyringePrice: 800.0, maxSyringe: 2),
        SideAreaModel(id: 202, name: 'Cheeks', perSyringePrice: 1200.0, maxSyringe: 3),
      ],
    ),
    TreatmentModel(
      id: 3,
      name: 'Laser Skin Resurfacing',
      price: 3500,
      description: 'Advanced fractional laser skin rejuvenation therapy to significantly boost collagen production and repair micro-texture scars.',
      isArea: false,
    ),
    TreatmentModel(
      id: 4,
      name: 'HydraFacial Platinum Therapy',
      price: 850,
      description: 'Ultra-smoothing multi-step deep cleansing, exfoliating, vacuum extraction, and antioxidant peptide hydration therapy.',
      isArea: false,
    ),
  ];

  Future<bool> getTreatments() async {
    state = state.copyWith(loading: true);
    // Simulate real network delay for high-fidelity visual loading state
    await Future.delayed(const Duration(milliseconds: 400));
    state = state.copyWith(treatments: [..._dummyTreatments], loading: false);
    return true;
  }

  Future<List<TreatmentModel>> getAdminTreatments() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [..._dummyTreatments];
  }

  Future<List<SideAreaModel>> getTreatmentsSideAreas({
    required int treatmentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final t = _dummyTreatments.firstWhere(
      (e) => e.id == treatmentId,
      orElse: () => _dummyTreatments.first,
    );
    return [...?t.sideAreas];
  }

  Future<bool> addClinicTreatment({
    required AddTreatmentReqModel treatment,
  }) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 400));

    final template = _dummyTreatments.firstWhere(
      (e) => e.id == treatment.treatmentId,
      orElse: () => TreatmentModel(id: treatment.treatmentId, name: "Custom Treatment"),
    );

    final newT = template.copyWith(
      price: treatment.treatmentPrice.toInt(),
      sideAreas: treatment.sideareas,
    );

    // Update in-memory collections
    if (!_dummyTreatments.any((e) => e.id == newT.id)) {
      _dummyTreatments.add(newT);
    }

    state = state.copyWith(treatments: [..._dummyTreatments], loading: false);
    return true;
  }

  Future<bool> editClinicTreatment({
    required AddTreatmentReqModel treatment,
  }) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _dummyTreatments.indexWhere((e) => e.id == treatment.treatmentId);
    if (index != -1) {
      _dummyTreatments[index] = _dummyTreatments[index].copyWith(
        price: treatment.treatmentPrice.toInt(),
        sideAreas: treatment.sideareas,
      );
    }

    state = state.copyWith(treatments: [..._dummyTreatments], loading: false);
    return true;
  }

  Future<bool> deleteTreatment({required int treatmentId}) async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 400));

    _dummyTreatments.removeWhere((e) => e.id == treatmentId);

    state = state.copyWith(treatments: [..._dummyTreatments], loading: false);
    return true;
  }

  void setTreatment(int treatmentId) {
    state = state.copyWith(selectedTreatmentId: treatmentId);
  }
}

class TreatmentState {
  final List<TreatmentModel> treatments;
  final int? selectedTreatmentId;
  final bool loading;

  TreatmentState({
    this.treatments = const [],
    this.loading = false,
    this.selectedTreatmentId,
  });

  TreatmentState copyWith({
    bool? loading,
    List<TreatmentModel>? treatments,
    int? selectedTreatmentId,
  }) {
    return TreatmentState(
      loading: loading ?? this.loading,
      treatments: treatments ?? this.treatments,
      selectedTreatmentId: selectedTreatmentId ?? this.selectedTreatmentId,
    );
  }
}
