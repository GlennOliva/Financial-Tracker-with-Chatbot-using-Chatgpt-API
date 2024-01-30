class AdminObject {
  final String name;
  final String email;
  final String id;
  final String image;

  AdminObject({
    required this.name,
    required this.email,
    required this.id,
    required this.image,
  });

  static AdminObject fromJson(Map<String, dynamic> json) => AdminObject(
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