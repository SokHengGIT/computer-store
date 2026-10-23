import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last Updated: October 2026', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            _buildSection('1. Data Collection', 'We collect information you provide directly to us when you create an account, make a purchase, or contact customer support. This includes your name, email, phone number, and delivery address.'),
            _buildSection('2. How We Use Your Data', 'Your data is strictly used to process your hardware orders, provide custom PC build updates, and enhance your shopping experience. We do not sell your personal data to third parties.'),
            _buildSection('3. Security', 'We implement industry-standard encryption to protect your payment details and account security. However, no electronic transmission over the internet is completely secure.'),
            _buildSection('4. Contact Us', 'If you have questions regarding our privacy practices, please contact our data protection team via the Help & Support section.'),
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