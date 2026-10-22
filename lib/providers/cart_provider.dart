import 'package:flutter/material.dart';

// A simple model to hold the data for each cart item
class CartItem {
  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Calculates the grand total dynamically
  double get totalPrice {
    return _items.fold(0, (total, item) => total + (item.price * item.quantity));
  }

  void addToCart(CartItem newItem) {
    // Check if the item is already in the cart
    final existingIndex = _items.indexWhere((item) => item.name == newItem.name);
    
    if (existingIndex >= 0) {
      // If it exists, just increase the quantity
      _items[existingIndex].quantity += newItem.quantity;
    } else {
      // Otherwise, add the new item
      _items.add(newItem);
    }
    notifyListeners(); // Tells the UI to rebuild
  }

  void incrementQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      // Optionally remove the item if quantity drops below 1
      _items.removeAt(index);
    }
    notifyListeners();
  }
}