class AppUrls {

  // static const String baseUrl = 'http://10.10.7.62:7010/api/v1/';
  // static const String baseImageUrl = 'http://10.10.7.62:7010/';
  // static const String socketUrl = 'http://10.10.7.62:7010';


  static const String baseUrl = 'https://rakibur5000.binarybards.online/api/v1/';
  static const String baseImageUrl = 'https://rakibur5000.binarybards.online/';
  static const String socketUrl = 'https://rakibur5000.binarybards.online/';



  // static const String baseUrl = 'http://178.16.129.213:7010/api/v1/';
  // static const String baseImageUrl = 'http://178.16.129.213:7010/';
  // static const String socketUrl = 'http://178.16.129.213:7010';



  static const String createAccount = 'auth/register';
  static const String signIn = 'auth/login';
  static const String verifyOtp = 'auth/verify-otp';
  static const String updateProfile = 'users/complete';
  static const String resendOtp = 'auth/resend-otp';

  // profile


  static const String getProfile = 'users/profile';
  static const String updateProfileInsideApp = 'users/profile';
  static const String faqs = 'faqs/';
  static const String createHelp = 'help/create';
  static const String deleteAccount = 'users/delete';

  static const String getSellerProfile = 'products/seller-info/';
  static const String getSellerProducts = 'products/seller-products/';
  static const String getSellerProductsCategories = 'products/seller-product-categories/';
  static const String sellerRating = 'feedbacks/seller/';

  // home 
  static const String getBanner = 'banners/';

  // category

  static const String getProductsCategories = 'categories';

  // product
  
  static const String getProducts = 'products/';
  static const String getPopularProducts = 'products/popular';
  static const String getProductDetails = 'products/single/';
  static const String postBookmark = 'bookmarks/';
  static const String getBookmarks = 'bookmarks/';
  static const String deleteBookmark = 'bookmarks/';
  static const String postReviewFeedback = 'feedbacks/create';
  static const String getReviewFeedback = 'feedbacks/';

  // cart
  static const String addToCart = 'cart/add';
  static const String getCart = 'cart/me';
  static const String increaseQuentity = 'cart/item/:productId/increment';
  static const String decreaseQuentity = 'cart/item/:productId/decrement';
  static const String clearCart = 'cart/clear';
  // paymentSession

  static const String createPaymentSession = 'orders/create-checkout-session';

  // order

  static const String getOrders = 'orders/my-orders';

  // notification

  static const String getNotification = 'notifications/';
  static const String markAllNotificationsRead = 'notifications/';
  static const String readSingleNotification = 'notifications/single/';

  // seller rateing 




// settings


 static const String aboutUs = 'settings?key=aboutUs';

}