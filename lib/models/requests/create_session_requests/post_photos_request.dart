
import '../../../utils/enums.dart';
import '../base_request.dart';

class PhotoMilestone extends BaseRequest  {
  final int numberOfDays;
  final int requiredPhotos;

   PhotoMilestone({
    required this.numberOfDays,
    required this.requiredPhotos,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'number_of_days': numberOfDays, 'required_photos': requiredPhotos};
  }
}

class PostPhotosRequest extends BaseRequest  {
  final int stepNumber;
  final bool requirePostTreatmentPhotos;
  final List<PhotoMilestone> photoMilestone;

   PostPhotosRequest({
    required this.stepNumber,
    required this.requirePostTreatmentPhotos,
    required this.photoMilestone,
  });

  Map<String, dynamic> toJson() {
    return {
      'step_number': stepNumber,
      'keys': [CreateTreatmentSteps.postTreatmentPhotos.name],
      'require_post_treatment_photos': requirePostTreatmentPhotos,
      'photo_milestone': photoMilestone.map((m) => m.toJson()).toList(),
    };
  }
}
