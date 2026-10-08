import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onAddTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Matches the Figma dimensions[cite: 24]
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Light grey border[cite: 24]
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Product Image
          Expanded(
            child: Center(
              // Safely handles both web URLs and local asset images
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
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          
          // 3. Price & Stars Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Price
              Expanded(
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Static stars matching the Figma layout[cite: 24]
              Row(
                children: [
                  Icon(Icons.star, size: 10, color: Colors.amber.shade600),
                  Icon(Icons.star, size: 10, color: Colors.amber.shade600),
                  Icon(Icons.star, size: 10, color: Colors.amber.shade600),
                  Icon(Icons.star, size: 10, color: Colors.amber.shade600),
                  Icon(Icons.star_border, size: 10, color: Colors.grey.shade400),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}