import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_profile_controller.dart';
import 'profile_detail_row.dart';

class ProfileTabContent extends StatelessWidget {
  final SellerProfileController controller;

  const ProfileTabContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = controller.sellerProfile.value;
      
      return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            // Profile Details Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'profile_details'.tr,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  
                  ProfileDetailRow(
                    label: 'registration_no'.tr,
                    value: profile?.registrationNo ?? 'N/A',
                  ),
                  ProfileDetailRow(
                    label: 'name'.tr,
                    value: controller.sellerName,
                  ),
                  if (profile?.shopName?.isNotEmpty ?? false)
                    ProfileDetailRow(
                      label: 'shop_name'.tr,
                      value: profile!.shopName!,
                    ),
                  if (profile?.email?.isNotEmpty ?? false)
                    ProfileDetailRow(
                      label: 'email'.tr,
                      value: profile!.email!,
                    ),
                  if (profile?.phone?.isNotEmpty ?? false)
                    ProfileDetailRow(
                      label: 'contact_no'.tr,
                      value: profile!.phone!,
                    ),
                  ProfileDetailRow(
                    label: 'address'.tr,
                    value: profile?.address ?? 'N/A',
                    isLast: true,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      );
    });
  }
}
