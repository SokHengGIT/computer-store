import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  int _currentNavIndex = 1; // "Goods" tab
  bool _isLoading = true;
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final String response = await rootBundle.loadString('assets/json/gaming_laptops.json');
      final dynamic decoded = json.decode(response);

      if (decoded is List) {
        final List<Product> loaded = [];
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            loaded.add(Product.fromJson(item));
          } else if (item is Map) {
            loaded.add(Product.fromJson(Map<String, dynamic>.from(item)));
          } else if (item is List) {
            for (final subItem in item) {
              if (subItem is Map<String, dynamic>) {
                loaded.add(Product.fromJson(subItem));
              } else if (subItem is Map) {
                loaded.add(Product.fromJson(Map<String, dynamic>.from(subItem)));
              }
            }
          }
        }

        _allProducts = loaded;

        // Duplicate the list to populate the grid for UI demonstration if there are items
        if (_allProducts.isNotEmpty) {
          _allProducts = [..._allProducts, ..._allProducts, ..._allProducts, ..._allProducts];
        }
      }
    } catch (e) {
      debugPrint("Error loading products: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Listing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
        child: Column(
          children: [
            // Filter & Sort Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildActionPill(Icons.tune, 'Filter', () async {
                    // This launches the modal and waits for the returned filter map
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true, 
                      backgroundColor: Colors.transparent, 
                      builder: (context) => const AdvancedFilterPanel(),
                    );
                    
                    if (result != null) {
                      debugPrint('Applied Filters: $result'); 
                    }
                  }),
                  const SizedBox(width: 12),
                  _buildActionPill(Icons.swap_vert, 'Sort', () {}),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Product Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.black))
                  : _allProducts.isEmpty
                      ? const Center(child: Text('No products available.'))
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _allProducts.length,
                          itemBuilder: (context, index) {
                            return _buildPlpCard(_allProducts[index]);
                          },
                        ),
            ),
          ],
        ),
      ),

      // // Bottom Navigation
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
      //     setState(() => _currentNavIndex = index);
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'Goods'),
      //     BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long), label: 'Order'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Basket'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Account'),
      //   ],
      // ),
    );
  }

  Widget _buildActionPill(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.black),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlpCard(Product product) {
    String specsLine = '';
    if (product.specs != null && product.specs!.isNotEmpty) {
      final values = product.specs!.values.take(2).toList();
      specsLine = values.join(' | ');
    } else if (product.subtitle != null && product.subtitle!.isNotEmpty) {
      specsLine = product.subtitle!;
    } else {
      specsLine = product.description;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: product.imageUrl.startsWith('http')
                        ? Image.network(product.imageUrl, fit: BoxFit.contain)
                        : Image.asset(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, err, stack) =>
                                const Icon(Icons.computer, size: 50, color: Colors.grey),
                          ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: const Icon(Icons.favorite_border, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  specsLine,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < product.rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          size: 10,
                          color: index < product.rating.round()
                              ? Colors.amber.shade600
                              : Colors.grey.shade400,
                        );
                      }),
                    ),
                    Text(
                      _formatPrice(product.price),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// The Stateful Modal Bottom Sheet
class AdvancedFilterPanel extends StatefulWidget {
  const AdvancedFilterPanel({super.key});

  @override
  State<AdvancedFilterPanel> createState() => _AdvancedFilterPanelState();
}

class _AdvancedFilterPanelState extends State<AdvancedFilterPanel> {
  RangeValues _priceRange = const RangeValues(500, 2500);
  String _selectedGpu = 'RTX 4070';
  String _selectedVram = '12GB';
  String _selectedCpu = 'Intel i7';
  String _selectedSocket = 'AM5';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Header: Title and Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Advanced Filter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Price Range (Fixed Syntax Error Here)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(
                  '\$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 5000,
              divisions: 50,
              activeColor: Colors.black,
              inactiveColor: Colors.grey.shade300,
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            const SizedBox(height: 16),

            // GPU Row
            const Text('GPU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['RTX 4060', 'RTX 4070', 'RTX 4080', 'RTX 4090'].map((label) {
                return _buildSelectablePill(label, _selectedGpu == label, () => setState(() => _selectedGpu = label));
              }).toList(),
            ),
            const SizedBox(height: 20),

            // VRAM Row
            const Text('VRAM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['8GB', '12GB', '16GB', '24GB'].map((label) {
                return _buildSelectablePill(label, _selectedVram == label, () => setState(() => _selectedVram = label));
              }).toList(),
            ),
            const SizedBox(height: 20),

            // CPU Row (Fixed Cut-Off Here)
            const Text('CPU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Intel i5', 'Intel i7', 'Ryzen 5', 'Ryzen 7'].map((label) {
                return _buildSelectablePill(label, _selectedCpu == label, () => setState(() => _selectedCpu = label));
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Socket Type Row
            const Text('Socket Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['LGA1700', 'AM5', 'AM4'].map((label) {
                return _buildSelectablePill(label, _selectedSocket == label, () => setState(() => _selectedSocket = label));
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _priceRange = const RangeValues(500, 2500);
                        _selectedGpu = '';
                        _selectedVram = '';
                        _selectedCpu = '';
                        _selectedSocket = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reset', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'price': _priceRange,
                        'gpu': _selectedGpu,
                        'vram': _selectedVram,
                        'cpu': _selectedCpu,
                        'socket': _selectedSocket,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectablePill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}