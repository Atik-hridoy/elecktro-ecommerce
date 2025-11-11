/// Socket event constants for the application
class SocketEvents {
  // Connection events
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String connectError = 'connect_error';
  static const String reconnect = 'reconnect';
  
  // User events
  static const String join = 'join';
  static const String leave = 'leave';
  static const String userOnline = 'user_online';
  static const String userOffline = 'user_offline';
  
  // Notification events
  static const String notification = 'notification';
  static const String notificationRead = 'notification_read';
  static const String notificationReceived = 'notification_received';
  
  // Order events
  static const String orderUpdate = 'order_update';
  static const String orderPlaced = 'order_placed';
  static const String orderConfirmed = 'order_confirmed';
  static const String orderShipped = 'order_shipped';
  static const String orderDelivered = 'order_delivered';
  static const String orderCancelled = 'order_cancelled';
  
  // Chat events
  static const String chatMessage = 'chat_message';
  static const String chatMessageSent = 'chat_message_sent';
  static const String chatMessageReceived = 'chat_message_received';
  static const String chatTyping = 'chat_typing';
  static const String chatStopTyping = 'chat_stop_typing';
  
  // Product events
  static const String productUpdate = 'product_update';
  static const String productStockUpdate = 'product_stock_update';
  static const String productPriceUpdate = 'product_price_update';
  
  // Cart events
  static const String cartUpdate = 'cart_update';
  static const String cartItemAdded = 'cart_item_added';
  static const String cartItemRemoved = 'cart_item_removed';
  
  // Wishlist events
  static const String wishlistUpdate = 'wishlist_update';
  
  // Payment events
  static const String paymentSuccess = 'payment_success';
  static const String paymentFailed = 'payment_failed';
  static const String paymentPending = 'payment_pending';
  
  // Admin events
  static const String adminBroadcast = 'admin_broadcast';
  static const String systemMaintenance = 'system_maintenance';
  static const String flashSaleStart = 'flash_sale_start';
  static const String flashSaleEnd = 'flash_sale_end';
}
