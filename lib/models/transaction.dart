class MoneyTransaction {
  final String id;
  final String senderId;
  final String receiverId;
  final double sold;

  MoneyTransaction({
    this.id = "",
    required this.senderId,
    required this.receiverId,
    required this.sold,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "sold": sold,
    };
  }

  factory MoneyTransaction.fromMap(Map<String, dynamic> map, {String id = ""}) {
    return MoneyTransaction(
      id: id,
      senderId: map["senderId"],
      receiverId: map["receiverId"],
      sold: (map["sold"] as num).toDouble(),
    );
  }
}
