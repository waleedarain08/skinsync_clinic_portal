class MultiPartImageModel {
  String path;
  String name;

  MultiPartImageModel({required this.path, required this.name});

  Map<String, dynamic> toJson() {
    return {'image': path, 'name': name};
  }
}
