import 'package:flutter/material.dart';
import 'login_screen.dart'; // To route back to login after confirmation

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  // State variables to toggle password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black, // Dark app bar[cite: 13]
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Password',
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
              // Header Texts[cite: 13]
              const Text(
                'Create Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please set up your a new password here', // Exact typo from design[cite: 13]
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 40),

              // Password Input[cite: 13]
              _buildShadowedTextField(
                hintText: 'enter your password',
                isObscured: !_isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              ),
              const SizedBox(height: 20),
              
              // Confirm Password Input[cite: 13]
              _buildShadowedTextField(
                hintText: 'enter your comfirm password', // Exact typo from design[cite: 13]
                isObscured: !_isConfirmPasswordVisible,
                onVisibilityToggle: () {
                  setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                },
              ),
              const SizedBox(height: 40),

              // Confirm Button[cite: 13]
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Password successfully reset! Route user back to Login.
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                    
                    // Optional: Show a quick success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password updated successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Black button[cite: 13]
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM',
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

  // Reused helper widget for the elevated input fields with the eye icon[cite: 13]
  Widget _buildShadowedTextField({
    required String hintText, 
    required bool isObscured,
    required VoidCallback onVisibilityToggle,
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
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: Colors.black,
            ),
            onPressed: onVisibilityToggle,
          ),
        ),
      ),
    );
  }
}