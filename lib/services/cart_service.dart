import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get cartTotal {
    return _items.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  void addToCart(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void addRawItem({
    required String id,
    required String name,
    required String subtitle,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) {
    final existingIndex = _items.indexWhere((item) => item.product.id == id || item.product.name == name);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: Product(
          id: id,
          name: name,
          subtitle: subtitle,
          price: price,
          imageUrl: imageUrl,
        ),
        quantity: quantity,
      ));
    }
    notifyListeners();
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

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
