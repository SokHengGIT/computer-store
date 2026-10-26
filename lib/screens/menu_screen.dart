import 'package:computer_store_app/screens/home_screen.dart';
import 'package:computer_store_app/screens/my_orders_screen.dart';
import 'package:computer_store_app/screens/product_listing_screen.dart';
import 'package:computer_store_app/screens/cart_screen.dart';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:computer_store_app/screens/profile_screen.dart';
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

        return PopScope(
          canPop: value.customPage == null && value.currentPage == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            value.goBack();
          },
          child: Scaffold(
            body: Stack(
              children: [
                // Main tabs
                IndexedStack(
                  index: clampedIndex,
                  children: const [
                    HomeScreen(), 
                    ProductListingScreen(), 
                    MyOrdersScreen(), 
                    CartScreen(), 
                    ProfileScreen(), 
                  ],
                ),
                
                // Custom page layer
                if (value.customPage != null) 
                  value.customPage!,
              ],
            ),
            bottomNavigationBar: value.customPage != null 
                ? null 
                : BottomNavigationBar(
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
          ),
        );
      },
    );
  }
}
