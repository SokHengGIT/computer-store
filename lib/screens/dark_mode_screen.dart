import 'package:flutter/material.dart';

class DarkModeScreen extends StatefulWidget {
  const DarkModeScreen({super.key});

  @override
  State<DarkModeScreen> createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  String _selectedMode = 'Light Mode'; // Defaulting to light since the app is currently light themed

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
        title: const Text('Dark Mode', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModeOption('Light Mode', Icons.light_mode_outlined),
              const Divider(height: 1, indent: 16),
              _buildModeOption('Dark Mode', Icons.dark_mode_outlined),
              const Divider(height: 1, indent: 16),
              _buildModeOption('System Default', Icons.settings_system_daydream_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption(String mode, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(mode, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: _selectedMode == mode ? const Icon(Icons.check_circle, color: Colors.black) : null,
      onTap: () {
        setState(() => _selectedMode = mode);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.pop(context);
        });
      },
    );
  }
}