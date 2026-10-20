import 'package:computer_store_app/screens/home_screen.dart';
import 'package:computer_store_app/screens/product_listing_screen.dart';
import 'package:computer_store_app/screens/cart_screen.dart';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  NavItem({required this.label, required this.icon, required this.activeIcon});
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<NavItem> _navItems = [
    NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
    NavItem(
      label: 'Goods',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
    ),
    NavItem(
      label: 'Order',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
    ),
    NavItem(
      label: 'Basket',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
    ),
    NavItem(
      label: 'Account',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuService>(
      builder: (context, value, child) {
        final clampedIndex = value.currentPage.clamp(0, 4);

        return Scaffold(
          body: IndexedStack(
            index: clampedIndex,
            children: const [
              HomeScreen(), // 0: Home
              ProductListingScreen(), // 1: Goods
              _PlaceholderTab(title: 'Orders', icon: Icons.receipt_long_outlined), // 2: Order
              CartScreen(), // 3: Basket
              _PlaceholderTab(title: 'Account', icon: Icons.person_outline), // 4: Account
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: clampedIndex,
            onTap: context.read<MenuService>().onPageChanged,
            items: _navItems.map((item) {
              return BottomNavigationBarItem(
                icon: Icon(item.icon),
                activeIcon: Icon(item.activeIcon),
                label: item.label,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              '$title coming soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}