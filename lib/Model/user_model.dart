class User {
  int? id;
  String? name;
  String? email;
  String? address;
  String? contact;
  String? image;
  String? token;

  User(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.contact,
      this.image,
      this.token});

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user']['id'],
        name: json['user']['name'],
        email: json['user']['email'],
        address: json['user']['address'],
        contact: json['user']['contact'],
        image: json['user']['image'],
        token: json['token']);
  }
}
