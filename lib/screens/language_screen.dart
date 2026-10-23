import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

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
        title: const Text(
          'Language',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English'),
              const Divider(height: 1, indent: 16),
              _buildLanguageOption('Khmer (ភាសាខ្មែរ)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: _selectedLanguage == language 
          ? const Icon(Icons.check_circle, color: Colors.black) 
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        // Wait a brief moment to show the checkmark before popping
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) Navigator.pop(context);
        });
      },
    );
  }
}