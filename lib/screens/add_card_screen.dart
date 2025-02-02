import "package:ci_project/models/credit_card.dart";
import "package:ci_project/services/card_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController soldController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();

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

  void _addCard() async {
    String number = numberController.text;
    String expDate = expDateController.text;
    String ownerName = ownerNameController.text;
    String cvv = cvvController.text;
    double sold = double.tryParse(soldController.text) ?? 0;
    String iban = ibanController.text;

    if(number.isEmpty || expDate.isEmpty || ownerName.isEmpty || cvv.isEmpty || sold == 0) {
      _showErrorDialog("Please fill all the fields.");
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if(user == null) {
      _showErrorDialog("You need to be logged in to add a card.");
      return;
    }

    CardService cardService = CardService();

    try {
      CreditCard card = CreditCard(number: number, expDate: expDate, ownerName: ownerName, cvv: cvv, sold: sold, iban: iban, userId: user.uid);
      await cardService.addCard(card);
      Navigator.pop(context);
      _showErrorDialog("Card added successfully!");
    }
    catch(e) {
      _showErrorDialog("Error adding card: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Card"),
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
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Card Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: expDateController,
                  decoration: const InputDecoration(
                    labelText: "Expiration Date (MM/YY)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: ownerNameController,
                  decoration: const InputDecoration(
                    labelText: "Cardholder Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: cvvController,
                  decoration: const InputDecoration(
                    labelText: "CVV",
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
                    labelText: "Balance (in USD)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
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
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _addCard,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Add Card"), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
