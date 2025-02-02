import "package:ci_project/screens/add_card_screen.dart";
import "package:ci_project/screens/add_transaction_screen.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_credit_card/flutter_credit_card.dart";
import "package:ci_project/models/credit_card.dart";
import "package:ci_project/services/card_service.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CardService _cardService = CardService();
  CreditCard? currentCard;
  User? user = FirebaseAuth.instance.currentUser;
  String email = "";
  bool _isLoading = true;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    email = user?.email ?? "Utilisateur non connecté";
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<CreditCard> cards = await _cardService.getCards();
    setState(() {
      currentCard = cards.isNotEmpty ? cards[0] : null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bank CI"), backgroundColor: Colors.blue),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading ? const Center(child: CircularProgressIndicator()) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Account : $email", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              currentCard == null ? const AddCardScreen() : CreditCardWidget(
                cardNumber: currentCard!.number,
                expiryDate: currentCard!.expDate,
                cardHolderName: currentCard!.ownerName,
                cvvCode: currentCard!.cvv,
                showBackView: false,
                onCreditCardWidgetChange: (CreditCardBrand brand) {},
              ),
              Center(
                child: Column(
                  children: [
                    const Text("Actual sold", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      currentCard != null ? "\$${currentCard!.sold.toStringAsFixed(2)}" : "\$0.00",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => {
                        Navigator.pushNamed(context, "/add-card"),
                    },
                    child: const Text("Add card")
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedCard = await Navigator.pushNamed(context, "/change-card");
                      if (selectedCard != null && selectedCard is CreditCard) {
                        setState(() => currentCard = selectedCard);
                      }
                    },
                    child: const Text("Change card"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/delete-card",
                        arguments: currentCard,
                      );
                    },
                    child: const Text("Delete card"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (currentCard != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTransactionScreen(currentCard: currentCard!),
                          ),
                        );
                      } else {
                        _showErrorDialog("No card selected.");
                      }
                    },
                    child: const Text("Make a transfer"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/transactions-history");
                    },
                    child: const Text("Transaction history"),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}