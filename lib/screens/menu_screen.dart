import 'package:computer_store_app/screens/cart_screen.dart';
import 'package:computer_store_app/screens/home_screen.dart';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentNavIndex = 0;
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
      builder: (context, value, child) => Scaffold(
        body: IndexedStack(
          index: value.currentPage,
          children: [
            HomeScreen(),
            Container(),
            Container(),
            CartScreen(),
            Container(),
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
          currentIndex: value.currentPage,
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
  }
}
