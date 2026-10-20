import 'package:flutter/material.dart';
import 'thank_you_screen.dart'; // We will build this next!

class CheckoutStep2Screen extends StatefulWidget {
  const CheckoutStep2Screen({super.key});

  @override
  State<CheckoutStep2Screen> createState() => _CheckoutStep2ScreenState();
}

class _CheckoutStep2ScreenState extends State<CheckoutStep2Screen> {
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
          'Check-out',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step Progress Indicator (Flipped for Step 2)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context), // Go back to Address step
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Address',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A849A), // Phin's teal blue active color[cite: 2]
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Credit Card',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Credit Card Form Box[cite: 2]
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    _buildTextField('Credit Card Holder'),
                    const Divider(height: 1, color: Colors.grey),
                    _buildTextField('Credit Card Nmber'), // Kept Phin's typo from the design for authenticity, you can fix it to 'Number'![cite: 2]
                    const Divider(height: 1, color: Colors.grey),
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Expire Date: 01/30')),
                        Container(width: 1, height: 50, color: Colors.grey), // Vertical divider[cite: 2]
                        Expanded(child: _buildTextField('CVV: 999')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom "Check Out" Button[cite: 2]
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThankYouScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CB8CE), // Light blue button[cite: 2]
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Check Out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for clean, borderless text fields inside the container[cite: 2]
  Widget _buildTextField(String hint) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}