import '../models/requests/fetch_practitioner_by_email_request.dart';
import '../models/requests/register_practitioner_request.dart';
import '../models/requests/status_request.dart';
import '../models/requests/update_practitioner_treament_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/fetch_practitioner_by_email_response.dart';
import '../models/responses/practitioner_detail_response.dart';
import '../models/responses/practitioner_list_response.dart';
import '../models/responses/register_practitioner_response.dart';

abstract class PractitionerRepository {
  Future<Practitioner> register({required RegisterPractitionerRequest request});

  Future<List<PractitionerListItem>> fetchPractitioner();

  Future<PractitionerDetailResponse> fetchPractitionerDetail({required int id});

  Future<BaseResponse> deletePractitioner({required int id});

  Future<BaseResponse> updatePractitionerStatus({
    required int id,
    required StatusRequest request,
  });

  Future<void> updatePractitionerTreatment({
    required UpdatePractitionerRequest request,
  });

  Future<FetchPractitionerByEmailResponse> fetchPractitionerByEmail({
    required FetchPractitionerByEmailRequest request,
  });
}
