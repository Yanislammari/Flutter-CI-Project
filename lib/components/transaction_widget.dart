import "package:flutter/material.dart";

class TransactionWidget extends StatelessWidget {
  final String sender;
  final String receiver;
  final double sold;
  final bool isGain;

  const TransactionWidget({
    super.key,
    required this.sender,
    required this.receiver,
    required this.sold,
    required this.isGain,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "From: $sender",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              Text(
                "To: $receiver",
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(
            isGain ? "+\$${sold.toStringAsFixed(2)}" : "-\$${sold.toStringAsFixed(2)}",
            style: TextStyle(
              color: isGain ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: isGain ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
