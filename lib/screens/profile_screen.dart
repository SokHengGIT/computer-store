import 'package:computer_store_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import '../screens/inbox_screen.dart';
import '../screens/offers_screen.dart';
import '../screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 32),
                
                // Avatar with Camera Badge
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/users/hengrithik.png'), // Reusing the asset from your sidebar
                      backgroundColor: Colors.grey,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Name and Email
                const Text(
                  'Heng Rithik',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 4),
                const Text(
                  'hengrithik@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                    label: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, 
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Account Section Header
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account',
                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                
                // List Items (Strictly matching the Figma design)
                _buildListTile(
                  Icons.email, 
                  Colors.black, 
                  'Inbox', 
                  'Message & notification',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InboxScreen()),
                    );
                  }
                ),
                _buildListTile(
                  Icons.confirmation_num_outlined, 
                  Colors.black, 
                  'Offers & promo code', 
                  'View available deals',
                  onTap: () { // Add this tap handler!
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OffersScreen()),
                    );
                  }
                ),
                _buildListTile(
                  Icons.card_giftcard, 
                  Colors.black, 
                  'My Orders', 
                  'Track your purchase',
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen())
                    );
                  }
                ),
                _buildListTile(
                  Icons.favorite_border, 
                  Colors.black, 
                  'Wishtlist', // Restored Heng's exact spelling
                  'Your saved products'
                ),
                _buildListTile(
                  Icons.settings_outlined, 
                  Colors.black, 
                  'Setting', 
                  'Account & app settings',
                  onTap: () { // Add this tap handler!
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the list tiles
  Widget _buildListTile(IconData icon, Color iconColor, String title, String subtitle, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}