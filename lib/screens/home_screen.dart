import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart'; // Make sure you have your Product model ready
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation & Banner State
  int _currentNavIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  // Data State
  bool _isLoading = true;
  List<Product> _newArrivals = [];
  List<Product> _topRated = [];
  List<Product> _gamingLaptops = [];

  // Placeholder banners for the Computer Store
  final List<String> _banners = [
    'assets/images/promo_1.png', // Update with your actual asset paths
    'assets/images/promo_2.png',
    'assets/images/promo_3.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Asynchronous Data Loading (Matching Teacher's Logic)
  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    // Ensure these JSON files exist in your assets/json folder!
    _newArrivals = await _loadProducts('assets/json/new_arrivals.json');
    _topRated = await _loadProducts('assets/json/top_rated.json');
    _gamingLaptops = await _loadProducts('assets/json/gaming_laptops.json');

    setState(() => _isLoading = false);
  }

  Future<List<Product>> _loadProducts(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error loading $path: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
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
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Categories Row (Figma Design)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryIcon(Icons.laptop_chromebook, 'Computer'),
                    _buildCategoryIcon(Icons.phone_android, 'Phone'),
                    _buildCategoryIcon(Icons.keyboard, 'Keyboard'),
                    _buildCategoryIcon(Icons.print, 'Printer'),
                    _buildCategoryIcon(Icons.headphones, 'Headphones'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Functional Animated Banner Section (Teacher's Logic + Figma Dimensions)
              SizedBox(
                height: 160,
                child: Stack(
                  children: [
                    PageView(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        for (var bannerPath in _banners)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: Colors.black, // Background placeholder
                                child: Image.asset(
                                  bannerPath,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => 
                                      const Center(child: Text('Promo Banner', style: TextStyle(color: Colors.white))),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    // Blur Page Indicators
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  _banners.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    width: _currentPage == index ? 18 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? Colors.white // White looks better on dark tech banners
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
              const SizedBox(height: 16),

              // Filter Pills Row (Figma Design)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterPill('ALL'),
                    _buildFilterPill('ALL'),
                    _buildFilterPill('ALL'),
                    _buildFilterPill('ALL'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Product Sections (Teacher's Logic)
              _productSection(
                products: _newArrivals,
                isLoading: _isLoading,
                trailingText: 'More >',
              ),
              
              _productSection(
                products: _topRated,
                isLoading: _isLoading,
                trailingText: 'More >',
              ),

              _productSection(
                products: _gamingLaptops,
                isLoading: _isLoading,
                trailingText: 'More >',
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Goods'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Basket'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
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

  // Modified Teacher's Logic: Feeds dynamic JSON data into the horizontal scrolling list
  Widget _productSection({
    required List<Product> products,
    required bool isLoading,
    required String trailingText,
  }) {
    if (products.isEmpty && !isLoading) {
      return const SizedBox.shrink(); // Hides section if JSON is empty
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Aligns "More >" to the right
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            trailingText,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        const SizedBox(height: 12),
        isLoading
            ? const SizedBox(
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.black), // Loading spinner
                ),
              )
            : SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length, // Uses actual JSON length
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: products[index], // Passes the actual data model to the card
                      onAddTap: () {},
                    );
                  },
                ),
              ),
        const SizedBox(height: 24),
      ],
    );
  }
}