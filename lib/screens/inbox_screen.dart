import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

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
          'Inbox',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          _buildInboxItem(
            title: 'Order Shipped',
            subtitle: 'Your RTX 5090 On the way.',
            time: '10:30 AM',
            isUnread: true,
          ),
          const Divider(height: 1, color: Colors.black12),
          _buildInboxItem(
            title: 'New Gaming Deals',
            subtitle: 'Save up to 20% this weekend.',
            time: 'Yesterday',
            isUnread: true,
          ),
          const Divider(height: 1, color: Colors.black12),
          _buildInboxItem(
            title: 'Welcome to PC Store',
            subtitle: 'Thanks you for create account.',
            time: 'Oct 2',
            isUnread: false,
          ),
          const Divider(height: 1, color: Colors.black12),
          _buildInboxItem(
            title: 'Order Confirmed',
            subtitle: 'Your Order #123 has been confirmed.',
            time: 'Oct 5',
            isUnread: false,
          ),
          const Divider(height: 1, color: Colors.black12),
          _buildInboxItem(
            title: 'Special Offer For You',
            subtitle: 'Get 15% on Gaming PC.',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  // Helper method to build each row
  Widget _buildInboxItem({
    required String title,
    required String subtitle,
    String time = '',
    required bool isUnread,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.mail_outline, color: Colors.white, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          if (isUnread) ...[
            const SizedBox(height: 8),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ]
        ],
      ),
      onTap: () {
        // Future logic to read message
      },
    );
  }
}