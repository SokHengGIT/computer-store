import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart' hide CartItem;
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddTap;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddTap,
    this.onTap,
  });

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      final intPrice = price.toInt().toString();
      final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      return '\$${intPrice.replaceAllMapped(reg, (Match m) => '${m[1]},')}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final subtitleText = product.subtitle ?? '';
    final specsText = product.specsText;

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: {
                    'id': product.id,
                    'name': product.name,
                    'description': product.description,
                    'imageUrl': product.imageUrl,
                    'image': product.imageUrl,
                    'price': product.price,
                    'rating': product.rating,
                    'specs': product.specsText.isNotEmpty ? product.specsText : (product.subtitle ?? ''),
                    'category': product.category,
                  },
                ),
              ),
            );
          },
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Product Image
            Expanded(
              child: Center(
                child: product.imageUrl.startsWith('http')
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.computer, size: 50, color: Colors.grey),
                      )
                    : Image.asset(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.computer, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // 2. Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // 3. Subtitle / Specs
            if (subtitleText.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                subtitleText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (specsText.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                specsText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),

            // 4. Price
            Text(
              _formatPrice(product.price),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFFE5A43B),
              ),
            ),
            const SizedBox(height: 8),

            // 5. Bottom Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      CartService().addToCart(product);
                      try {
                        Provider.of<CartProvider>(context, listen: false).addProduct(product);
                      } catch (_) {}
                      onAddTap?.call();
                      
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    final isFilled = index < product.rating.round();
                    return Padding(
                      padding: const EdgeInsets.only(left: 1.5),
                      child: Icon(
                        Icons.star,
                        size: 15,
                        color: isFilled ? const Color(0xFFE5A43B) : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
