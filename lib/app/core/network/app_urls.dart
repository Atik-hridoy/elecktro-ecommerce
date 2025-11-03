class AppUrls {

  static const String baseUrl = 'http://10.10.7.62:7010/api/v1/';
  static const String baseImageUrl = 'http://10.10.7.62:7010/';



  static const String createAccount = 'auth/register';
  static const String signIn = 'auth/login';
  static const String verifyOtp = 'auth/verify-otp';
  static const String updateProfile = 'users/complete';

  // profile


  static const String getProfile = 'users/profile';
  static const String updateProfileInsideApp = 'users/profile';
  static const String faqs = 'faqs/';
  static const String createHelp = 'help/create';

  static const String getSellerProfile = 'products/seller-info/';
  static const String getSellerProducts = 'products/seller-products/';
  static const String getSellerProductsCategories = 'products/seller-product-categories/';

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
  static const String postReviewFeedback = 'feedbacks/create';
  static const String getReviewFeedback = 'feedbacks/';

  // cart
  static const String addToCart = 'cart/add';
  static const String getCart = 'cart/me';
  // paymentSession

  static const String createPaymentSession = 'orders/create-checkout-session';

  // order

  static const String getOrders = 'orders/my-orders';

  // notification

  static const String getNotification = 'notifications/';
  static const String markAllNotificationsRead = 'notifications/';
  static const String readSingleNotification = 'notifications/single/';

}