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
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
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
                          height: 20,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00BFA5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Profile Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  
                  ProfileDetailRow(
                    label: 'Registration No',
                    value: profile?.registrationNo ?? 'N/A',
                  ),
                  ProfileDetailRow(
                    label: 'Name',
                    value: controller.sellerName,
                  ),
                  if (profile?.shopName?.isNotEmpty ?? false)
                    ProfileDetailRow(
                      label: 'Shop Name',
                      value: profile!.shopName!,
                    ),
                  if (profile?.email?.isNotEmpty ?? false)
                    ProfileDetailRow(
                      label: 'Email',
                      value: profile!.email!,
                    ),
                  if (profile?.phone?.isNotEmpty ?? false)
                    ProfileDetailRow(
                      label: 'Contact No',
                      value: profile!.phone!,
                    ),
                  ProfileDetailRow(
                    label: 'Address',
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
