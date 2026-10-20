import 'package:computer_store_app/screens/checkout_step_1_screen.dart';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final int _currentNavIndex = 3; 
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    context.read<MenuService>().setPreviousPage(3);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            context.read<MenuService>().onPageChanged(context.read<MenuService>().previousPage);
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      
      // ListenableBuilder automatically rebuilds this section when the cart changes
      body: ListenableBuilder(
        listenable: _cartService,
        builder: (context, child) {
          if (_cartService.items.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _cartService.items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildCartItemCard(_cartService.items[index]);
                    },
                  ),
                ),
                // Buy Now Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${_cartService.cartTotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutStep1Screen()),
                            );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, 
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // // Bottom Navigation (Basket selected)
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.grey,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   selectedFontSize: 12,
      //   unselectedFontSize: 12,
      //   currentIndex: _currentNavIndex,
      //   onTap: (index) {
      //     // Navigation logic goes here
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Goods'),
      //     BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Order'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Basket'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
      //   ],
      // ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, right: 8.0),
            child: Icon(Icons.radio_button_unchecked, color: Colors.black),
          ),
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: item.product.imageUrl.isEmpty
                  ? const Icon(Icons.computer, size: 40, color: Colors.grey)
                  : item.product.imageUrl.startsWith('http')
                      ? Image.network(
                          item.product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.computer, size: 40, color: Colors.grey),
                        )
                      : Image.asset(
                          item.product.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.computer, size: 40, color: Colors.grey),
                        ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () => _cartService.removeItem(item.product), // Call global remove
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${item.product.price.toStringAsFixed(0)} ',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.blueAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildQtyButton(Icons.remove, () {
                          _cartService.updateQuantity(item.product, item.quantity - 1); // Call global update
                        }),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        _buildQtyButton(Icons.add, () {
                          _cartService.updateQuantity(item.product, item.quantity + 1); // Call global update
                        }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: icon == Icons.add ? Colors.blueAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon, 
          size: 16, 
          color: icon == Icons.add ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}