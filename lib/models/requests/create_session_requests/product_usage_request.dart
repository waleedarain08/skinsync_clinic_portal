
import '../../../utils/enums.dart';
import '../base_request.dart';

class ProductUsagesRequest extends BaseRequest {
  final int stepNumber;
 
  final List<ProductUsage>? billableMaterials;
  final List<int>? otherMaterials;
  final List<String>? allowedRoles;

  ProductUsagesRequest({
    required this.stepNumber,
   
    this.billableMaterials,
    this.otherMaterials,
    this.allowedRoles,
  });

  @override
  Map<String, dynamic> toJson() => {
    'step_number': stepNumber,
    'keys': [CreateTreatmentSteps.inventoryProducts.name],
   
    'billable_materials': billableMaterials == null
        ? []
        : List<dynamic>.from(billableMaterials!.map((x) => x.toJson())),
    'other_materials': otherMaterials == null
        ? []
        : List<dynamic>.from(otherMaterials!.map((x) => x)),
    'allowed_roles': allowedRoles == null
        ? []
        : List<dynamic>.from(allowedRoles!.map((x) => x)),
  };
}

class ProductUsage {
  final int? productId;
  final String? deductionTiming;
  final bool? allowSubstitution;
  final String? notes;

  ProductUsage({
    this.productId,
    this.deductionTiming,
    this.allowSubstitution,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'deduction_timing': deductionTiming,
    'allow_substitution': allowSubstitution,
    'notes': notes,
  };
}
