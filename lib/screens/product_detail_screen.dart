import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../services/menu_service.dart';
import '../providers/cart_provider.dart';
import '../services/cart_service.dart' hide CartItem;

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int _currentImageIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _prevImage() {
    if (_currentImageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentImageIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      final intPrice = price.toInt().toString();
      final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      return '\$${intPrice.replaceAllMapped(reg, (Match m) => '${m[1]},')}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  Map<String, String> _buildSpecsMap() {
    final Map<String, String> result = {};
    final dynamic rawSpecs = widget.product['rawSpecs'] ?? widget.product['specs'];

    if (rawSpecs is Map && rawSpecs.isNotEmpty) {
      for (final entry in rawSpecs.entries) {
        final keyStr = entry.key.toString().toLowerCase();
        String displayKey;
        if (keyStr == 'cpu' || keyStr == 'processor') {
          displayKey = 'Processor';
        } else if (keyStr == 'gpu' || keyStr == 'graphics') {
          displayKey = 'GPU';
        } else if (keyStr == 'ram' || keyStr == 'memory') {
          displayKey = 'RAM';
        } else if (keyStr == 'storage' || keyStr == 'ssd' || keyStr == 'hdd') {
          displayKey = 'Storage';
        } else if (keyStr == 'display' || keyStr == 'screen') {
          displayKey = 'Display';
        } else if (keyStr == 'motherboard') {
          displayKey = 'Motherboard';
        } else if (keyStr == 'power_supply' || keyStr == 'psu') {
          displayKey = 'Power Supply';
        } else {
          displayKey = entry.key
              .toString()
              .split('_')
              .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
              .join(' ');
        }
        result[displayKey] = entry.value.toString();
      }
    }

    final subtitle = widget.product['subtitle']?.toString() ?? '';
    if (!result.containsKey('Processor') &&
        subtitle.isNotEmpty &&
        (subtitle.toLowerCase().contains('core') ||
            subtitle.toLowerCase().contains('chip') ||
            subtitle.toLowerCase().contains('intel') ||
            subtitle.toLowerCase().contains('ryzen') ||
            subtitle.toLowerCase().contains('a20'))) {
      result['Processor'] = subtitle;
    }

    final specsText = widget.product['specs']?.toString() ?? '';
    if (result.isEmpty) {
      if (specsText.isNotEmpty) {
        result['Processor'] = subtitle.isNotEmpty ? subtitle : 'High Performance';
        result['GPU'] = specsText;
      }
      final cat = widget.product['category']?.toString() ?? 'General';
      if (cat.isNotEmpty && cat != 'General') {
        result['Category'] = cat;
      }
      final unit = widget.product['unit']?.toString() ?? '';
      if (unit.isNotEmpty) {
        result['Unit'] = unit;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.product['name'] ?? 'Unknown Product';
    final String description = widget.product['description'] ??
        '$name is a high-performance system designed for productivity and modern computing needs.';
    final String imageUrl = widget.product['imageUrl'] ?? widget.product['image'] ?? '';
    final double price = double.tryParse(widget.product['price']?.toString() ?? '0') ?? 0.0;
    final double originalPrice = widget.product['originalPrice'] != null
        ? double.tryParse(widget.product['originalPrice'].toString()) ?? (price * 1.1)
        : (price > 0 ? (price * 1.1).roundToDouble() : 0.0);
    final double rating = double.tryParse(widget.product['rating']?.toString() ?? '4') ?? 4.0;
    final int reviewsCount = widget.product['reviewsCount'] ?? 128;
    final String sku = widget.product['sku'] ??
        (widget.product['id'] != null && widget.product['id'].toString().length > 2
            ? widget.product['id'].toString()
            : 'LP-ASU-F15');
    final int stock = widget.product['stock'] ?? 15;

    final specsMap = _buildSpecsMap();
    final currentMenuTab = context.watch<MenuService>().currentPage.clamp(0, 4);

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
          'Product Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black, size: 24),
            onPressed: () {
              context.read<MenuService>().onPageChanged(3);
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // 1. Image Carousel Card
              Container(
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFD6E6F9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3880EC).withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Carousel View
                    PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() => _currentImageIndex = index);
                      },
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                            child: imageUrl.isNotEmpty
                                ? (imageUrl.startsWith('http')
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.laptop_chromebook, size: 90, color: Colors.grey),
                                      )
                                    : Image.asset(
                                        imageUrl,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.laptop_chromebook, size: 90, color: Colors.grey),
                                      ))
                                : const Icon(Icons.laptop_chromebook, size: 90, color: Colors.grey),
                          ),
                        );
                      },
                    ),

                    // Left Navigation Arrow
                    Positioned(
                      left: 4,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.chevron_left,
                            size: 32,
                            color: Colors.black87,
                          ),
                          onPressed: _prevImage,
                        ),
                      ),
                    ),

                    // Right Navigation Arrow
                    Positioned(
                      right: 4,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.chevron_right,
                            size: 32,
                            color: Colors.black87,
                          ),
                          onPressed: _nextImage,
                        ),
                      ),
                    ),

                    // Dot Indicators
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final isActive = _currentImageIndex == i;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? Colors.black87 : const Color(0xFFD0D7DE),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Action Row (Quantity Selector + Add to Cart Button)
              Row(
                children: [
                  // Quantity Selector
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFCCE0FA),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.remove,
                              size: 18,
                              color: Color(0xFF3880EC),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() => quantity++);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: Color(0xFF3880EC),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                onPressed: () {
                  // Create a CartItem from the current screen's data
                  final newItem = CartItem(
                    id: DateTime.now().toString(), // Generates a unique ID
                    name: name,
                    subtitle: widget.product['category'] ?? 'PC Hardware',
                    price: price,
                    image: imageUrl,
                    quantity: quantity, // The quantity selected on this screen
                  );

                  // Send it to the global state
                  Provider.of<CartProvider>(context, listen: false).addToCart(newItem);
                  CartService().addRawItem(
                    id: newItem.id,
                    name: newItem.name,
                    subtitle: newItem.subtitle,
                    price: newItem.price,
                    imageUrl: newItem.image,
                    quantity: newItem.quantity,
                  );

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${quantity}x $name added to basket!'),
                      backgroundColor: const Color(0xFF53B175),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3880EC),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3. Stock Status & SKU Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F7EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, size: 14, color: Color(0xFF228758)),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock · $stock units',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF228758),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'SKU: $sku',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 4. Product Title
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2430),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              // 5. Price & Original Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatPrice(price),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F76E6),
                    ),
                  ),
                  if (originalPrice > price) ...[
                    const SizedBox(width: 12),
                    Text(
                      _formatPrice(originalPrice),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8C95A3),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // 6. Rating & Reviews
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final isFilled = index < rating.floor();
                      final isHalf = !isFilled && index < rating;
                      return Icon(
                        isFilled
                            ? Icons.star
                            : (isHalf ? Icons.star_half : Icons.star),
                        size: 16,
                        color: (isFilled || isHalf)
                            ? const Color(0xFFE5A43B)
                            : const Color(0xFFE0E0E0),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${rating.toStringAsFixed(1)} ($reviewsCount reviews)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7E8A9B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 7. Specifications Card
              if (specsMap.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFD),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE8F1FC),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2430),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...specsMap.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF7E8A9B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1B2430),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // 8. Description Section
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2430),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF7E8A9B),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),

      // 9. Bottom Navigation Bar matching design mockup
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.grey.shade500,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: currentMenuTab,
        onTap: (index) {
          context.read<MenuService>().onPageChanged(index);
          Navigator.pop(context);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Goods',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Basket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
