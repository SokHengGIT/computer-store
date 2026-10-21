import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferSliderItem {
  final String imageUrl;

  const OfferSliderItem({required this.imageUrl});
}

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  int currentSlide = 0;

  final List<OfferSliderItem> _sliders = const [
    OfferSliderItem(imageUrl: 'assets/images/offers/promo_banner1.jpg'),
    OfferSliderItem(imageUrl: 'assets/images/offers/promo_banner2.jpg'),
    OfferSliderItem(imageUrl: 'assets/images/offers/promo_banner3.jpg'),
  ];

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
          'Offers & Promo Codes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Banner Section
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider(
                  items: List.generate(
                    _sliders.length,
                    (index) => ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        _sliders[index].imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF4A849A),
                          child: const Center(
                            child: Icon(Icons.local_offer, color: Colors.white, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                  options: CarouselOptions(
                    viewportFraction: 0.9,
                    height: 140,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentSlide = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            _sliders.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              width: currentSlide == index ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: currentSlide == index
                                    ? const Color(0xFF4A849A)
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
          ),

          const SizedBox(height: 16),

          // Promo Code List
          _buildPromoCard(
            context: context,
            title: '15% OFF',
            subtitle: 'Gaming accessories.',
            code: 'Gaming15',
            imageUrl: 'assets/images/offers/promo_poster1.png',
          ),
          _buildPromoCard(
            context: context,
            title: '20% OFF',
            subtitle: 'Skincare WSP.',
            code: 'HengRT45',
            imageUrl: 'assets/images/offers/promo_poster2.png',
          ),
          _buildPromoCard(
            context: context,
            title: '50% OFF',
            subtitle: 'Pc Shop Gaming.',
            code: 'GTA66666',
            imageUrl: 'assets/images/offers/promo_poster3.png',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Helper method for each Promo item
  Widget _buildPromoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String code,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 80,
              height: 100,
              color: Colors.grey.shade200,
              child: Image.asset(
                imageUrl,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.local_offer, color: Colors.grey, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Right Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Code Box
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Code : $code',
                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Copy Button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A849A),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied "$code" to clipboard!'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text(
                          'Copy Code',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
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