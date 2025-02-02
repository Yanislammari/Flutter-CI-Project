import "package:ci_project/models/credit_card.dart";
import "package:ci_project/services/transaction_service.dart";
import "package:flutter/material.dart";

class AddTransactionScreen extends StatefulWidget {
  final CreditCard currentCard;

  const AddTransactionScreen({
    super.key,
    required this.currentCard,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController soldController = TextEditingController();
  final TransactionService transactionService = TransactionService();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _makeTransaction() async {
    String iban = ibanController.text;
    double amount = double.tryParse(soldController.text) ?? 0;

    if(iban.isEmpty || amount <= 0) {
      _showErrorDialog("Please enter a valid IBAN and amount.");
      return;
    }

    try {
      await transactionService.addTransaction(iban, amount, widget.currentCard);
      Navigator.pop(context);
      _showSuccessDialog("Transaction successful!");
    }
    catch(e) {
      Navigator.pop(context);
      if(e.toString().contains("Insufficient funds")) {
        _showErrorDialog("Insufficient balance.");
      }
      else {
        _showErrorDialog("Error processing transaction: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: ibanController,
                  decoration: const InputDecoration(
                    labelText: "IBAN",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: soldController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _makeTransaction,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Send Money"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
