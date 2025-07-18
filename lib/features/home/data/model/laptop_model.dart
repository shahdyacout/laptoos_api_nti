class LaptopModel {
  final String id;
  final String title;
  final String image;
  final String description;
  final double price;

  LaptopModel({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
  });

  factory LaptopModel.fromJson(Map<String, dynamic> json) {
    return LaptopModel(
      id: json['_id'],
      title: json['name'],
      image: json['image'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
