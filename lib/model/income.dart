class Incomes {
  final String name;
  final String amount;
  final String time;
  final String description;
  final String id;
  final String image;
  final String userId; // Include the userId field

  Incomes({
    required this.name,
    required this.amount,
    required this.time,
    required this.description,
    required this.id,
    required this.image,
    required this.userId, // Add this line
  });

  static Incomes fromJson(Map<String, dynamic> json) => Incomes(
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
