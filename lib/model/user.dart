class User {
  final String name;
  final String email;
  final String id;
  final String image;

  User({
    required this.name,
    required this.email,
    required this.id,
    required this.image,
  });

  static User fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email: json['email'],
    id: json['id'],
    image: json['image'],
    );

    Map<String, dynamic> toJson() => {
      'name': name,
      'email': email,
      'id': id,
      'image': image,
    };

}