import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int _selectedIndex = 0; 
  
  final List<Map<String, dynamic>> _addresses = [
    {
      'title': 'Home',
      'address': 'No. 123, Street 456, Sangkat Toul Tom Poung, Khan Chamkar Mon, Phnom Penh, Cambodia',
      'phone': '+855 12 345 678',
      'isDefault': true,
    },
    {
      'title': 'Work',
      'address': 'SETEC Institute, Street 86, Sangkat Boeung Kak I, Khan Toul Kork, Phnom Penh, Cambodia',
      'phone': '+855 98 765 432',
      'isDefault': false,
    }
  ];
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
          'My Addresses',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _addresses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildAddressCard(index);
                },
              ),
            ),
            
            // Add New Address Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddAddressModal,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add New Address', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Helper: Address Card
  Widget _buildAddressCard(int index) {
    final addressData = _addresses[index];
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300, 
            width: isSelected ? 2 : 1
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03), 
              blurRadius: 8, 
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      addressData['title'] == 'Home' ? Icons.home : 
                      (addressData['title'] == 'Work' ? Icons.work : Icons.location_on), 
                      color: Colors.black, 
                      size: 20
                    ),
                    const SizedBox(width: 8),
                    Text(
                      addressData['title'], 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    if (addressData['isDefault'] == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12)),
                        child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 10)),
                      )
                    ]
                  ],
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.edit_outlined, 
                  color: isSelected ? Colors.black : Colors.grey, 
                  size: 20
                ),
              ],
            ),
            const Divider(height: 24),
            Text(addressData['address'], style: const TextStyle(color: Colors.black87, height: 1.4, fontSize: 13)),
            const SizedBox(height: 8),
            Text('Phone: ${addressData['phone']}', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // Helper: Add Address Modal
  void _showAddAddressModal() {
    _titleController.clear();
    _addressController.clear();
    _phoneController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add New Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title (e.g., Studio, Apartment)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Full Address', border: OutlineInputBorder()),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty && _addressController.text.isNotEmpty) {
                      setState(() {
                        _addresses.add({
                          'title': _titleController.text,
                          'address': _addressController.text,
                          'phone': _phoneController.text,
                          'isDefault': false,
                        });
                        _selectedIndex = _addresses.length - 1; 
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Address', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}