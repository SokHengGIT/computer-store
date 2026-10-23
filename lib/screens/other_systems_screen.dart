import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';
import 'category_screen.dart'; 

class OtherSystemsScreen extends StatelessWidget {
  const OtherSystemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Other Systems',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 0.5),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/banner3.png', 
                width: double.infinity,
                height: 120,
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
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              crossAxisCount: 2,
              childAspectRatio: 1.0, 
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildSystemCategoryCard(
                  context: context,
                  title: 'Gaming PCs',
                  icon: Icons.computer,
                  bannerPath: 'assets/images/banner.png',
                ),
                _buildSystemCategoryCard(
                  context: context,
                  title: 'GPU',
                  icon: Icons.developer_board,
                  bannerPath: 'assets/images/banner2.png',
                ),
                _buildSystemCategoryCard(
                  context: context,
                  title: 'Components',
                  icon: Icons.memory,
                  bannerPath: 'assets/images/banner3.png',
                ),
                _buildSystemCategoryCard(
                  context: context,
                  title: 'Peripherals',
                  icon: Icons.keyboard,
                  bannerPath: 'assets/images/banner.png',
                ),
                _buildSystemCategoryCard(
                  context: context,
                  title: 'Motherboards', 
                  icon: Icons.developer_board_off,
                  bannerPath: 'assets/images/banner2.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String bannerPath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(
              categoryTitle: title,
              bannerImagePath: bannerPath,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200, width: 1.5), 
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(icon, size: 60, color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                  ),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.black87),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}