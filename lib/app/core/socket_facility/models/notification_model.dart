/// Model for notification data
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? payload;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.payload,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? json['message'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      payload: json['payload'],
      type: _parseNotificationType(json['type']),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['isRead'] ?? json['is_read'] ?? false,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'payload': payload,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    String? payload,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      payload: payload ?? this.payload,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }

  static NotificationType _parseNotificationType(dynamic type) {
    if (type == null) return NotificationType.general;
    
    final typeStr = type.toString().toLowerCase();
    switch (typeStr) {
      case 'order':
        return NotificationType.order;
      case 'chat':
        return NotificationType.chat;
      case 'product':
        return NotificationType.product;
      case 'payment':
        return NotificationType.payment;
      case 'promotion':
        return NotificationType.promotion;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.general;
    }
  }
}

/// Types of notifications
enum NotificationType {
  general,
  order,
  chat,
  product,
  payment,
  promotion,
  system,
}
