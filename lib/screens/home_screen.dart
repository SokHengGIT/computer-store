import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/product.dart'; 
import '../widgets/product_card.dart';
import '../screens/about_us_screen.dart';
import '../screens/pc_finder_screen.dart';
import '../screens/cart_screen.dart';

// 1. Define a quick model for your Navigation items (Matching Teacher's Structure)
class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  NavItem({required this.label, required this.icon, required this.activeIcon});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. Fixed Banner Viewport to match teacher's peek effect
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentPage = 0;
  int _currentNavIndex = 0;
  Timer? _timer;

  bool _isLoading = true;
  List<Product> _newArrivals = [];
  List<Product> _topRated = [];
  List<Product> _gamingLaptops = [];

  final List<String> _banners = [
    'assets/images/banner.png', 
    'assets/images/banner2.png',
    'assets/images/banner3.png',
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

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if(_currentPage < _banners.length - 1){
        _currentPage++;
      } else{
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage, 
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    _newArrivals = await _loadProducts('assets/json/new_arrivals.json');
    _topRated = await _loadProducts('assets/json/top_rated.json');
    _gamingLaptops = await _loadProducts('assets/json/gaming_laptops.json');
    setState(() => _isLoading = false);
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
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MenuService>().setPreviousPage(0);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildSidebarDrawer(),
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
              _currentNavIndex = 3;
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

              // Banner Section (Matches Teacher's Peek Effect)
              SizedBox(
                height: 180,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20), // Reduced to 8.0 for peek effect
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: Colors.black, 
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
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    width: _currentPage == index ? 18 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _currentPage == index
                                          ? Colors.white 
                                          : Colors.grey.shade400,
                                      borderRadius: BorderRadius.circular(20),
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

              // Static Categories Row
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
              ),
              
              _productSection(
                products: _topRated,
                isLoading: _isLoading,
                title: 'Top Rated',
              ),

              _productSection(
                products: _gamingLaptops,
                isLoading: _isLoading,
                title: 'Gaming Laptops',
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

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
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

  // Helper widget

  Widget _productSection({
    required List<Product> products,
    required bool isLoading,
    required String title,
  }) {
    if (title.isEmpty && products.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          _buildSectionTitle(title),
          const SizedBox(height: 20),
        ],
        isLoading
            ? const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF53B175)),
                ),
              )
            : SizedBox(
                height: 250,
                child: products.isEmpty
                    ? const Center(child: Text('No products available.'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: products[index],
                            onAddTap: () {},
                          );
                        },
                      ),
              ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
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
          const Text(
            'More >',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Drawer
  Widget _buildSidebarDrawer(){
    return Drawer(
      backgroundColor: const Color(0xFFF7F7F7),
      child:  Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black87,
            padding: const EdgeInsets.only(top: 70, bottom:30),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/users/hengrithik.png'),
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'USER',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'user@gmail.com',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(Icons.home_outlined, 'Home'),
                _buildDrawerItem(Icons.person_outline, 'Profile'),
                _buildDrawerItem(
  Icons.manage_search_outlined, 
  'PC Finder Assistant', 
  onTap: () {
    Navigator.pop(context); 
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const PcFinderScreen()),
    );
  }
),
                _buildDrawerItem(Icons.location_on_outlined, 'Address'),
                _buildDrawerItem(Icons.manage_search_outlined, 'Track service'),
                _buildDrawerItem(Icons.description_outlined, 'Terms and Conditions'),
                _buildDrawerItem(
                  Icons.info_outline,
                  'About Us',
                  onTap: () {
                    Navigator.pop(context); // Closes the sidebar smoothly
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  },
                ),
                _buildDrawerItem(Icons.logout, 'Log out'),
              ],
          ))
        ],
      )
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}){
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        onTap: onTap ?? () {},
      );
  }
}