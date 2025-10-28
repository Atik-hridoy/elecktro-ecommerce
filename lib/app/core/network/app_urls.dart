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

  // category
  static const String getProductsCategories = 'categories';

  // product
  static const String getProducts = 'products/';
  static const String getProductDetails = 'products/single/';
}