import '../models/requests/register_practitioner_request.dart';
import '../models/requests/update_practitioner_treament_request.dart';

import '../models/responses/register_practitioner_response.dart';

abstract class PractitionerRepository {
  Future<void> register({required RegisterPractitionerRequest request});

  Future<List<Practitioner>> fetchPractitioner();
  Future<void> updatepractitionerTreatment({required UpdatePractitionerRequest request});
}
