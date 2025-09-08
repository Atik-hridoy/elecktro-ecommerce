import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/checkout_controller.dart';

class PaymentSummaryCard extends GetView<CheckoutController> {
  const PaymentSummaryCard({super.key});

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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (v) => controller.voucherCode.value = v,
                    controller: TextEditingController(text: controller.voucherCode.value),
                    decoration: InputDecoration(
                      hintText: 'Enter voucher code',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => controller.applyVoucher(controller.voucherCode.value),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Apply', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: controller.voucherCode.value.isEmpty && controller.discount.value == 0
                      ? null
                      : controller.clearVoucher,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => _buildSummaryRow('Subtotal', '\$${controller.subtotal.value.toStringAsFixed(2)}')),
            Obx(() => _buildSummaryRow('Delivery Charge', '\$${controller.deliveryFee.value.toStringAsFixed(2)}')),
            Obx(() => controller.discount.value > 0
                ? _buildSummaryRow('Discount', '-\$${controller.discount.value.toStringAsFixed(2)}')
                : const SizedBox.shrink()),
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
}
