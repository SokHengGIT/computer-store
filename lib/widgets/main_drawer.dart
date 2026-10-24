import 'package:computer_store_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import your services
import '../services/menu_service.dart';

// Import your screens
import '../screens/pc_finder_screen.dart'; 
import '../screens/about_us_screen.dart'; 
import '../screens/address_screen.dart';
import '../screens/track_service_screen.dart';
import '../screens/terms_conditions_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF7F7F7),
      child: Column(
        children: [
          // User Profile Header
          Container(
            width: double.infinity,
            color: const Color(0xFF222222), // Dark grey/black background
            padding: const EdgeInsets.only(top: 70, bottom: 30),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/users/hengrithik.png'),
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'USER',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  'user@gmail.com',
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Drawer Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(
                  Icons.home_outlined, 
                  'Home', 
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.read<MenuService>().onPageChanged(0); // Switch to Home Tab
                  }
                ),
                _buildDrawerItem(
                  Icons.person_outline, 
                  'Profile',
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.read<MenuService>().onPageChanged(4); // Switch to Profile Tab
                  }
                ),
                _buildDrawerItem(
                  Icons.manage_search_outlined,
                  'PC Finder Assistant',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PcFinderScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.location_on_outlined, 
                  'Address',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddressScreen()),
                    );
                  }
                ),
                _buildDrawerItem(
                  Icons.receipt_long_outlined, 
                  'Track service',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TrackServiceScreen()),
                    );
                  }
                ),
                _buildDrawerItem(
                  Icons.description_outlined, 
                  'Terms and Conditions',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
                    );
                  }
                ),
                _buildDrawerItem(
                  Icons.info_outline,
                  'About Us',
                  onTap: () {
                    Navigator.pop(context); 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildDrawerItem(
                  Icons.logout, 
                  'Log out',
                  onTap: () {
                    context.read<MenuService>().onPageChanged(0);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      onTap: onTap ?? () {},
    );
  }
}