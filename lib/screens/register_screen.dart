import 'package:flutter/material.dart';
import 'menu_screen.dart'; // To route into the app after successful creation

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // State variables for the toggles
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _wantsOffers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black, // Dark app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Texts
              const Text(
                'Create an account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter your name and set up a\npassword',
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 40),

              // Input Fields
              _buildShadowedTextField(hintText: 'enter your name'),
              const SizedBox(height: 20),
              
              _buildShadowedTextField(hintText: 'enter your email'),
              const SizedBox(height: 20),
              
              _buildShadowedTextField(
                hintText: 'enter your password',
                isPassword: true,
                isObscured: !_isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              ),
              const SizedBox(height: 20),
              
              _buildShadowedTextField(
                hintText: 'enter your confirm password',
                isPassword: true,
                isObscured: !_isConfirmPasswordVisible,
                onVisibilityToggle: () {
                  setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
              ),
              const SizedBox(height: 32),

              // Offer Toggle Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _wantsOffers = !_wantsOffers);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0), // Align circle with first line of text
                      child: Icon(
                        _wantsOffers ? Icons.check_circle : Icons.circle_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _wantsOffers = !_wantsOffers);
                      },
                      child: const Text(
                        "i'd like to receive exlusive offer and promotion via\nemail", // Exact wording and typo from design
                        style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500, height: 1.4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Routes directly into the main app layout as a logged-in user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MenuScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black button
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CREATE',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modified helper to support the trailing eye icon for passwords
  Widget _buildShadowedTextField({
    required String hintText, 
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: isObscured,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // Add the eye icon if it is a password field
          suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.black,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }
}