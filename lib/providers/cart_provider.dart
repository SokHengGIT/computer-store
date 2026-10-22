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

// A model to hold placed order history
class OrderItem {
  final String orderId;
  final DateTime date;
  final List<CartItem> items;
  final double totalPrice;

  OrderItem({
    required this.orderId,
    required this.date,
    required this.items,
    required this.totalPrice,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final List<OrderItem> _orders = [];

  List<CartItem> get items => _items;
  List<OrderItem> get orders => _orders;

  // Calculates the grand total dynamically
  double get totalPrice {
    return _items.fold(0, (total, item) => total + (item.price * item.quantity));
  }

  void addProduct(dynamic product, {int quantity = 1}) {
    final newItem = CartItem(
      id: product.id.toString(),
      name: product.name.toString(),
      subtitle: (product.subtitle != null && product.subtitle.toString().isNotEmpty)
          ? product.subtitle.toString()
          : (product.specs != null
              ? product.specs.values.join(' • ')
              : (product.description != null ? product.description.toString() : '')),
      price: product.price is num ? (product.price as num).toDouble() : 0.0,
      image: (product.imageUrl ?? '').toString(),
      quantity: quantity,
    );
    addToCart(newItem);
  }

  void addToCart(CartItem newItem) {
    // Check if the item is already in the cart
    final existingIndex = _items.indexWhere(
      (item) => item.name == newItem.name || (item.id.isNotEmpty && item.id == newItem.id),
    );

    if (existingIndex >= 0) {
      // If it exists, just increase the quantity
      _items[existingIndex].quantity += newItem.quantity;
    } else {
      // Otherwise, add the new item
      _items.add(newItem);
    }
    notifyListeners(); // Tells the UI to rebuild
  }

  void syncWithCartService(List<dynamic> serviceItems) {
    bool changed = false;
    for (final sItem in serviceItems) {
      final product = sItem.product;
      final existingIndex = _items.indexWhere(
        (item) => item.name == product.name || (item.id.isNotEmpty && item.id == product.id),
      );
      if (existingIndex >= 0) {
        if (_items[existingIndex].quantity != sItem.quantity) {
          _items[existingIndex].quantity = sItem.quantity;
          changed = true;
        }
      } else {
        _items.add(CartItem(
          id: product.id.toString(),
          name: product.name.toString(),
          subtitle: (product.subtitle != null && product.subtitle.toString().isNotEmpty)
              ? product.subtitle.toString()
              : (product.specs != null
                  ? product.specs.values.join(' • ')
                  : (product.description != null ? product.description.toString() : '')),
          price: product.price is num ? (product.price as num).toDouble() : 0.0,
          image: (product.imageUrl ?? '').toString(),
          quantity: sItem.quantity as int,
        ));
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void placeOrder() {
    if (_items.isNotEmpty) {
      final orderNumber = 'B${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      _orders.insert(
        0,
        OrderItem(
          orderId: orderNumber,
          date: DateTime.now(),
          items: _items
              .map((item) => CartItem(
                    id: item.id,
                    name: item.name,
                    subtitle: item.subtitle,
                    price: item.price,
                    image: item.image,
                    quantity: item.quantity,
                  ))
              .toList(),
          totalPrice: totalPrice,
        ),
      );
      _items.clear();
      notifyListeners();
    }
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
