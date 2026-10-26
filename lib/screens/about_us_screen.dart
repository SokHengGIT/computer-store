import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.black;
    final List<String> distributors = [
      'assets/images/about_us/distributors/acer.png',
      'assets/images/about_us/distributors/asus.png',
      'assets/images/about_us/distributors/dell.png',
      'assets/images/about_us/distributors/hp.png',
      'assets/images/about_us/distributors/lenovo.png',
      'assets/images/about_us/distributors/logitech.png',
      'assets/images/about_us/distributors/transcend.png',
    ];
    final List<String> resellers = [
      'assets/images/about_us/resellers/apple.png',
      'assets/images/about_us/resellers/intel.png',
      'assets/images/about_us/resellers/microsoft.png',
      'assets/images/about_us/resellers/msi.png',
      'assets/images/about_us/resellers/oracle.png',
      'assets/images/about_us/resellers/panasonic.png',
      'assets/images/about_us/resellers/razer.png',
      'assets/images/about_us/resellers/rog.png',
      'assets/images/about_us/resellers/vmware.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Founded with a pure passion for high-performance computing, we have grown into the premier destination for PC enthusiasts, gamers, and professionals. What started as a small team of dedicated hardware experts has rapidly evolved into a leading technology hub.\n\nWe partner directly with the world\'s top tech brands to deliver cutting-edge components, bespoke custom-built workstations, and uncompromising gaming rigs. \n\nOur commitment extends far beyond simply selling hardware. We strive to provide expert guidance, exceptional customer support, and rock-solid warranty services to ensure your setup runs flawlessly. Whether you are building your first PC or outfitting an entire creative studio, we are here to push the boundaries of what your hardware can achieve.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 32),

            _buildInfoCard(
              title: 'MISSION',
              content: 'To empower creators, gamers, and professionals by providing unparalleled access to top-tier technology, custom hardware solutions, and uncompromising technical support that elevates their daily performance.',
              borderColor: primaryColor,
            ),
            const SizedBox(height: 16),

            _buildInfoCard(
              title: 'VISION',
              content: 'To become the ultimate and most trusted technology ecosystem in the region, inspiring innovation and setting the gold standard for the modern computing experience.',
              borderColor: primaryColor,
            ),
            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'OUR PARTNERS',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 32),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Authorized Distributor',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            _buildPartnerGrid(distributors),

            const SizedBox(height: 32),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Authorized Reseller',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            _buildPartnerGrid(resellers),
            
            const SizedBox(height: 40), 
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content, required Color borderColor}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.5)),
            ),
            child: Text(
              title,
              style: TextStyle(color: borderColor, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // Helper
  Widget _buildPartnerGrid(List<String> imagePaths) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), 
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, 
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5, 
      ),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.image_not_supported, color: Colors.grey, size: 16),
            ),
          ),
        );
      },
    );
  }
}