import 'package:flutter/material.dart';

// Import your screens here
import '../screens/pc_finder_screen.dart'; // Adjust path if needed
import '../screens/about_us_screen.dart'; // Adjust path if needed

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
            color: Colors.black87,
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
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),

          // Drawer Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(Icons.home_outlined, 'Home', onTap: () {
                  Navigator.pop(context);
                  // Optionally route back to home if not already there
                }),
                _buildDrawerItem(Icons.person_outline, 'Profile'),
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
                
                // // --- NEW: CATEGORY SECTION ---
                // const Padding(
                //   padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
                //   child: Text(
                //     'SHOP BY CATEGORY',
                //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                //   ),
                // ),
                // _buildDrawerItem(
                //   Icons.computer,
                //   'Gaming PCs', //[cite: 6]
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const CategoryScreen(
                //           categoryTitle: 'Gaming PCs', //[cite: 6]
                //           bannerImagePath: 'assets/images/gaming_pc_banner.jpg',
                //         ),
                //       ),
                //     );
                //   },
                // ),
                // _buildDrawerItem(
                //   Icons.developer_board,
                //   'GPUs', //[cite: 6]
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const CategoryScreen(
                //           categoryTitle: 'GPUs', //[cite: 6]
                //           bannerImagePath: 'assets/images/gpu_banner.jpg',
                //         ),
                //       ),
                //     );
                //   },
                // ),
                // _buildDrawerItem(
                //   Icons.memory,
                //   'Components', //[cite: 6]
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const CategoryScreen(
                //           categoryTitle: 'Components', //[cite: 6]
                //           bannerImagePath: 'assets/images/components_banner.jpg',
                //         ),
                //       ),
                //     );
                //   },
                // ),
                // const Divider(),
                // // --- END CATEGORY SECTION ---

                _buildDrawerItem(Icons.location_on_outlined, 'Address'),
                _buildDrawerItem(Icons.manage_search_outlined, 'Track service'),
                _buildDrawerItem(Icons.description_outlined, 'Terms and Conditions'),
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
                _buildDrawerItem(Icons.logout, 'Log out'),
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