import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Services & Providers
import 'package:computer_store_app/services/menu_service.dart';
import 'providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

// Screens
import 'screens/splash_screen.dart';

void main() {
  runApp(const ComputerStoreApp());
}

class ComputerStoreApp extends StatelessWidget {
  const ComputerStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuService()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'Computer Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}