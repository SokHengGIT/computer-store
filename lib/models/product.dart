// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String unit;
  final String description;
  final String? subtitle;
  final String? specs;
  final double price;
  final String imageUrl;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    this.unit = '',
    this.description = '',
    this.subtitle,
    this.specs,
    required this.price,
    required this.imageUrl,
    this.rating = 4.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      description: json['description'] ?? '',
      subtitle: json['subtitle'],
      specs: json['specs'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
    );
  }
}