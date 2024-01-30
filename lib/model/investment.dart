class Investments {
  final String name;
  final String amount;
  final String time;
  final String description;
  final String id;
  final String image;
  final String userId; // Include the userId field

  Investments({
    required this.name,
    required this.amount,
    required this.time,
    required this.description,
    required this.id,
    required this.image,
    required this.userId, // Add this line
  });

  static Investments fromJson(Map<String, dynamic> json) => Investments(
        name: json['name'],
        amount: json['amount'],
        time: json['time'],
        description: json['description'],
        id: json['id'],
        image: json['image'],
        userId: json['user_id'], // Make sure the key matches your JSON structure
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
        'time': time,
        'description': description,
        'id': id,
        'image': image,
        'user_id': userId, // Make sure the key matches your JSON structure
      };
}
