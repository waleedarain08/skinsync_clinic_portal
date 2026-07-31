import 'base_request.dart';

class UpdateAreaRequest extends BaseRequest {
  final String? name;
  final String? globalSku;
  final String? icon;
  final String? image;

  UpdateAreaRequest({this.name, this.globalSku, this.icon, this.image});

  @override
  Map<String, dynamic> toJson() => {
    "name": name,
    "global_sku": globalSku,
    "icon": icon,
    "image": image,
  };
}
