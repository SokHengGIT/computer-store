import 'dart:convert';
import 'package:computer_store_app/services/menu_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/wishlist_provider.dart'; // To keep the heart icons functional

class SectionProductsScreen extends StatefulWidget {
  final String title;
  final String jsonPath;

  const SectionProductsScreen({
    super.key,
    required this.title,
    required this.jsonPath,
  });

  @override
  State<SectionProductsScreen> createState() => _SectionProductsScreenState();
}

class _SectionProductsScreenState extends State<SectionProductsScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String response = await rootBundle.loadString(widget.jsonPath);
      final dynamic decoded = json.decode(response);
      
      final List<Map<String, dynamic>> loaded = [];
      final rawList = decoded is List ? decoded : (decoded is Map ? (decoded['products'] ?? []) : []);

      for (final item in rawList) {
        if (item is Map) {
          loaded.add(Map<String, dynamic>.from(item));
        }
      }

      setState(() {
        _products = loaded;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading ${widget.jsonPath}: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
             // Closes the custom page and restores your home screen state seamlessly
             context.read<MenuService>().goBack();
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : _products.isEmpty
              ? Center(child: Text('No products found in ${widget.title}.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return _buildProductCard(product);
                  },
                ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final String imagePath = (product['imageUrl'] ?? product['image'] ?? '').toString();
    final double rating = (product['rating'] as num?)?.toDouble() ?? 5.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: imagePath.isNotEmpty
                          ? (imagePath.startsWith('http')
                              ? Image.network(
                                  imagePath, 
                                  fit: BoxFit.contain,
                                  // Added shield for broken network links
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.computer, size: 50, color: Colors.grey),
                                )
                              : Image.asset(
                                  imagePath, 
                                  fit: BoxFit.contain,
                                  // Added shield for missing local assets!
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.computer, size: 50, color: Colors.grey),
                                ))
                          : const Icon(Icons.computer, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Builder(builder: (context) {
                      final isSaved = context.watch<WishlistProvider>().isInWishlist(product);
                      return IconButton(
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: isSaved ? const Color(0xFFD32F2F) : Colors.grey.shade400,
                          size: 20,
                        ),
                        onPressed: () => context.read<WishlistProvider>().toggleWishlist(product),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Unknown Product',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < rating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 12,
                      )),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product['price']}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}