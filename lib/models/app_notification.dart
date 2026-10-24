class AppNotification {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.createdAt,
    this.orderId,
    this.isRead = false,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? orderId;
  final bool isRead;

  AppNotification markRead() => AppNotification(
        id: id,
        userId: userId,
        title: title,
        body: body,
        createdAt: createdAt,
        orderId: orderId,
        isRead: true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'orderId': orderId,
        'isRead': isRead,
      };

  factory AppNotification.fromMap(Map<dynamic, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      userId: map['userId'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      orderId: map['orderId'] as String?,
      isRead: (map['isRead'] as bool?) ?? false,
    );
  }
}
