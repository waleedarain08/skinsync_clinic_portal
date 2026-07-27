
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/treatment_data_models.dart';

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
        ProtocolItem(
          id: '1',
          title: 'Cleanse treatment area',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(
              title: 'Step 1',
              text: 'Cleanse the skin surface with antiseptic agent.',
              order: 1,
            ),
            ProtocolDescription(
              title: 'Step 2',
              text: 'Pat dry with sterile gauze.',
              order: 2,
            ),
          ],
        ),
        ProtocolItem(
          id: '2',
          title: 'Review contraindications',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(
              title: 'Allergies',
              text: 'Confirm patient has no lidocaine or product allergies.',
              order: 1,
            ),
            ProtocolDescription(
              title: 'Pregnancy',
              text: 'Verify patient is not pregnant or breastfeeding.',
              order: 2,
            ),
          ],
        ),
        ProtocolItem(
          id: '3',
          title: 'Mark injection sites',
          type: ProtocolType.checkbox,
          descriptions: [
            ProtocolDescription(
              title: 'Mapping',
              text:
                  'Use surgical marker to outline the target injection points.',
              order: 1,
            ),
          ],
        ),
        ProtocolItem(
          id: '4',
          title: 'Pre-Treatment Instructions',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(
              title: 'Pre Care',
              text:
                  'Avoid blood thinners and alcohol 24 hours before treatment.',
              order: 1,
            ),
          ],
        ),
        ProtocolItem(
          id: '5',
          title: 'Post-Treatment Notes',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(
              title: 'Aftercare',
              text: 'Apply cold compress to reduce swelling.',
              order: 1,
            ),
            ProtocolDescription(
              title: 'Restrictions',
              text: 'Do not touch or massage treated areas for 6 hours.',
              order: 2,
            ),
          ],
        ),
        ProtocolItem(
          id: '6',
          title: 'Recovery Instructions',
          type: ProtocolType.text,
          descriptions: [
            ProtocolDescription(
              title: 'Follow-up',
              text: 'Contact clinic if redness persists past 72 hours.',
              order: 1,
            ),
          ],
        ),
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



}
