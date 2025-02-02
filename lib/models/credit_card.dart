class CreditCard {
  final String id;
  final String number;
  final String expDate;
  final String ownerName;
  final String cvv;
  final double sold;
  final String iban;
  final String userId;

  CreditCard({
    this.id = "",
    required this.number,
    required this.expDate,
    required this.ownerName,
    required this.cvv,
    required this.sold,
    required this.iban,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "expDate": expDate,
      "ownerName": ownerName,
      "cvv": cvv,
      "sold": sold,
      "iban": iban,
      "userId": userId,
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> map, {String id = ""}) {
    return CreditCard(
      id: id,
      number: map["number"],
      expDate: map["expDate"],
      ownerName: map["ownerName"],
      cvv: map["cvv"],
      sold: (map["sold"] as num).toDouble(),
      iban: map["iban"],
      userId: map["userId"],
    );
  }
}
