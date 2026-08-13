import '../../utils/assets.dart';
import '../responses/patient_detail_response.dart';
import '../responses/patient_treatment_request_response.dart';

final dummyPatientDetail = PatientDetailResponse(
  success: true,
  message: "Patient details fetched successfully",
  data: PatientDetailData(
    id: 101,
    patientName: "Sarah Johnson",
    email: "sarah.johnson@example.com",
    phoneNumber: "+1 (555) 123-4567",
    image: PngAssets.person,
  ),
);

final dummyTreatmentRequests = [
  PatientTreatmentRequestData(
    id: 1,
    userId: 101,
    groupId: 1,
    name: "Full Face Botox & Filler Plan",
    createdAt: "2026-08-10T10:00:00Z",
    frontImageBefore: PngAssets.face,
    frontImageAfter: PngAssets.faceMarks,
    rightImageBefore: PngAssets.treatmentImage,
    rightImageAfter: PngAssets.treatmentImage2,
    leftImageBefore: PngAssets.simulation,
    leftImageAfter: PngAssets.laserTreatment,
    treatments: [
      PatientTreatmentData(
        treatmentId: 1,
        treatmentName: "Botox",
        areas: [
          PatientTreatmentAreaData(
            areaId: 1,
            areaName: "Forehead",
            materials: [
              PatientTreatmentMaterialData(id: 1, name: "Botulinum Toxin", selectedQuantity: 20),
            ],
          ),
          PatientTreatmentAreaData(
            areaId: 2,
            areaName: "Crow's Feet",
            materials: [
              PatientTreatmentMaterialData(id: 1, name: "Botulinum Toxin", selectedQuantity: 12),
            ],
          ),
        ],
      ),
    ],
  ),
  PatientTreatmentRequestData(
    id: 2,
    userId: 101,
    groupId: 1,
    name: "Lip Augmentation",
    createdAt: "2026-08-12T14:30:00Z",
    leftImageBefore: PngAssets.treatmentImage,
    leftImageAfter: PngAssets.simulation,
    treatments: [
      PatientTreatmentData(
        treatmentId: 2,
        treatmentName: "Dermal Fillers",
        areas: [
          PatientTreatmentAreaData(
            areaId: 3,
            areaName: "Upper Lip",
            materials: [
              PatientTreatmentMaterialData(id: 2, name: "Juvederm Volbella", selectedQuantity: 1),
            ],
          ),
        ],
      ),
    ],
  ),
];



