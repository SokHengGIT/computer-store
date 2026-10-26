class Product {
  final String id;
  final String name;
  final String unit;
  final String description;
  final String? subtitle;
  final String category;
  final Map<String, dynamic>? specs;
  final double price;
  final String imageUrl;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    this.unit = '',
    this.description = '',
    this.subtitle,
    this.category = 'General',
    this.specs,
    required this.price,
    required this.imageUrl,
    this.rating = 4.0,
  });

  String get specsText {
    if (specs == null) return '';
    if (specs!.containsKey('summary')) return specs!['summary'].toString();
    if (specs!.containsKey('gpu')) return specs!['gpu'].toString();
    if (specs!.containsKey('cpu')) return specs!['cpu'].toString();
    return specs!.values.take(2).join(' • ');
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parsedSpecs;
    if (json['specs'] is Map) {
      parsedSpecs = Map<String, dynamic>.from(json['specs']);
    } else if (json['specs'] is String && (json['specs'] as String).isNotEmpty) {
      final s = json['specs'] as String;
      parsedSpecs = {'summary': s};
      if (s.toLowerCase().contains('rtx') || s.toLowerCase().contains('gpu')) {
        parsedSpecs['gpu'] = s;
      }
    }

    String cat = json['category'] ?? '';
    if (cat.isEmpty) {
      final nameLower = (json['name'] ?? '').toString().toLowerCase();
      if (nameLower.contains('laptop') || nameLower.contains('katana') || nameLower.contains('strix')) {
        cat = 'Laptop';
      } else if (nameLower.contains('desktop') || nameLower.contains('rig') || nameLower.contains('tower')) {
        cat = 'Desktop';
      } else if (nameLower.contains('phone') || nameLower.contains('iphone')) {
        cat = 'Phone';
      } else {
        cat = 'General';
      }
    }

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      description: json['description'] ?? '',
      subtitle: json['subtitle'],
      category: cat,
      specs: parsedSpecs,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'description': description,
      'subtitle': subtitle,
      'category': category,
      'specs': specsText.isNotEmpty ? specsText : (subtitle ?? ''),
      'rawSpecs': specs,
      'price': price,
      'imageUrl': imageUrl,
      'image': imageUrl,
      'rating': rating,
    };
  }
}