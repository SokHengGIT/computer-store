import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
          'Terms & Conditions',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Updated: October 2026',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _buildSection('1. Introduction', 'Welcome to our platform. By accessing or using our application, you agree to be bound by these Terms and Conditions and our Privacy Policy.'),
            _buildSection('2. Hardware Warranty', 'All custom PC builds and individual components sold through this application come with a standard 1-year limited warranty unless explicitly stated otherwise by the manufacturer. Warranty covers hardware defects but does not cover accidental damage, liquid damage, or unauthorized modifications.'),
            _buildSection('3. Returns and Refunds', 'Unopened items may be returned within 14 days of purchase with a valid receipt. Custom-built PCs are subject to a 15% restocking fee if returned without defects, as components are specially assembled for your order.'),
            _buildSection('4. Service and Repairs', 'When submitting a device for tracking and repair via our Track Service module, you authorize our technicians to perform necessary diagnostics. We are not responsible for data loss; please ensure all data is backed up before handing over your device.'),
            _buildSection('5. Limitation of Liability', 'In no event shall the company be liable for any indirect, incidental, or consequential damages arising out of the use or inability to use our products or services.'),
            const SizedBox(height: 40),
            Center(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1.5),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('I Understand', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
          const SizedBox(height: 8),
          Text(content, textAlign: TextAlign.justify, style: const TextStyle(height: 1.5, color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}