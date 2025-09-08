import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import 'widgets/cart_item_tile.dart';
import 'widgets/add_product_button.dart';
import 'widgets/contact_details_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/confirm_order_bar.dart';


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
                    const AddProductButton(),
                    
                    // Product items section
                    _buildProductItems(),
                    
                    const ContactDetailsCard(),
                    
                    const PaymentMethodCard(),
                    
                    const PaymentSummaryCard(),
                    
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
          child: const ConfirmOrderBar(),
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
        return CartItemTile(item: item, index: index);
      },
    );
  }
}
