import 'package:flutter/material.dart';

class FilterSettingsSheet extends StatefulWidget {
  const FilterSettingsSheet({super.key});

  @override
  State<FilterSettingsSheet> createState() => _FilterSettingsSheetState();
}

class _FilterSettingsSheetState extends State<FilterSettingsSheet> {
  // Local state for the filter panel
  RangeValues _priceRange = const RangeValues(500, 2500);
  final List<String> _categories = ['Desktops', 'Laptops', 'Components', 'Accessories'];
  String _selectedCategory = 'Laptops';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7), // Matches the sort sheet background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Range Section
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_priceRange.start.toInt()}', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('\$${_priceRange.end.toInt()}', style: const TextStyle(fontWeight: FontWeight.w600)),
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
          const SizedBox(height: 24),

          // Categories Section
          const Text(
            'Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                selectedColor: Colors.black,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                  ),
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) _selectedCategory = category;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Return the filtered data map back to the Listing Screen
                Navigator.pop(context, {
                  'minPrice': _priceRange.start,
                  'maxPrice': _priceRange.end,
                  'category': _selectedCategory,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141414), // Dark black to match Sort sheet
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}