import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/sort_settings_sheet.dart';
import '../widgets/filter_settings_sheet.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String _currentSort = 'Recommended';
  Map<String, dynamic>? _activeFilters;
  
  List<Product> _allProducts = [];
  List<Product> _products = [];
  bool _isLoading = true;
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProductsFromJson();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProductsFromJson() async {
    try {
      // 1. Correct JSON asset path matching pubspec.yaml assets/json/
      final String response = await rootBundle.loadString('assets/json/products.json');
      final dynamic decoded = json.decode(response);
      
      final List<Product> loaded = [];
      // 2. Safely parse whether root is a List or a Map with 'products'
      final rawList = decoded is List
          ? decoded
          : (decoded is Map ? (decoded['products'] as List? ?? []) : []);

      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          loaded.add(Product.fromJson(item));
        } else if (item is Map) {
          loaded.add(Product.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      setState(() {
        _allProducts = loaded;
        _applyFilterAndSort();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading JSON: $e");
      setState(() => _isLoading = false);
    }
  }

  void _applyFilterAndSort() {
    List<Product> list = List.from(_allProducts);

    // Search query filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            (p.subtitle != null && p.subtitle!.toLowerCase().contains(q)) ||
            p.specsText.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
      }).toList();
    }

    // Active filters (Category & Price range)
    if (_activeFilters != null) {
      final minPrice = (_activeFilters!['minPrice'] as num?)?.toDouble() ?? 0.0;
      final maxPrice = (_activeFilters!['maxPrice'] as num?)?.toDouble() ?? double.infinity;
      final category = (_activeFilters!['category'] as String?)?.toLowerCase().trim() ?? '';

      list = list.where((p) {
        final matchesPrice = p.price >= minPrice && p.price <= maxPrice;
        bool matchesCategory = true;
        if (category.isNotEmpty) {
          final cleanFilterCat = category.replaceAll('s', '');
          final cleanProdCat = p.category.toLowerCase().replaceAll('s', '');
          matchesCategory = cleanProdCat.contains(cleanFilterCat) ||
              cleanFilterCat.contains(cleanProdCat);
        }
        return matchesPrice && matchesCategory;
      }).toList();
    }

    // Sort options
    switch (_currentSort) {
      case 'Price: Low to High':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Top Rated':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        list.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 'Most Popular':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Recommended':
      default:
        break;
    }

    setState(() {
      _products = list;
    });
  }
  
  void _openSortModal() async {
    final selectedSort = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SortSettingsSheet(initialSortOption: _currentSort),
    );

    if (selectedSort != null) {
      setState(() {
        _currentSort = selectedSort;
        _applyFilterAndSort();
      });
    }
  }

  void _openFilterModal() async {
    final filters = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const FilterSettingsSheet(),
    );

    if (filters != null) {
      setState(() {
        _activeFilters = filters;
        _applyFilterAndSort();
      });
    }
  }

  // --- UI Build ---

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Sort Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.tune, 
                      label: _activeFilters != null ? 'Filtered' : 'Filter',
                      isActive: _activeFilters != null,
                      onTap: _openFilterModal,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      icon: Icons.swap_vert, 
                      label: _currentSort != 'Recommended' ? _currentSort : 'Sort',
                      isActive: _currentSort != 'Recommended',
                      onTap: _openSortModal,
                    ),
                    if (_activeFilters != null || _currentSort != 'Recommended') ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _activeFilters = null;
                            _currentSort = 'Recommended';
                            _applyFilterAndSort();
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.close, size: 14, color: Colors.black87),
                              SizedBox(width: 4),
                              Text('Reset', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                IconButton(
                  icon: Icon(_isSearchOpen ? Icons.close : Icons.search, color: Colors.black87),
                  onPressed: () {
                    setState(() {
                      _isSearchOpen = !_isSearchOpen;
                      if (!_isSearchOpen) {
                        _searchController.clear();
                        _searchQuery = '';
                        _applyFilterAndSort();
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          // Search Field (toggleable)
          if (_isSearchOpen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                    _applyFilterAndSort();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products by name or specs...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: Colors.black54),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.black54),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _applyFilterAndSort();
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : _products.isEmpty
                    ? const Center(child: Text('No products found.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7, 
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return _buildDynamicProductCard(product);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Helper for the Pill-shaped Filter/Sort Buttons
  Widget _buildActionButton({
    required IconData icon, 
    required String label, 
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black87 : Colors.white,
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : Colors.black87),
            const SizedBox(width: 6),
            Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.w600, 
                fontSize: 13, 
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicProductCard(Product product) {
    final specDisplay = product.specsText.isNotEmpty 
        ? product.specsText 
        : (product.subtitle ?? 'Specs unavailable');

    return GestureDetector(
      onTap: () {
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
                'specs': specDisplay,
                'category': product.category,
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: product.imageUrl.isNotEmpty
                          ? (product.imageUrl.startsWith('http')
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.computer,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              : Image.asset(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.computer,
                                    size: 60,
                                    color: Colors.grey.shade400,
                                  ),
                                ))
                          : Icon(
                              Icons.computer,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.favorite_border, size: 16, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            // Text Details Area
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name.isNotEmpty ? product.name : 'Unknown Product',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specDisplay,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          final isFilled = index < product.rating.round();
                          return Icon(
                            isFilled ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 12,
                          );
                        }),
                      ),
                      Text(
                        product.price == product.price.roundToDouble()
                            ? '\$${product.price.toInt()}'
                            : '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
