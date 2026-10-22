import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  // Mock data exactly matching the Figma design
  final List<Map<String, dynamic>> _cartItems = [
    {
      'title': 'ASUS ROG Strix G15 G513',
      'subtitle': 'Gaming Laptops',
      'quantity': 1,
      'icon': Icons.laptop_mac,
    },
    {
      'title': 'ASUS ROG Harpe',
      'subtitle': 'Gaming Mouse',
      'quantity': 1,
      'icon': Icons.mouse,
    },
    {
      'title': 'ROG Strix Scope TKL',
      'subtitle': 'keyboards', // Preserved exact lowercase from mockup
      'quantity': 1,
      'icon': Icons.keyboard,
    },
    {
      'title': 'Samsung SSD 250GB',
      'subtitle': 'NVMe PCIe M.2',
      'quantity': 2, // Matches the mockup's starting quantity
      'icon': Icons.memory,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          'My Orders',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        // The distinct divider line immediately below the App Bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey.shade300, thickness: 1.5),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        itemCount: _cartItems.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade300,
          thickness: 1.5,
          height: 32, // Padding around the divider lines
        ),
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          return _buildCartItem(item, index);
        },
      ),
      // Fixed bottom action bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Route to checkout flow
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF38B6FF), // The bright light-blue from the mockup
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded pill shape
                ),
              ),
              child: const Text(
                'My Orders', // Exact text from the mockup button
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product Image Area
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          // Using an icon as a placeholder. Swap with Image.asset when you drop in real images.
          child: Icon(item['icon'] as IconData, size: 50, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        
        // Product Details Area
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                item['subtitle'] as String,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 12),
              
              // Quantity Selector
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item['quantity'] > 1) {
                        setState(() => item['quantity']--);
                      }
                    },
                    child: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 22),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300), // Faint border around the number
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${item['quantity']}',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => item['quantity']++);
                    },
                    // The bright blue add icon
                    child: const Icon(Icons.add_circle_outline, color: Colors.blue, size: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Trailing Chevron
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.chevron_right, color: Colors.black, size: 24),
        ),
      ],
    );
  }
}