import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:computer_store_app/screens/section_products_screen.dart';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/product.dart'; 
import '../widgets/product_card.dart';
import '../widgets/main_drawer.dart';
import '../screens/category_screen.dart';



// 1. Define a quick model for your Navigation items (Matching Teacher's Structure)
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  NavItem({required this.label, required this.icon, required this.activeIcon});
}

class SliderItem {
  final String imageUrl;

  SliderItem({required this.imageUrl});

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlide = 0;


  bool _isLoading = true;
  List<Product> _newArrivals = [];
  List<Product> _topRated = [];
  List<Product> _gamingLaptops = [];

  List<SliderItem> _sliders = [
    SliderItem(imageUrl: 'assets/images/banner.png'),
    SliderItem(imageUrl: 'assets/images/banner2.png'),
    SliderItem(imageUrl: 'assets/images/banner3.png'),
  ];

  // // Map your bottom navigation data here
  // final List<NavItem> _navItems = [
  //   NavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
  //   NavItem(label: 'Goods', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
  //   NavItem(label: 'Order', icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long),
  //   NavItem(label: 'Basket', icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart),
  //   NavItem(label: 'Account', icon: Icons.person_outline, activeIcon: Icons.person),
  // ];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    _sliders = await _loadSliders('assets/json/sliders.json');
    _newArrivals = await _loadProducts('assets/json/new_arrivals.json');
    _topRated = await _loadProducts('assets/json/top_rated.json');
    _gamingLaptops = await _loadProducts('assets/json/gaming_laptops.json');
    setState(() => _isLoading = false);
  }

  Future<List<SliderItem>> _loadSliders(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      final List<dynamic> data = json.decode(response);
      final loaded = data.map((json) => SliderItem.fromJson(json)).toList();
      return loaded.isNotEmpty ? loaded : _sliders;
    } catch (e) {
      debugPrint("Error loading $path: $e");
      return _sliders;
    }
  }

  Future<List<Product>> _loadProducts(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      final dynamic decoded = json.decode(response);
      if (decoded is! List) return [];

      final List<Product> products = [];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          products.add(Product.fromJson(item));
        } else if (item is Map) {
          products.add(Product.fromJson(Map<String, dynamic>.from(item)));
        } else if (item is List) {
          for (final subItem in item) {
            if (subItem is Map<String, dynamic>) {
              products.add(Product.fromJson(subItem));
            } else if (subItem is Map) {
              products.add(Product.fromJson(Map<String, dynamic>.from(subItem)));
            }
          }
        }
      }
      return products;
    } catch (e) {
      debugPrint("Error loading $path: $e");
      return [];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                // context.read<MenuService>().onPageChanged(context.read<MenuService>().previousPage);
              },
            );
          },
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CartScreen()),
              // );
              context.read<MenuService>().onPageChanged(3);
              setState(() {
                
              });
            },
          ),
        ],
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: const Icon(Icons.search, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Banner Section
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider(
                      items: List.generate(
                        _sliders.length,
                        (index) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            _sliders[index].imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      options: CarouselOptions(
                        viewportFraction: 0.9,
                        height: 160,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        onPageChanged: (index, reason) {
                          currentSlide = index;
                          setState(() {});
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                _sliders.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: currentSlide == index ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: currentSlide == index
                                        ? Colors.lightBlueAccent
                                        : Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Category Section Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Interactive Categories Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Pass the Title and the Banner Image it should load
                    _buildCategoryIcon(Icons.laptop_chromebook, 'Gaming PCs', 'assets/images/banner.png'),
                    _buildCategoryIcon(Icons.developer_board, 'GPUs', 'assets/images/banner2.png'),
                    _buildCategoryIcon(Icons.memory, 'Components', 'assets/images/banner3.png'),
                    _buildCategoryIcon(Icons.print, 'Printer', 'assets/images/banner.png'),
                    _buildCategoryIcon(Icons.headphones, 'Audio', 'assets/images/banner2.png'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       _buildFilterPill('ALL'),
              //       _buildFilterPill('ALL'),
              //       _buildFilterPill('ALL'),
              //       _buildFilterPill('ALL'),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 24),

              _productSection(
                products: _newArrivals,
                isLoading: _isLoading,
                title: 'New Arrivals',
                jsonPath: 'assets/json/new_arrivals.json',
              ),
              
              _productSection(
                products: _topRated,
                isLoading: _isLoading,
                title: 'Top Rated',
                jsonPath: 'assets/json/top_rated.json',
              ),

              _productSection(
                products: _gamingLaptops,
                isLoading: _isLoading,
                title: 'Gaming Laptops',
                jsonPath: 'assets/json/gaming_laptops.json',
              ),
            ],
          ),
        ),
      ),

      // // 3. Dynamic Bottom Navigation (Matching Teacher's .map logic)
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
      //     if (index == 3){
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const CartScreen()),
      //       );
      //     }else{
      //       setState(() {
      //       _currentNavIndex = index;
      //     });
      //     }
      //   },
      //   items: _navItems.map((item) {
      //     return BottomNavigationBarItem(
      //       icon: Icon(item.icon),
      //       activeIcon: Icon(item.activeIcon),
      //       label: item.label,
      //     );
      //   }).toList(),
      // ),
    );
  }

  // Helper Method

  Widget _buildCategoryIcon(IconData icon, String label, String bannerPath) {
    return InkWell(
      onTap: () {
        // Replaces Navigator.push to keep everything inside the MenuService memory
        context.read<MenuService>().pushCustomPage(
          CategoryScreen(
            categoryTitle: label,
            bannerImagePath: bannerPath,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _productSection({
    required List<Product> products,
    required bool isLoading,
    required String title,
    required String jsonPath,
  }) {
    if (title.isEmpty && products.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          _buildSectionTitle(title, onTap: () {
            // THE ROUTING GOES HERE, WHERE jsonPath EXISTS!
            context.read<MenuService>().pushCustomPage(
              SectionProductsScreen(
                title: title,
                jsonPath: jsonPath,
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
        // RESTORED: The horizontal scrolling list of products
        if (isLoading)
          const Center(child: CircularProgressIndicator(color: Colors.black))
        else if (products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('No products available.', style: TextStyle(color: Colors.grey)),
          )
        else
          SizedBox(
            height: 260, // Adjust this height if your ProductCard gets clipped
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                // Renders your custom product card for each item
                return ProductCard(product: products[index]); 
              },
            ),
          ),
        const SizedBox(height: 24), // Spacing before the next section
      ],
    );
  }

  Widget _buildSectionTitle(String title, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF181725),
            ),
          ),
          InkWell(
            onTap: onTap, // JUST PUT THIS HERE
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                'More >',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}