import 'base_request.dart';

class AddProductRequest extends BaseRequest {
  final List<int>? productIds;

  AddProductRequest({this.productIds});

  @override
  Map<String, dynamic> toJson() => {
    "product_ids": productIds == null
        ? []
        : List<dynamic>.from(productIds!.map((x) => x)),
  };
}
