import 'package:flutter/material.dart';

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
          'Setting', // Matching Heng's singular spelling
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
              _buildSettingItem(icon: Icons.person_outline, title: 'Personal Information'),
              _buildSettingItem(icon: Icons.shopping_bag_outlined, title: 'Account Security'), // Matches the exact bag icon in the design
              _buildSettingItem(icon: Icons.edit_outlined, title: 'Change Password'),
              const SizedBox(height: 24),

              // PREFERENCE SECTION
              _buildSectionHeader('PREFERENCE'),
              _buildSettingItem(icon: Icons.notifications_none, title: 'Notifications'),
              _buildSettingItem(
                icon: Icons.language, 
                title: 'Language', 
                trailingText: 'English', // Shows current language selection
              ),
              _buildSettingItem(icon: Icons.dark_mode_outlined, title: 'Dark Mode'),
              const SizedBox(height: 24),

              // OTHER SECTION
              _buildSectionHeader('OTHER'),
              _buildSettingItem(icon: Icons.insert_drive_file_outlined, title: 'Privacy Policy'),
              _buildSettingItem(icon: Icons.info_outline, title: 'Help & Support'),
              const SizedBox(height: 40),

              // LOG OUT BUTTON
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Placeholder for future logout logic (clearing tokens, etc.)
                    // For now, it will pop back to the home screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Pill shaped
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

  // Helper method for grey section headers
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

  // Helper method for standard setting rows
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? trailingText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {}, // Make rows tappable
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