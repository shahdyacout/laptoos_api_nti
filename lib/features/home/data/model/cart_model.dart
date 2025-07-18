class CartModel {
  final String id;
  final String name;
  final String image;
  final List<String> images;
  final String description;
  final String status;
  final String category;
  final String company;
  final double price;
  final int countInStock;
  final int sales;
  final int quantity;
  final double totalPrice;

  CartModel({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.description,
    required this.status,
    required this.category,
    required this.company,
    required this.price,
    required this.countInStock,
    required this.sales,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      category: json['category'] ?? '',
      company: json['company'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      countInStock: json['countInStock'] ?? 0,
      sales: json['sales'] ?? 0,
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}
