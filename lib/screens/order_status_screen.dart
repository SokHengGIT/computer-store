import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class OrderStatusScreen extends StatelessWidget {
  final OrderItem? order;

  const OrderStatusScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    const Color primaryThemeColor = Colors.black;
    final cartProvider = Provider.of<CartProvider>(context);
    final targetOrder = order ?? (cartProvider.orders.isNotEmpty ? cartProvider.orders.first : null);
    final items = targetOrder != null ? targetOrder.items : cartProvider.items;
    final totalPrice = targetOrder != null ? targetOrder.totalPrice : cartProvider.totalPrice;
    final orderId = targetOrder != null ? targetOrder.orderId : 'Pending';

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
          'Order Status',
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
            // Order Tracker
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryThemeColor, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order #$orderId',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'On Track',
                          style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTimelineStep(title: 'Order Placed & Verified', isFirst: true, color: primaryThemeColor),
                  _buildTimelineStep(title: 'Order Tracking & Packaging', color: primaryThemeColor),
                  _buildTimelineStep(title: 'Confirmed & Dispatched', isLast: true, color: primaryThemeColor),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Order Summary Table
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
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
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: const BoxDecoration(
                      color: primaryThemeColor,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 2, child: Text('Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 3, child: Text('Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                        Expanded(flex: 1, child: Text('Price', textAlign: TextAlign.right, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                    ),
                  ),

                  // Product List Rows
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text("No items in this order.", style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isLast = index == items.length - 1;

                      return _buildReceiptRow(
                        imagePath: item.image,
                        title: '${item.quantity}x ${item.name}',
                        price: '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        isLast: isLast,
                      );
                    }),

                  // Grand Total
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    decoration: const BoxDecoration(
                      color: primaryThemeColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Grand Total : ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text('\$${totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  // Helper: Tracker Step
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
            Container(
              width: 2,
              height: isFirst ? 0 : 20,
              color: isFirst ? Colors.transparent : color,
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Colors.white, size: 14),
            ),
            Container(
              width: 2,
              height: isLast ? 0 : 40,
              color: isLast ? Colors.transparent : color,
            ),
          ],
        ),
        const SizedBox(width: 16),
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

  // Helper: Receipt Table Row
  Widget _buildReceiptRow({
    required String imagePath,
    required String title,
    required String price,
    bool isLast = false,
  }) {
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
          // Product Image
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey.shade100,
                ),
                child: imagePath.isNotEmpty
                    ? (imagePath.startsWith('http')
                        ? Image.network(imagePath, fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.computer, size: 28, color: Colors.black87))
                        : Image.asset(imagePath, fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.computer, size: 28, color: Colors.black87)))
                    : const Icon(Icons.computer, size: 28, color: Colors.black87),
              ),
            ),
          ),
          // Quantity & Item Name
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
          // Price
          Expanded(
            flex: 1,
            child: Text(
              price,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}