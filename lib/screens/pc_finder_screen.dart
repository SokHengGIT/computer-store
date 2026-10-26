import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';
import '../widgets/product_card.dart';

class PcFinderScreen extends StatefulWidget {
  const PcFinderScreen({super.key});

  @override
  State<PcFinderScreen> createState() => _PcFinderScreenState();
}

class _PcFinderScreenState extends State<PcFinderScreen> {
  double _currentBudget = 1200.0;
  String _formFactor = 'Desktop';
  String _primaryUse = 'Gaming';

  bool _isLoading = true;
  List<Product> _allProducts = [];
  List<Product> _recommendedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadAllProducts();
  }

  Future<void> _loadAllProducts() async {
    setState(() => _isLoading = true);

    try {
      final String laptopRes = await rootBundle.loadString('assets/json/gaming_laptops.json');
      final String desktopRes = await rootBundle.loadString('assets/json/new_arrivals.json');
      
      final List<dynamic> laptopData = json.decode(laptopRes);
      final List<dynamic> desktopData = json.decode(desktopRes);
      
      _allProducts = [
        ...laptopData.map((json) => Product.fromJson(json)),
        ...desktopData.map((json) => Product.fromJson(json)),
      ];
      
      _runFilteringAlgorithm();

    } catch (e) {
      debugPrint("Error loading products: $e");
    }

    setState(() => _isLoading = false);
  }

  void _runFilteringAlgorithm() {
    setState(() {
      _recommendedProducts = _allProducts.where((product) {
        bool withinBudget = product.price <= _currentBudget;
        bool matchesForm = product.category == _formFactor;
        bool matchesUse = true; 
        if (_primaryUse == 'Gaming' && product.specs != null) {
          matchesUse = product.specs!.containsKey('gpu') || product.category == 'Desktop';
        }

        return withinBudget && matchesForm && matchesUse;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('PC Finder Assistant', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.black))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Questionnaire
                const Text('What is your max budget?', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _currentBudget,
                        min: 500,
                        max: 3000,
                        divisions: 25,
                        activeColor: Colors.black,
                        label: '\$${_currentBudget.toInt()}',
                        onChanged: (value) {
                          setState(() {
                            _currentBudget = value;
                            _runFilteringAlgorithm();
                          });
                        },
                      ),
                    ),
                    Text('\$${_currentBudget.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Form Factor', style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: _formFactor,
                            isExpanded: true,
                            items: ['Desktop', 'Laptop'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _formFactor = newValue!;
                                _runFilteringAlgorithm();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Primary Use', style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: _primaryUse,
                            isExpanded: true,
                            items: ['Gaming', 'Productivity'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _primaryUse = newValue!;
                                _runFilteringAlgorithm();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 40, thickness: 1),

                // Results
                Text(
                  'Recommended for you (${_recommendedProducts.length}):',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                Expanded(
                  child: _recommendedProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found matching these specs. Try adjusting your budget.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _recommendedProducts.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: _recommendedProducts[index],
                            onAddTap: () {},
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
    );
  }
}
