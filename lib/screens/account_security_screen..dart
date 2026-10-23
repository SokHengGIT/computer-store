import 'package:flutter/material.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _biometricsEnabled = true;
  bool _twoFactorEnabled = false;

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
        title: const Text('Account Security', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.black,
                  title: const Text('Biometric Login', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Use Face ID or Fingerprint', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  value: _biometricsEnabled,
                  onChanged: (value) => setState(() => _biometricsEnabled = value),
                ),
                const Divider(height: 1, indent: 16),
                SwitchListTile(
                  activeColor: Colors.black,
                  title: const Text('Two-Factor Authentication', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Secure your account with an SMS code', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  value: _twoFactorEnabled,
                  onChanged: (value) => setState(() => _twoFactorEnabled = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('ACTIVE SESSIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.phone_android, color: Colors.black),
              title: const Text('iPhone 15 Pro (Current)', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Phnom Penh, Cambodia', style: TextStyle(fontSize: 12, color: Colors.grey)),
              trailing: const Text('Active', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}