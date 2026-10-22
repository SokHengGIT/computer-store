import 'package:flutter/material.dart';
import 'otp_screen.dart'; // To route to the verification code screen
import 'login_screen.dart'; // For the "Already have an account?" link

class RegisterMobileScreen extends StatelessWidget {
  const RegisterMobileScreen({super.key});

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
          'Register',
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
                "What't your mobile number?", // Preserved exact typo from design
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              const Text(
                "We'll send a code to your mobile for\nreset password", // Reused text from forgot password screen
                style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 40),

              // Phone Number Input Field with Flag
              Container(
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
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🇰🇭', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    hintText: 'phone number',
                    hintStyle: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to OTP Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'VERIFY MOBILE NYMBER', // Preserved typo
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Login Return Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Terms & Privacy Footer
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 12, height: 1.4, fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(text: "Please note that by creating and/or using your account.\naccept our"), // Preserved line break and spacing
                      TextSpan(text: "Term of Usage", style: TextStyle(color: Colors.blue)),
                      TextSpan(text: " and "),
                      TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}