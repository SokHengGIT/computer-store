import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryTitle;
  final String bannerImagePath;

  const CategoryScreen({
    super.key,
    required this.categoryTitle,
    required this.bannerImagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if prices should be red (like GPUs/Components) or black (Gaming PCs)
    final bool useRedPrice = categoryTitle != 'Gaming PCs';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background from mockup
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(), // Re-opens drawer from this screen
          ),
        ),
        title: Text(
          categoryTitle.toUpperCase(), // e.g., GAMING PCs, GPUs
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 0.5),
        ),
        centerTitle: true,
      ),
      drawer: const AppDrawer(), // Allows navigating directly between categories
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  suffixIcon: Icon(Icons.search, color: Colors.black87, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Promotional Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                bannerImagePath,
                width: double.infinity,
                height: 120, // Adjust based on your asset aspect ratio
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Product Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65, // Taller cards to fit long spec lists
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4, // Replace with dynamic data list length later
              itemBuilder: (context, index) {
                return _buildCategoryProductCard(useRedPrice);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Nita's Card Design
  Widget _buildCategoryProductCard(bool useRedPrice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/images/placeholder_gpu.png', // Replace with real product image
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.developer_board, size: 60, color: Colors.grey),
              ),
            ),
          ),
          // Product Info Border and Text
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  const Text(
                    'ROG Strix GeForce RTX™ 5080 16GB GDDR7', // Placeholder text matching mockup
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    '\$2989.99',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: useRedPrice ? const Color(0xFFD32F2F) : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}