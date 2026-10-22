import 'package:computer_store_app/screens/menu_screen.dart';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:computer_store_app/screens/cart_screen.dart';
import 'package:computer_store_app/screens/product_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(const ComputerStoreApp());
}

class ComputerStoreApp extends StatelessWidget {
  const ComputerStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MenuService(),)
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