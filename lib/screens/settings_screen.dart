import 'package:computer_store_app/screens/dark_mode_screen.dart';
import 'package:computer_store_app/screens/help_support_screen.dart';
import 'package:computer_store_app/screens/notifications_screen.dart';
import 'package:computer_store_app/screens/privacy_policy_screen.dart';
import 'package:flutter/material.dart';

// Import your new screens
import '../screens/personal_information_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/language_screen.dart';
import 'package:provider/provider.dart';
import '../screens/login_screen.dart';
import '../services/menu_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          'Setting', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ACCOUNT SECTION
              _buildSectionHeader('ACCOUNT'),
              _buildSettingItem(
                context: context,
                icon: Icons.person_outline, 
                title: 'Personal Information',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalInformationScreen()),
                  );
                }
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.shopping_bag_outlined, 
                title: 'Account Security'
              ), 
              _buildSettingItem(
                context: context,
                icon: Icons.edit_outlined, 
                title: 'Change Password',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                  );
                }
              ),
              const SizedBox(height: 24),

              // PREFERENCE SECTION
              _buildSectionHeader('PREFERENCE'),
              _buildSettingItem(
                context: context,
                icon: Icons.notifications_none, 
                title: 'Notifications',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                }
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.language, 
                title: 'Language', 
                trailingText: 'English', 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LanguageScreen()),
                  );
                }
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.dark_mode_outlined, 
                title: 'Dark Mode',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DarkModeScreen()),
                  );
                }
              ),
              const SizedBox(height: 24),

              // OTHER SECTION
              _buildSectionHeader('OTHER'),
              _buildSettingItem(
                context: context,
                icon: Icons.insert_drive_file_outlined, 
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                }
              ),
              _buildSettingItem(
                context: context,
                icon: Icons.info_outline, 
                title: 'Help & Support',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                  );
                }
              ),
              const SizedBox(height: 40),

              // LOG OUT BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<MenuService>().onPageChanged(0);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), 
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }

  // Updated to accept context and an optional onTap callback
  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap ?? () {
          // Fallback for unbuilt screens so the app feels responsive during the presentation
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title coming soon!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }
}