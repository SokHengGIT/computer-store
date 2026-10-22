import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact cyan brand color used in this mockup
    const Color primaryCyan = Color.fromARGB(255, 0, 0, 0); 

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
          'Order Detail/View', // Exact phrasing from mockup
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: Colors.grey.shade300, thickness: 1.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            // --- TOP SECTION: ORDER TRACKER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryCyan, width: 1.5), // Cyan outline
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTimelineStep(title: 'Order Status', isFirst: true, color: primaryCyan),
                  _buildTimelineStep(title: 'Order Tracking', color: primaryCyan),
                  _buildTimelineStep(title: 'Comfirmed', isLast: true, color: primaryCyan), // Preserved typo
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- BOTTOM SECTION: ORDER SUMMARY TABLE ---
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50, // Slight off-white inner background
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Cyan Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: const BoxDecoration(
                      color: primaryCyan,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 2, child: Text('Product', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13))),
                        Expanded(flex: 3, child: Text('Iterm', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13))), // Preserved typo
                        Expanded(flex: 1, child: Text('Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13))),
                      ],
                    ),
                  ),
                  
                  // Product List Rows (Hardcoded to match the exact receipt in the mockup)
                  _buildReceiptRow(Icons.memory, '2x Samsung SSD 250GB', '\$500'),
                  _buildReceiptRow(Icons.keyboard, '1x ROG Strix Scope TKL', '\$150'),
                  _buildReceiptRow(Icons.mouse, '1x ASUS ROG Harpe', '\$100'),
                  _buildReceiptRow(Icons.laptop_mac, '1x ASUS ROG Strix G15 G513', '\$1700', isLast: true),

                  // Cyan Footer / Grand Total
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    decoration: const BoxDecoration(
                      color: primaryCyan,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Grand Total : ', style: TextStyle(color: Colors.black87, fontSize: 15)),
                        SizedBox(width: 8),
                        Text('\$2450', style: TextStyle(color: Colors.black87, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER: TIMELINE TRACKER STEP ---
  Widget _buildTimelineStep({
    required String title,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            // Top connecting line
            Container(
              width: 2,
              height: isFirst ? 0 : 20,
              color: isFirst ? Colors.transparent : color,
            ),
            // The solid cyan circle with checkmark
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
            // Bottom connecting line
            Container(
              width: 2,
              height: isLast ? 0 : 40, 
              color: isLast ? Colors.transparent : color,
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Step Title aligned with the circle
        Padding(
          padding: EdgeInsets.only(top: isFirst ? 0 : 20),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
          ),
        ),
      ],
    );
  }

  // --- HELPER: RECEIPT TABLE ROW ---
  Widget _buildReceiptRow(IconData icon, String title, String price, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Product Image Placeholder
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon, size: 40, color: Colors.black87),
            ),
          ),
          // Quantity & Item Name
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          // Price
          Expanded(
            flex: 1,
            child: Text(
              price,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}