class ImageMultiple {
  int? id;
  String? title;
  String? path;

  ImageMultiple({this.id, this.title, this.path});

  // function to convert json data to user model
  factory ImageMultiple.fromJson(Map<String, dynamic> json) {
    return ImageMultiple(
      id: json['image-multiple']['id'],
      title: json['image-multiple']['title'],
      path: json['image-multiple']['path'],
    );
  }
}
