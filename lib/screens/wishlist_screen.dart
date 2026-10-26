import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>().items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wishlist/Favorite',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey.shade300, thickness: 1),
        ),
      ),
      body: wishlist.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: wishlist.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300, height: 24),
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return _buildWishlistItem(context, product);
              },
            ),
    );
  }

  Widget _buildWishlistItem(BuildContext context, Map<String, dynamic> product) {
    final String imagePath = (product['imageUrl'] ?? product['image'] ?? '').toString();
    final double rating = (product['rating'] as num?)?.toDouble() ?? 5.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    width: 100,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _fallbackImage(),
                  )
                : Image.asset(
                    imagePath,
                    width: 100,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _fallbackImage(),
                  ),
          ),
          const SizedBox(width: 16),
          
          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Unknown Product',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product['price']}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFFD32F2F)),
                ),
                const SizedBox(height: 4),
                _buildStarRating(rating),
              ],
            ),
          ),
          
          // Live Favorite Toggle Icon
          IconButton(
            icon: const Icon(Icons.favorite, color: Color(0xFFD32F2F), size: 20),
            onPressed: () {
              context.read<WishlistProvider>().toggleWishlist(product);
            },
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: 100,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Icons.computer, color: Colors.grey),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 14);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 14);
        } else {
          return Icon(Icons.star, color: Colors.grey.shade300, size: 14);
        }
      }),
    );
  }
}