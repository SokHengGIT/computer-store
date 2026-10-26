import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/menu_service.dart';
import '../screens/category_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.computer, size: 48, color: Colors.black87),
                SizedBox(height: 12),
                Text('PC Finder Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            title: 'Gaming PCs',
            bannerImage: 'assets/images/gaming_pc_banner.jpg',
          ),
          _buildDrawerItem(
            context,
            title: 'GPUs',
            bannerImage: 'assets/images/gpu_banner.jpg',
          ),
          _buildDrawerItem(
            context,
            title: 'Components',
            bannerImage: 'assets/images/components_banner.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required String title, required String bannerImage}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        context.read<MenuService>().pushCustomPage(
          CategoryScreen(
            categoryTitle: title,
            bannerImagePath: bannerImage,
          ),
        );
      },
    );
  }
}