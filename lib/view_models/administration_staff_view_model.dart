import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/administration_staff_response.dart';
import 'base_view_model.dart';

class AdministrationStaffState {
  final List<AdministrationStaffListItem> staff;
  final AdministrationStaffListItem? selectedStaff;
  final bool loading;
  final String? error;
  final bool success;

  AdministrationStaffState({
    this.staff = const [],
    this.selectedStaff,
    this.loading = false,
    this.error,
    this.success = false,
  });

  AdministrationStaffState copyWith({
    List<AdministrationStaffListItem>? staff,
    AdministrationStaffListItem? selectedStaff,
    bool? loading,
    String? error,
    bool? success,
  }) {
    return AdministrationStaffState(
      staff: staff ?? this.staff,
      selectedStaff: selectedStaff ?? this.selectedStaff,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      success: success ?? this.success,
    );
  }
}

final administrationStaffProvider =
    NotifierProvider<AdministrationStaffViewModel, AdministrationStaffState>(
  () => AdministrationStaffViewModel(),
);

class AdministrationStaffViewModel extends BaseViewModel<AdministrationStaffState> {
  @override
  AdministrationStaffState build() {
    init();
    Future.microtask(() => getStaff());
    return AdministrationStaffState();
  }

  void getStaff() async {
    state = state.copyWith(loading: true);
    
    // Simulate API call with dummy data
    await Future.delayed(const Duration(seconds: 1));
    
    final dummyStaff = [
      AdministrationStaffListItem(
        id: 1,
        name: "John Doe",
        email: "john.doe@clinic.com",
        phone: "+1 234 567 890",
        role: "Clinic Manager",
        status: "active",
        image: "",
      ),
      AdministrationStaffListItem(
        id: 2,
        name: "Jane Smith",
        email: "jane.smith@clinic.com",
        phone: "+1 234 567 891",
        role: "Receptionist",
        status: "active",
        image: "",
      ),
      AdministrationStaffListItem(
        id: 3,
        name: "Michael Brown",
        email: "michael.b@clinic.com",
        phone: "+1 234 567 892",
        role: "Accountant",
        status: "inactive",
        image: "",
      ),
    ];

    state = state.copyWith(staff: dummyStaff, loading: false);
  }

  Future<void> getStaffDetail(int id) async {
    state = state.copyWith(loading: true);
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      final staffMember = state.staff.firstWhere((s) => s.id == id);
      // Enrich with more details for the detail screen
      final detailedStaff = AdministrationStaffListItem(
        id: staffMember.id,
        name: staffMember.name,
        email: staffMember.email,
        phone: staffMember.phone,
        role: staffMember.role,
        status: staffMember.status,
        image: staffMember.image,
        address: "123 Clinic Street, Medical District, NY",
        joinDate: "2023-01-15",
        department: "Operations",
      );
      state = state.copyWith(selectedStaff: detailedStaff, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: "Staff member not found");
    }
  }

  void updateStaffStatus(int id, String newStatus) {
    final updatedStaff = state.staff.map((s) {
      if (s.id == id) {
        return AdministrationStaffListItem(
          id: s.id,
          name: s.name,
          email: s.email,
          phone: s.phone,
          role: s.role,
          status: newStatus,
          image: s.image,
        );
      }
      return s;
    }).toList();
    state = state.copyWith(staff: updatedStaff);
  }

  void deleteStaff(int id) {
    final updatedStaff = state.staff.where((s) => s.id != id).toList();
    state = state.copyWith(staff: updatedStaff);
  }
}
