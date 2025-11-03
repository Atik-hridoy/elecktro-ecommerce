import 'dart:io';
import 'package:elecktro_ecommerce/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:elecktro_ecommerce/app/modules/category/models/get_product_details_models.dart';
import 'package:elecktro_ecommerce/app/core/network/app_urls.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/services/add_to_card_service.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/services/create_and_get_review_feedback_service.dart';
import 'package:elecktro_ecommerce/app/modules/product_details/model/add_to_cart.dart';
import 'package:flutter/material.dart';

/// Manages the state for the ProductDetailsView.
class ProductDetailsController extends GetxController {
 /////////////  data
Rxn<ProductDetailModel> product = Rxn();

  // --- Product Data Properties ---
  final RxString productId = ''.obs;
  final RxString name = ''.obs;
  final RxString brand = ''.obs;
  final RxString price = ''.obs;
  final RxString imageUrl = ''.obs;
  final RxString discount = ''.obs;
  
  // final Rx<ProductResponse?> productResponse = Rx<ProductResponse?>(null);
  
  // --- Seller Information ---
  final seller = Seller(
    id: '',
    firstName: '',
    lastName: '',
  ).obs;
  final rating = 0.0.obs;
  final reviewCount = 0.obs;

  // --- UI State ---
  final isLoading = true.obs;
  final RxInt quantity = 1.obs;
  final RxInt selectedSizeIndex = 3.obs;
  final RxInt selectedColorIndex = 0.obs;
  final RxInt selectedImageIndex = 0.obs;

  // Cart service
  final CartService _cartService = CartService();
  final RxBool isAddingToCart = false.obs;
  
  // Review service
  final CreateReviewFeedbackService _reviewService = CreateReviewFeedbackService();
  final RxBool isSubmittingReview = false.obs;
  final RxBool isLoadingReviews = false.obs;
  
  // Reviews
  final RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;

  // Get available sizes from the product
  List<String>? get _availableSizes {
    if (product.value?.sizeType == null) return null;
    return product.value!.sizeType.map((sizeType) => sizeType.size).toList();
  }
  
  // Get available colors from the product
  List<Color> get _availableColors {
    final colors = product.value?.color;
    if (colors == null || colors.isEmpty) {
      return [Colors.grey];
    }
    
    // Convert hex color strings to Color objects
    return colors.map((colorString) {
      try {
        if (colorString.isEmpty) return Colors.grey;
        
        String hexColor = colorString.trim();
        
        // Remove '#' if present
        if (hexColor.startsWith('#')) {
          hexColor = hexColor.substring(1);
        }
        
        // Handle 3-digit hex (e.g., 'F00' for red)
        if (hexColor.length == 3) {
          hexColor = 'FF' + hexColor.split('').map((c) => c + c).join();
        }
        // Handle 6-digit hex (add FF for full opacity)
        else if (hexColor.length == 6) {
          hexColor = 'FF$hexColor';
        }
        // If not 3, 6, or 8 digits, return grey
        else if (hexColor.length != 8) {
          return Colors.grey;
        }
        
        // Parse the hex color
        final colorInt = int.tryParse(hexColor, radix: 16);
        if (colorInt == null) {
          return Colors.grey;
        }
        
        return Color(colorInt);
      } catch (e) {
        return Colors.grey;
      }
    }).toList();
  }



  void _loadProductDetailsFromParameters() {
    try {
      isLoading.value = true;
      final argData = Get.arguments;
      print("kaj kora na kan ");
      print(argData);
      if(argData != null && argData is ProductDetailModel){
        product.value = argData;  
      }else{
/////////////  error 
      }
      


    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details: ${e.toString()}');
      name.value = 'Error Loading Product';
    } finally {
      isLoading.value = false;
    }
  }


 

  // --- UI Actions ---
  void selectSize(int index) => selectedSizeIndex.value = index;
  void selectColor(int index) => selectedColorIndex.value = index;
  void selectImage(int index) => selectedImageIndex.value = index;
  void incrementQuantity() => quantity.value++;
  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // --- Business Logic Actions ---
  void updateQuantity(int newQuantity) {
    if (newQuantity >= 1) {
      quantity.value = newQuantity;
    }
  }

  // Helper method to parse price from string to double
  double _parsePrice(String priceStr) {
    if (priceStr.isEmpty) return 0.0;
    // Remove any non-numeric characters except decimal point and minus
    final numericString = priceStr.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }

  void onBuyNow() {
    if (product.value == null) {
      Get.snackbar('Error', 'Product not loaded');
      return;
    }

    // Get available sizes and colors
    final sizes = _availableSizes ?? [];
    final colors = _availableColors;
    
    // Get selected size and color with proper bounds checking
    final selectedSize = sizes.isNotEmpty 
        ? sizes[selectedSizeIndex.value.clamp(0, sizes.length - 1)] 
        : 'One Size';
        
    final selectedColor = colors.isNotEmpty && product.value!.color.isNotEmpty
        ? product.value!.color[selectedColorIndex.value.clamp(0, product.value!.color.length - 1)]
        : 'Default';
    
    // Create cart item with all necessary details
    final cartItem = {
      'id': product.value!.id,
      'name': product.value!.name,
      'brand': product.value!.brand,
      'price': _parsePrice(price.value),
      'originalPrice': 0.0,
      'quantity': quantity.value,
      'size': selectedSize,
      'color': selectedColor,
      'image': product.value!.images.isNotEmpty ? product.value!.images[0] : '',
      'productId': product.value!.id,
      'sellerId': product.value!.sellerId.id,
    };

    // Navigate to checkout with the cart item
    Get.toNamed(Routes.checkout, arguments: {
      'directCheckout': true,
      'cartItems': [cartItem],
    });
  }
  
  // Helper method to get color name from Color object
  String _getColorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.grey) return 'Grey';
    return 'Custom Color';
  }

  Future<void> onAddToCart() async {
    final currentProduct = product.value;
    if (currentProduct == null) {
      Get.snackbar('Error', 'Product information not available');
      return;
    }

    try {
      isAddingToCart.value = true;
      
      // Get available sizes and colors with proper bounds checking
      final sizes = _availableSizes ?? ['M']; // Default to 'M' if sizes not available
      final selectedSize = sizes[selectedSizeIndex.value.clamp(0, sizes.length - 1)];
      
      // Get the color string from product colors if available, otherwise use a default
      final colorString = currentProduct.color.isNotEmpty && 
                         selectedColorIndex.value < currentProduct.color.length
          ? currentProduct.color[selectedColorIndex.value]
          : '#000000';
      
      // Create AddToCartModel with selected options
      final addToCartModel = AddToCartModel(
        productId: currentProduct.id,
        size: selectedSize,
        price: _parsePrice(price.value),
        quantity: quantity.value,
        color: colorString,
        images: currentProduct.images.toList(),
      );

      // Call the cart service
      final result = await _cartService.addToCart(addToCartModel);
      
      if (result['success'] == true) {
        Get.snackbar('Success', '${currentProduct.name} added to cart');
      } else {
        Get.snackbar('Error', result['message'] ?? 'Failed to add to cart');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: ${e.toString()}');
    } finally {
      isAddingToCart.value = false;
    }
  }

    @override
  void onInit() {
    super.onInit();
    _loadProductDetails();
    fetchReviewFeedback();
  }

  void _loadProductDetails() {
    try {
      isLoading.value = true;
      final dynamic args = Get.arguments;
      
      if (args == null) {
        throw Exception('No product data provided');
      }

      if (args is ProductDetailModel) {
        _updateFromProductModel(args);
      } else if (args is Map) {
        _updateFromMap(args);
      } else {
        throw Exception('Invalid product data format');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product details');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFromProductModel(ProductDetailModel productData) {
    product.value = productData;
    productId.value = productData.id ?? '';
    name.value = productData.name ?? 'Product Not Found';
    brand.value = productData.brand ?? 'N/A';
    
    // Handle images
    if (productData.images != null && productData.images!.isNotEmpty) {
      // Format all image URLs
      final formattedImages = productData.images!.map((imagePath) => 
        imagePath.startsWith('http') 
            ? imagePath 
            : '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}'
      ).toList();
      
      // Update the product with formatted images
      product.value = productData.copyWith(images: formattedImages);
      
      // Set the first image as the main image URL
      if (formattedImages.isNotEmpty) {
        imageUrl.value = formattedImages.first;
      }
    }
    
    // Handle seller info
    if (productData.sellerId != null) {
      seller.value = productData.sellerId!;
    }
    
    // Handle price and discount
    if (productData.sizeType != null && productData.sizeType!.isNotEmpty) {
      final sizeType = productData.sizeType.first;
      price.value = '\$${sizeType.price?.toStringAsFixed(2) ?? '0.00'}';
      if (sizeType.discount != null && sizeType.discount > 0) {
        discount.value = '${sizeType.discount.toStringAsFixed(0)}% OFF';
      }
    }
  }

  void _updateFromMap(Map<dynamic, dynamic> data) {
    productId.value = data['id']?.toString() ?? '';
    name.value = data['name']?.toString() ?? 'Product Not Found';
    brand.value = data['brand']?.toString() ?? 'N/A';
    price.value = data['price']?.toString() ?? '\$0.00';
    imageUrl.value = data['imageUrl']?.toString() ?? '';
    discount.value = data['discount']?.toString() ?? '';
    
    // Update seller info if available
    if (data['sellerName'] != null) {
      seller.value = Seller(
        id: data['sellerId']?.toString() ?? '',
        firstName: data['sellerName']?.toString() ?? '',
        lastName: data['sellerLastName']?.toString() ?? '',
      );
    }
  }
  
  // Submit review to backend
  Future<bool> submitReview({
    required String reviewText,
    required double rating,
    required List<File> images,
    String? title,
  }) async {
    if (product.value == null) {
      Get.snackbar('Error', 'Product not found');
      return false;
    }

    try {
      isSubmittingReview.value = true;

      final response = await _reviewService.createReview(
        productId: product.value!.id!,
        comment: reviewText,
        rating: rating.toInt(),
        images: images.isNotEmpty ? images : null,
      );

      if (response != null && response.success) {
        // Add review to local list for immediate display
        // Construct full image URLs using baseImageUrl
        final imageUrls = (response.data?.images ?? []).map((imagePath) {
          if (imagePath.startsWith('http')) {
            return imagePath;
          }
          return '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
        }).toList();
        
        addReview(
          reviewText: reviewText,
          rating: rating,
          imageUrls: imageUrls,
          title: title,
        );
        
        Get.snackbar(
          'Success',
          'Review submitted successfully!',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[800],
        );
        return true;
      } else {
        Get.snackbar('Error', 'Failed to submit review');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review: ${e.toString()}');
      return false;
    } finally {
      isSubmittingReview.value = false;
    }
  }
  
  // Add a new review to local list
  void addReview({
    required String reviewText,
    required double rating,
    required List<String> imageUrls,
    String? title,
    String? userImage,
  }) {
    final newReview = {
      'name': 'You', // You can get actual user name from auth
      'title': title ?? '',
      'review': reviewText,
      'rating': rating,
      'date': _formatDate(DateTime.now()),
      'images': imageUrls,
      'userImage': userImage,
    };
    
    // Add to the beginning of the list so it appears first
    reviews.insert(0, newReview);
  }
  
  // Format date helper
  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  // Fetch review feedback from API
  Future<void> fetchReviewFeedback() async {
    if (product.value?.id == null) {
      print('Product ID is null, cannot fetch reviews');
      return;
    }

    try {
      isLoadingReviews.value = true;
      print('Fetching reviews for product ID: ${product.value!.id}');
      
      final response = await _reviewService.getReviewFeedback(
        productId: product.value!.id!,
      );
      
      print('Review feedback response: $response');
      
      if (response != null) {
        // Parse the response and update reviews list
        if (response is Map && response['data'] != null) {
          final List<dynamic> feedbackList = response['data'] is List 
              ? response['data'] 
              : [response['data']];
          
          reviews.clear();
          
          for (var feedback in feedbackList) {
            if (feedback is Map) {
              // Extract user info
              final user = feedback['userId'] ?? {};
              final userName = user is Map 
                  ? '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim()
                  : 'Anonymous';
              
              // Extract user profile image
              String? userImageUrl;
              if (user is Map && user['image'] != null) {
                final profileImage = user['image'].toString();
                if (profileImage.isNotEmpty) {
                  userImageUrl = profileImage.startsWith('http')
                      ? profileImage
                      : '${AppUrls.baseImageUrl}${profileImage.startsWith('/') ? profileImage.substring(1) : profileImage}';
                  print('User image URL: $userImageUrl');
                }
              }
              
              // Extract images and format URLs
              final List<String> imageUrls = [];
              if (feedback['images'] != null && feedback['images'] is List) {
                for (var imagePath in feedback['images']) {
                  if (imagePath is String) {
                    final fullUrl = imagePath.startsWith('http')
                        ? imagePath
                        : '${AppUrls.baseImageUrl}${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}';
                    imageUrls.add(fullUrl);
                  }
                }
              }
              
              // Parse date
              String formattedDate = '';
              if (feedback['createdAt'] != null) {
                try {
                  final date = DateTime.parse(feedback['createdAt']);
                  formattedDate = _formatDate(date);
                } catch (e) {
                  print('Error parsing date: $e');
                }
              }
              
              final review = {
                'name': userName.isNotEmpty ? userName : 'Anonymous',
                'title': '', // API doesn't seem to have title field
                'review': feedback['comment'] ?? '',
                'rating': (feedback['rating'] ?? 5).toDouble(),
                'date': formattedDate,
                'images': imageUrls,
                'userImage': userImageUrl,
              };
              
              reviews.add(review);
              print('Added review: $review');
            }
          }
          
          print('Total reviews loaded: ${reviews.length}');
        }
      }
    } catch (e, stackTrace) {

    } finally {
      isLoadingReviews.value = false;
    }
  }
}