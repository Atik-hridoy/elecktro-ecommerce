import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/checkout_controller.dart';

class PaymentMethodCard extends GetView<CheckoutController> {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            Obx(() => DropdownButton<String>(
                  value: controller.selectedPaymentMethod.value,
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
                    if (value != null) controller.setPaymentMethod(value);
                  },
                  underline: Container(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
                )),
          ],
        ),
      ),
    );
  }
}
