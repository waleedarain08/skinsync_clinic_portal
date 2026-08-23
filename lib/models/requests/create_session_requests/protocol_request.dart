
import '../../../utils/enums.dart';
import '../base_request.dart';

class ProtocolRequest extends BaseRequest  {
  final int stepNumber;
  final ClinicalProtocolPdf? clinicalProtocolPdf;

  ProtocolRequest({required this.stepNumber, this.clinicalProtocolPdf});

  @override
  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.protocols.name],
    'clinical_protocol_pdf': clinicalProtocolPdf?.toJson(),
  };
}

class ClinicalProtocolPdf {
  final String? name;
  final String? url;

  ClinicalProtocolPdf({this.name, this.url});

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}
