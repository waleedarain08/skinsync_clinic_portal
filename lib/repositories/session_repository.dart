

import '../models/requests/create_session_requests/allowed_provider_role_request.dart';
import '../models/requests/create_session_requests/constent_form_selection_request.dart';
import '../models/requests/create_session_requests/down_time_level_request.dart';
import '../models/requests/create_session_requests/follow_up_request.dart';
import '../models/requests/create_session_requests/phase_notifications_request.dart';
import '../models/requests/create_session_requests/post_photos_request.dart';
import '../models/requests/create_session_requests/post_treatment_instruction_request.dart';
import '../models/requests/create_session_requests/pre_treatment_instruction_request.dart';
import '../models/requests/create_session_requests/product_usage_request.dart';
import '../models/requests/create_session_requests/protocol_request.dart';
import '../models/requests/create_session_requests/step_pricing_request.dart';
import '../models/requests/create_session_requests/treatment_schedule_request.dart';
import '../models/requests/session_status_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/down_time_level_response.dart';
import '../models/responses/session_detail_response.dart';
import '../models/responses/treatment_products_response.dart';

abstract class SessionRepository {
  // Future<BaseApiResponseModel> createSession({
  //   required int treatmentId,
  //   required int areaId,
  //   required String title,
  //   required int sessionNumber,
  // });



 

  Future<BaseResponse> productUsage({
    required ProductUsagesRequest request,
    required int id,
  });


  Future<BaseResponse> createSchedule(
    TreatmentScheduleRequest request,
    int id,
  );
  Future<BaseResponse> stepPricing({
    required StepPricingRequest request,
    required int id,
  });
  Future<BaseResponse> protocol({
    required ProtocolRequest request,
    required int id,
  });

  Future<BaseResponse> preTreatmentInstructions({
    required PreTreatmentInstructionsRequest request,
    required int id,
  });
  Future<BaseResponse> postTreatmentInstructions({
    required PostTreatmentInstructionsRequest request,
    required int id,
  });

  Future<BaseResponse> postTreatmentPhotos({
    required int id,
    required bool requirePostPhotos,
    required int count,
    required List<PhotoMilestone> configs,
    required int stepNumber,
  });

  Future<BaseResponse> phaseNotifications({
    required int id,
    required PhaseNotificationsRequest request,
  });

  Future<BaseResponse> downTimeLevels({
    required DownTimeLevelRequest request,
    required int id,
  });
  Future<BaseResponse> allowedProviderRoles({
    required AllowedProviderRolesRequest request,
    required int id,
  });

  Future<BaseResponse> followUpConfig({
    required int id,
    required FollowUpRequest request,
  });

  Future<BaseResponse> consentFormSelection({
    required ConsentFormSelectionRequest request,
    required int id,
  });
  
 Future<TreatmentProductsResponse> getProductsByTreatment(
    // List<int> categoryIds,
  );
  Future<SessionDetailResponse> getSessionDetail({
    required int id,
  });
  Future<BaseResponse> deleteSession({
    required int id,
  });
Future<BaseResponse> changeSessionStatus({
    required SessionStatusRequest request,
  });

    Future<DownTimeLevelResponse> getDownTimeLevelByTreatment(
   {required int id,}
  );
}



