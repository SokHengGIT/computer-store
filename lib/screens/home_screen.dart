import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const  Icon(Icons.menu, color: Colors.black),
          onPressed: () {
              // Handle menu button press
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
                // Handle shopping cart button press
              },
            ),
          ],
        ),


        // Main Scrollable Body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
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
                const SizedBox(height: 24),

                // Category Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryIcon(Icons.laptop_chromebook, 'Computer'),
                    _buildCategoryIcon(Icons.phone_android, 'Phone'),
                    _buildCategoryIcon(Icons.keyboard, 'Keyboard'),
                    _buildCategoryIcon(Icons.headphones, 'Headphones'),
                    _buildCategoryIcon(Icons.print, 'Printers'),
                  ],
                ),
                const SizedBox(height: 24),

                // Promo Banner
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    color: Colors.black,
                    child: Image.asset(
                      'assets/images/banner.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Promo Banner', style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Pills Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterPill('All'),
                    _buildFilterPill('Computers'),
                    _buildFilterPill('Phones'),
                    _buildFilterPill('Accessories'),
                  ],
                ),
                const SizedBox(height: 24),

                // Product Section 1
                _buildSectionHeader('More >'),
                const SizedBox(height: 12),
                _buildProductHorizontalList(),
                const SizedBox(height: 24),

                // Product Section 2
                _buildSectionHeader('More >'),
                const SizedBox(height: 12),
                _buildProductHorizontalList(),
                const SizedBox(height: 24),
                
                // Product Section 3
                _buildSectionHeader('More >'),
                const SizedBox(height: 12),
                _buildProductHorizontalList(),
                const SizedBox(height: 24),
              ],
            )
          ),
        ),

        // 3. Bottom Navigation Bar
        bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
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
      ),
    );
  }

Widget _buildCategoryIcon(IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 28, color: Colors.black),
      ),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
    ],
  );
}

// Build grey filter pill button
Widget _buildFilterPill(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
  );
}

// Build "More >"
Widget _buildSectionHeader(String trailingText){
  return Align(
    alignment: Alignment.centerRight,
    child: Text(
      trailingText,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)
      ),
  );
}

// Build a horizontal scrolling list of product cards
Widget _buildProductHorizontalList(){
  return SizedBox(
    height: 100,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      separatorBuilder: (context, index) => const SizedBox(width: 12),
      itemBuilder: (context, index){
        return _buildProdutCard();
      },
    ),
  );
}

Widget _buildProductCard(){
  return Container(
    width: 140,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(0),
      color: Colors.white,
    ),
    
  )
}
}