
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/create_protocol_field_request.dart';
import '../models/treatment_data_models.dart';
import '../repositories/treatment_repository.dart';
import '../services/locator.dart';

final treatmentDataViewModelProvider =
    NotifierProvider<TreatmentDataViewModel, TreatmentDataState>(
      TreatmentDataViewModel.new,
    );

class TreatmentDataState {

  final List<ProtocolItem> protocols;

  TreatmentDataState({this.protocols = const []});

  TreatmentDataState copyWith({
  
    List<ProtocolItem>? protocols,
  }) {
    return TreatmentDataState(
    
      protocols: protocols ?? this.protocols,
    );
  }
}

class TreatmentDataViewModel extends Notifier<TreatmentDataState> {
  @override
  TreatmentDataState build() {
    // final areas = [
    //   AreaModel(
    //     name: 'Face',
    //     globalSku: 'FACE-1000',
    //     subAreas: [
    //       SubAreaItem(
    //         name: 'Upper Face',
    //         globalSku: 'FACE-1100',
    //         children: [
    //           SubAreaChildItem(name: 'Forehead', globalSku: 'FACE-1110'),
    //           SubAreaChildItem(name: 'Glabella', globalSku: 'FACE-1120'),
    //         ],
    //       ),
    //       SubAreaItem(
    //         name: 'Mid Face',
    //         globalSku: 'FACE-1200',
    //         children: [
    //           SubAreaChildItem(name: 'Cheeks', globalSku: 'FACE-1210'),
    //           SubAreaChildItem(name: 'Under Eyes', globalSku: 'FACE-1220'),
    //         ],
    //       ),
    //       SubAreaItem(
    //         name: 'Forehead',
    //         globalSku: 'FORE-5000',
    //         children: [
    //           SubAreaChildItem(name: 'Left Forehead', globalSku: 'FORE-5100'),
    //           SubAreaChildItem(name: 'Right Forehead', globalSku: 'FORE-5200'),
    //           SubAreaChildItem(
    //             name: 'Central Forehead',
    //             globalSku: 'FORE-5300',
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    //   AreaModel(
    //     name: 'Neck',
    //     globalSku: 'NECK-2000',
    //     subAreas: [
    //       SubAreaItem(name: 'Full Neck', globalSku: 'NECK-2100'),
    //       SubAreaItem(name: 'Neck Bands', globalSku: 'NECK-2200'),
    //     ],
    //   ),
    // ];

    return TreatmentDataState(
    
      protocols: [
      ],
    );
  }

  // --- Protocol Actions ---

  void addProtocol(String title, ProtocolType type) {
    if (title.isEmpty) return;
    final newProtocol = ProtocolItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      type: type,
    );
    state = state.copyWith(protocols: [...state.protocols, newProtocol]);
  }

  void editProtocol(String id, String newTitle) {
    state = state.copyWith(
      protocols: state.protocols.map((p) {
        if (p.id == id) {
          return p.copyWith(title: newTitle);
        }
        return p;
      }).toList(),
    );
  }

  void saveProtocol(ProtocolItem updatedProtocol) {
    state = state.copyWith(
      protocols: state.protocols.map((p) {
        if (p.id == updatedProtocol.id) {
          return updatedProtocol;
        }
        return p;
      }).toList(),
    );
  }

  void deleteProtocol(String id) {
    state = state.copyWith(
      protocols: state.protocols.where((p) => p.id != id).toList(),
    );
  }

  // --- Area Actions ---
  bool validateAreaSku(String sku) {
    final regex = RegExp(r'^[A-Z]{4}-[0-9]{4}$');
    return regex.hasMatch(sku);
  }
Future<void> fetchProtocolFields() async {
    try {
      final repo = locator<TreatmentRepository>();
      final response = await repo.getProtocolFields();
      if (response.isSuccess &&
          response.data != null &&
          response.data!.isNotEmpty) {
        state = state.copyWith(protocols: response.data!);
      }
    } catch (e) {
      log('Error fetching protocol fields: $e');
    }
  }

Future<bool> createProtocolField(String title, ProtocolType type) async {
    if (title.isEmpty) return false;
    EasyLoading.show(status: 'Saving protocol field...');
    try {
      final repo = locator<TreatmentRepository>();
      final request = CreateProtocolFieldRequest(
        title: title,
        type: type,
      );
      final response = await repo.createProtocolField(request);
      if (response.success) {
        EasyLoading.showSuccess('Protocol field added successfully!');
        await fetchProtocolFields();
        return true;
      } else {
        EasyLoading.showError(response.message);
        return false;
      }
    } catch (e) {
      log('Error creating protocol field: $e');
      EasyLoading.showError('Failed to create protocol field.');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }


}
