class Message {
  final String id;
  final String message;
  final String senderId;
  final String senderName;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.createdAt,
  });
}

class Chat {
  String? id;
  final String name;
  final String type;
  final int amount;

  Chat.fromMap(Map<String, dynamic> map, String this.id)
      : name = map['name'],
        type = map['type'],
        amount = map['amount'];

  Chat({
    required this.name,
    required this.type,
    required this.amount,
  });
}
