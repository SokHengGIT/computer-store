import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:computer_store_app/services/menu_service.dart';
import '../screens/product_detail_screen.dart';

class SliderItem {
  final String imageUrl;

  SliderItem({required this.imageUrl});

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
    );
  }
}

class CategoryScreen extends StatefulWidget {
  final String categoryTitle;
  final String bannerImagePath;

  const CategoryScreen({
    super.key,
    required this.categoryTitle,
    this.bannerImagePath = '',
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> _categoryProducts = [];
  List<Map<String, dynamic>> _displayedProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Banner carousel state matching home_screen.dart
  int _currentSlide = 0;
  List<SliderItem> _sliders = [];

  // Track currently selected category in state
  late String _currentCategory;

  // Master list of categories with direct JSON file mapping
  final List<Map<String, String>> _categoriesList = [
    {'title': 'Gaming PCs', 'json': 'assets/json/gaming_pcs.json'},
    {'title': 'GPUs', 'json': 'assets/json/gpus.json'},
    {'title': 'Components', 'json': 'assets/json/components.json'},
    {'title': 'Peripherals', 'json': 'assets/json/peripherals.json'},
    {'title': 'Printer', 'json': 'assets/json/printers.json'},
    {'title': 'Audio', 'json': 'assets/json/audio.json'},
  ];

  final List<SliderItem> _defaultSliders = [
    SliderItem(imageUrl: 'assets/images/banner.png'),
    SliderItem(imageUrl: 'assets/images/banner2.png'),
    SliderItem(imageUrl: 'assets/images/banner3.png'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with the clicked category, or default to the first
    final initial = widget.categoryTitle.trim();
    final matched = _categoriesList.firstWhere(
      (c) => c['title']!.toLowerCase() == initial.toLowerCase(),
      orElse: () => _categoriesList.first,
    );
    _currentCategory = matched['title']!;

    _loadSliders();
    _loadCategoryData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getCategoryJsonPath(String category) {
    for (final item in _categoriesList) {
      if (item['title']!.toLowerCase() == category.toLowerCase()) {
        return item['json']!;
      }
    }
    final clean = category.toLowerCase().trim().replaceAll(' ', '_');
    return 'assets/json/$clean.json';
  }

  // Load banner carousel from assets/json/category_sliders.json (with optional category-specific override)
  Future<void> _loadSliders() async {
    final categoryKey = _currentCategory.toLowerCase().trim().replaceAll(' ', '_');
    final categorySpecificPath = 'assets/json/category_sliders_$categoryKey.json';

    try {
      String response = '';
      try {
        response = await rootBundle.loadString(categorySpecificPath);
      } catch (_) {
        try {
          response = await rootBundle.loadString('assets/json/category_sliders.json');
        } catch (_) {
          response = await rootBundle.loadString('assets/json/sliders.json');
        }
      }

      final List<dynamic> data = json.decode(response);
      final loaded = data
          .whereType<Map>()
          .map((item) => SliderItem.fromJson(Map<String, dynamic>.from(item)))
          .where((s) => s.imageUrl.isNotEmpty)
          .toList();

      if (mounted) {
        setState(() {
          _sliders = loaded.isNotEmpty ? loaded : _defaultSliders;
          _currentSlide = 0;
        });
      }
    } catch (e) {
      debugPrint("Error loading category sliders: $e");
      if (mounted) {
        setState(() {
          _sliders = _defaultSliders;
        });
      }
    }
  }

  // Load products from the category's dedicated JSON file
  Future<void> _loadCategoryData() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    final jsonPath = _getCategoryJsonPath(_currentCategory);

    try {
      String response = '';
      try {
        response = await rootBundle.loadString(jsonPath);
      } catch (fileErr) {
        debugPrint(
          "Notice: Unable to load '$jsonPath'. "
          "If this asset was recently added, please fully restart the app (stop and run 'flutter run') to bundle new assets.",
        );
        try {
          if (_currentCategory == 'Gaming PCs') {
            response = await rootBundle.loadString('assets/json/gaming_laptops.json');
          } else {
            response = await rootBundle.loadString('assets/json/products.json');
          }
        } catch (_) {
          response = '[]';
        }
      }

      final dynamic decoded = json.decode(response);
      final List<Map<String, dynamic>> loadedProducts = [];

      if (decoded is List) {
        for (final item in decoded) {
          if (item is Map) {
            loadedProducts.add(Map<String, dynamic>.from(item));
          }
        }
      } else if (decoded is Map && decoded['products'] is List) {
        for (final item in decoded['products']) {
          if (item is Map) {
            loadedProducts.add(Map<String, dynamic>.from(item));
          }
        }
      }

      if (mounted) {
        setState(() {
          _categoryProducts = loadedProducts;
          _applySearchFilter();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading products from $jsonPath: $e");
      if (mounted) {
        setState(() {
          _categoryProducts = [];
          _displayedProducts = [];
          _isLoading = false;
        });
      }
    }
  }

  void _applySearchFilter() {
    if (_searchQuery.trim().isEmpty) {
      _displayedProducts = List.from(_categoryProducts);
    } else {
      final q = _searchQuery.trim().toLowerCase();
      _displayedProducts = _categoryProducts.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        final desc = (p['description'] ?? '').toString().toLowerCase();
        final specs = (p['specs']?.toString() ?? '').toLowerCase();
        final subtitle = (p['subtitle'] ?? '').toString().toLowerCase();
        return name.contains(q) || desc.contains(q) || specs.contains(q) || subtitle.contains(q);
      }).toList();
    }
  }

  String _formatPrice(dynamic priceVal) {
    if (priceVal == null) return '\$0.00';
    if (priceVal is num) {
      if (priceVal == priceVal.roundToDouble()) {
        final intPrice = priceVal.toInt().toString();
        final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        return '\$${intPrice.replaceAllMapped(reg, (Match m) => '${m[1]},')}';
      }
      return '\$${priceVal.toStringAsFixed(2)}';
    }
    final str = priceVal.toString();
    if (str.startsWith('\$')) return str;
    final parsed = double.tryParse(str);
    if (parsed != null) return _formatPrice(parsed);
    return '\$$str';
  }

  @override
  Widget build(BuildContext context) {
    final bool useRedPrice = _currentCategory != 'Gaming PCs';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22),
          onPressed: () {
            final menuService = context.read<MenuService>();
            if (menuService.customPage != null) {
              menuService.goBack();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              menuService.goBack();
            }
          },
        ),
        title: Text(
          _currentCategory.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Horizontal Category Selector Bar
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _categoriesList.length,
              itemBuilder: (context, index) {
                final categoryItem = _categoriesList[index];
                final isSelected = categoryItem['title'] == _currentCategory;

                return GestureDetector(
                  onTap: () {
                    if (_currentCategory == categoryItem['title']) return;
                    setState(() {
                      _currentCategory = categoryItem['title']!;
                      _isLoading = true;
                    });
                    _loadSliders();
                    _loadCategoryData();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        categoryItem['title']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // 2. Interactive Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                    _applySearchFilter();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search in $_currentCategory...',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                              _applySearchFilter();
                            });
                          },
                        )
                      : const Icon(Icons.search, color: Colors.black87, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // 3. Dynamic Banner Carousel (matches home_screen.dart, loads from category_sliders.json)
          _buildBannerSection(),

          const SizedBox(height: 16),

          // 4. Dynamic Product Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : _displayedProducts.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'No products in $_currentCategory yet',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Add products to ${_getCategoryJsonPath(_currentCategory)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _displayedProducts.length,
                        itemBuilder: (context, index) {
                          final product = _displayedProducts[index];
                          return _buildCategoryProductCard(product, useRedPrice);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  // Banner Section using CarouselSlider matching home_screen.dart
  Widget _buildBannerSection() {
    final slidersToDisplay = _sliders.isNotEmpty ? _sliders : _defaultSliders;

    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider(
            items: List.generate(
              slidersToDisplay.length,
              (index) {
                final imgUrl = slidersToDisplay[index].imageUrl;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imgUrl.startsWith('http')
                      ? Image.network(
                          imgUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.image, size: 40, color: Colors.grey),
                            ),
                          ),
                        )
                      : Image.asset(
                          imgUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.image, size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                );
              },
            ),
            options: CarouselOptions(
              viewportFraction: 0.9,
              height: 150,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentSlide = index;
                });
              },
            ),
          ),
          if (slidersToDisplay.length > 1)
            Positioned(
              bottom: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        slidersToDisplay.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _currentSlide == index ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentSlide == index
                                ? Colors.lightBlueAccent
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryProductCard(Map<String, dynamic> product, bool useRedPrice) {
    final String imagePath = (product['imageUrl'] ?? product['image'] ?? '').toString();

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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: imagePath.isNotEmpty
                      ? (imagePath.startsWith('http')
                          ? Image.network(
                              imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.developer_board, size: 55, color: Colors.grey),
                            )
                          : Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.developer_board, size: 55, color: Colors.grey),
                            ))
                      : const Icon(Icons.computer, size: 55, color: Colors.grey),
                ),
              ),
            ),
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
                    Text(
                      product['name'] ?? 'Unknown Hardware',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black),
                    ),
                    const Spacer(),
                    Text(
                      _formatPrice(product['price']),
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
      ),
    );
  }
}
