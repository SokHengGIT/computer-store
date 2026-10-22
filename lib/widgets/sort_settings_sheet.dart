import 'package:flutter/material.dart';

class SortSettingsSheet extends StatefulWidget {
  final String initialSortOption;
  
  const SortSettingsSheet({
    super.key, 
    this.initialSortOption = 'Recommended',
  });

  @override
  State<SortSettingsSheet> createState() => _SortSettingsSheetState();
}

class _SortSettingsSheetState extends State<SortSettingsSheet> {
  late String _selectedOption;

  // Exact options from the Figma mockup
  final List<String> _sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Top Rated',
    'Newest',
    'Most Popular',
  ];

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F7), // Light grey background of the sheet
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks the sheet to fit the content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Drag Handle
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

          // Title and Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sort Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List of Sort Options
          ..._sortOptions.map((option) => _buildSortOption(option)),

          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Passes the selected string back to the Product Listing Screen
                Navigator.pop(context, _selectedOption);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF141414), // Dark black button
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom helper to build the individual radio rows
  Widget _buildSortOption(String title) {
    bool isSelected = _selectedOption == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          // The mockup shows a white background specifically highlighting the selected item
          color: isSelected ? Colors.white : Colors.transparent, 
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            // Custom Radio Button matching the shipping toggle we built earlier
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                  width: isSelected ? 6.5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}