import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Help & Support', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: const Column(
                children: [
                  Icon(Icons.support_agent, color: Colors.white, size: 48),
                  SizedBox(height: 16),
                  Text('How can we help you?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildContactRow(Icons.chat_bubble_outline, 'Live Chat', 'Wait time: ~5 mins'),
                  const Divider(height: 1, indent: 56),
                  _buildContactRow(Icons.email_outlined, 'Email Support', 'support@pcstore.com'),
                  const Divider(height: 1, indent: 56),
                  _buildContactRow(Icons.phone_outlined, 'Call Us', '+855 12 345 678'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('FREQUENTLY ASKED QUESTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildFaqItem('How do I track my custom PC build?'),
                  const Divider(height: 1),
                  _buildFaqItem('What is the hardware warranty policy?'),
                  const Divider(height: 1),
                  _buildFaqItem('Can I change my delivery address?'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildFaqItem(String question) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      iconColor: Colors.black,
      textColor: Colors.black,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Text(
            'Detailed answer to "$question" will be displayed here dynamically.',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        )
      ],
    );
  }
}