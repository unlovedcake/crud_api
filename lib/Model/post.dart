class Post {
  int? id;
  int? userId;
  int? time;
  String? name;
  String? image;
  String? body;

  Post({this.id, this.userId, this.time, this.name, this.image, this.body});

  // function to convert json data to user model
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['post']['id'],
      userId: json['post']['userId'],
      time: json['post']['time'],
      name: json['post']['name'],
      image: json['post']['image'],
      body: json['post']['body'],
    );
  }
}
