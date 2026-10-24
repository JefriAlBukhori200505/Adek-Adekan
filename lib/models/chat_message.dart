class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.orderId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
  });

  final String id;
  final String orderId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime sentAt;

  Map<String, dynamic> toMap() => {
        'id': id,
        'orderId': orderId,
        'senderId': senderId,
        'senderName': senderName,
        'text': text,
        'sentAt': sentAt.toIso8601String(),
      };

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      orderId: map['orderId'] as String,
      senderId: map['senderId'] as String,
      senderName: (map['senderName'] as String?) ?? '',
      text: map['text'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String),
    );
  }
}
