

import '../models/responses/session_detail_response.dart';
import '../models/responses/treatment_products_response.dart';

abstract class SessionRepository {
  // Future<BaseApiResponseModel> createSession({
  //   required int treatmentId,
  //   required int areaId,
  //   required String title,
  //   required int sessionNumber,
  // });



 

  // Future<BaseResponse> productUsage({
  //   required ProductUsagesRequest request,
  //   required int id,
  // });


  // Future<BaseApiResponseModel> createSchedule(
  //   TreatmentScheduleRequest request,
  //   int id,
  // );
  // Future<BaseApiResponseModel> stepPricing({
  //   required StepPricingRequest request,
  //   required int id,
  // });
  // Future<BaseApiResponseModel> protocol({
  //   required ProtocolRequest request,
  //   required int id,
  // });

  // Future<BaseApiResponseModel> preTreatmentInstructions({
  //   required PreTreatmentInstructionsRequest request,
  //   required int id,
  // });
  // Future<BaseApiResponseModel> postTreatmentInstructions({
  //   required PostTreatmentInstructionsRequest request,
  //   required int id,
  // });

  // Future<BaseApiResponseModel> postTreatmentPhotos({
  //   required int id,
  //   required bool requirePostPhotos,
  //   required int count,
  //   required List<PhotoMilestone> configs,
  //   required int stepNumber,
  // });

  // Future<BaseApiResponseModel> phaseNotifications({
  //   required int id,
  //   required PhaseNotificationsRequest request,
  // });

  // Future<BaseApiResponseModel> downTimeLevels({
  //   required DownTimeLevelRequest request,
  //   required int id,
  // });
  // Future<BaseApiResponseModel> allowedProviderRoles({
  //   required AllowedProviderRolesRequest request,
  //   required int id,
  // });

  // Future<BaseApiResponseModel> followUpConfig({
  //   required int id,
  //   required FollowUpRequest request,
  // });

  // Future<BaseApiResponseModel> consentFormSelection({
  //   required ConsentFormSelectionRequest request,
  //   required int id,
  // });
  // Future<BaseApiResponseModel> finalFinish({
  //   required FinalFinishRequest request,
  //   required int id,
  // });
 Future<TreatmentProductsResponse> getProductsByTreatment(
    // List<int> categoryIds,
  );
  Future<SessionDetailResponse> getSessionDetail({
    required int id,
  });
//   Future<BaseApiResponseModel> deleteSession({
//     required int id,
//   });
// Future<BaseApiResponseModel> changeSessionStatus({
//     required SessionStatusRequest request,
//   });
}



