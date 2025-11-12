import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_profile_controller.dart';
import '../widgets/profile_tab_content.dart';
import '../widgets/products_tab_content.dart';
import '../widgets/dealing_history_tab_content.dart';

class SellerProfileView extends StatefulWidget {
  const SellerProfileView({Key? key}) : super(key: key);

  @override
  State<SellerProfileView> createState() => _SellerProfileViewState();
}

class _SellerProfileViewState extends State<SellerProfileView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerProfileController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'seller_profile'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.seller.value == null && controller.sellerProfile.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value.isNotEmpty 
                    ? controller.errorMessage.value 
                    : 'seller_info_not_available'.tr,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFF00BFA5),
                      backgroundImage: controller.sellerProfile.value?.image != null && 
                                       controller.sellerProfile.value!.image!.isNotEmpty
                          ? NetworkImage(controller.sellerProfile.value!.image!)
                          : null,
                      child: controller.sellerProfile.value?.image == null || 
                             controller.sellerProfile.value!.image!.isEmpty
                          ? Text(
                              controller.sellerInitials,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    
                    // Name and Rating
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          // Seller Name or Shop Name
                          Text(
                            controller.sellerDisplayName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (controller.sellerProfile.value?.shopName?.isNotEmpty ?? false)
                            Text(
                              controller.sellerName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          const SizedBox(height: 8),
                          
                          // Rating and Reviews in one row
                          controller.isLoadingRating.value
                              ? Row(
                                  children: [
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Loading rating...',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller.ratingText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '/5',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Icons.reviews, color: Colors.blue[600], size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller.reviewsText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 1),
              
              // Tabs Section
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF00BFA5),
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: const Color(0xFF00BFA5),
                  indicatorWeight: 2.5,
                  tabs: [
                    Tab(text: 'profile'.tr),
                    Tab(text: 'products'.tr),
                    Tab(text: 'dealing_history'.tr),
                  ],
                ),
              ),
              
              // TabBarView Content
              SizedBox(
                height: MediaQuery.of(context).size.height - 350,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Profile Tab
                    ProfileTabContent(controller: controller),
                    
                    // Products Tab
                    ProductsTabContent(controller: controller),
                    
                    // Dealing History Tab
                    const DealingHistoryTabContent(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
