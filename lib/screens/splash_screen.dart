import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Required for the segmented loading ring
import 'welcome_screen.dart'; // We will build this next!

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Automatically navigate to the Welcome Screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Block
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Dark background matching the design
                borderRadius: BorderRadius.circular(32), // Smooth rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                // Placeholder for your team's actual logo asset
                child: Icon(
                  Icons.apple, // Matches the mockup's placeholder
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            
            const SizedBox(height: 80), // Spacing between logo and loader
            
            // Segmented Loading Indicator
            const CupertinoActivityIndicator(
              radius: 16.0, 
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}