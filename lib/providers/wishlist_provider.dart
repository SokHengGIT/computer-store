import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get items => _wishlistItems;
  bool isInWishlist(Map<String, dynamic> product) {
    return _wishlistItems.any((item) => item['name'] == product['name']);
  }
  void toggleWishlist(Map<String, dynamic> product) {
    if (isInWishlist(product)) {
      _wishlistItems.removeWhere((item) => item['name'] == product['name']);
    } else {
      _wishlistItems.add(product);
    }
    notifyListeners();
  }
}