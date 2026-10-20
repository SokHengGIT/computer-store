import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService extends ChangeNotifier {
  // Singleton pattern ensures all screens share the exact same cart instance
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get cartTotal {
    return _items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  void addToCart(Product product) {
    // Check if the item is already in the cart
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners(); // Tells the UI to update
  }

  void updateQuantity(Product product, int newQuantity) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      if (newQuantity <= 0) {
        _items.removeAt(existingIndex);
      } else {
        _items[existingIndex].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }
}