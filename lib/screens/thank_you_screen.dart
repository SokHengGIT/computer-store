import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/menu_service.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon[cite: 2]
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFF7CB8CE), // Teal blue circle[cite: 2]
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 24),
              
              // Success Text[cite: 2]
              const Text(
                'Thank You',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Payment Complete',
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              // Order Details Receipt[cite: 2]
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('B837494', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('MSI Gaming Laptop', style: TextStyle(color: Colors.black87)),
                    SizedBox(height: 4),
                    Text('Purchase Date: 01/01/2026', style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              const Spacer(),

              // Return to Home Button[cite: 2]
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Instantly resets the app back to the Home tab
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    context.read<MenuService>().onPageChanged(0); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CB8CE),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Thank You',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}