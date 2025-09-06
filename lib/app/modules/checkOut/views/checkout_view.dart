import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 4.0,
          shadowColor: const Color(0x33000000),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: Obx(() => controller.cartItems.isEmpty
            ? const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddProductButton(),
                    
                    // Product items section
                    _buildProductItems(),
                    
                    _buildContactDetailsSection(context),
                    
                    _buildPaymentSection(),
                    
                    _buildPaymentSummarySection(),
                    
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: _buildConfirmOrderButton(),
        ),
      ),
    );
  }

  Widget _buildAddProductButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: OutlinedButton.icon(
        onPressed: () {
          // Handle add product
        },
        icon: const Icon(Icons.add, color: Colors.black54),
        label: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildProductItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.cartItems.length,
      itemBuilder: (context, index) {
        final item = controller.cartItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Product image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3748),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_offer,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'T-Shirt',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['brand'] ?? 'Trkil'} / ${item['size'] ?? 'XL'} / ${item['color'] ?? 'Black'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${(item['price'] ?? 16.30).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (item['originalPrice'] != null)
                          Text(
                            '\$${(item['originalPrice'] as num).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Quantity controls and menu
              Column(
                children: [
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildQuantityButton(
                        Icons.remove,
                        () => controller.updateQuantity(index, (item['quantity'] as int) - 1),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item['quantity'] ?? 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        Icons.add,
                        () => controller.updateQuantity(index, (item['quantity'] as int) + 1),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: icon == Icons.add ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildContactDetailsSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Contact Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddAddressModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'New Address',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildContactField('Contact No', '+963 932 509 736'),
            _buildContactField('Email', 'asaduljamannahtuz@gmail.com'),
            _buildContactField('Address', 'P. O. Box 50332, Damasc, Newyork'),
            _buildContactField('Address Category', 'Home'),
            _buildContactField('Note', 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            DropdownButton<String>(
              value: 'Online Payment',
              items: const [
                DropdownMenuItem(
                  value: 'Online Payment',
                  child: Text('Online Payment'),
                ),
                DropdownMenuItem(
                  value: 'Cash on Delivery',
                  child: Text('Cash on Delivery'),
                ),
              ],
              onChanged: (value) {
                // Handle payment method change
              },
              underline: Container(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummarySection() {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Voucher code',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildSummaryRow('Subtotal', '\$16.30'),
            _buildSummaryRow('Delivery Charge', '\$4.00'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmOrderButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Vat included',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Text(
                '\$ ${controller.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.processCheckout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAddressModal(BuildContext context) {
    final TextEditingController contactController = TextEditingController(text: '+963 932 509 736');
    final TextEditingController emailController = TextEditingController(text: 'asaduljamannahtuz@gmail.com');
    final TextEditingController addressController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    String selectedCategory = 'Home';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Address',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 24),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Contact No field
                  _buildModalField(
                    label: 'Contact No*',
                    controller: contactController,
                    isRequired: true,
                  ),
                  
                  // Email field
                  _buildModalField(
                    label: 'Email*',
                    controller: emailController,
                    isRequired: true,
                  ),
                  
                  // Address field
                  _buildModalField(
                    label: 'Address* (this content will show in Card)',
                    controller: addressController,
                    hintText: 'zip code, city, street, address',
                    isRequired: true,
                  ),
                  
                  // Address Category dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address Category *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              isExpanded: true,
                              underline: Container(),
                              items: ['Home', 'Office', 'Other'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCategory = newValue!;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Note field
                  _buildModalField(
                    label: 'Note (Optional)',
                    controller: noteController,
                    isRequired: false,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle address confirmation
                        Navigator.of(context).pop();
                        // Show success message
                        Get.snackbar(
                          'Success',
                          'Address added successfully',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isRequired ? Colors.black87 : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
