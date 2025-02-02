import "package:flutter/material.dart";
import "package:flutter_credit_card/flutter_credit_card.dart";
import "package:ci_project/models/credit_card.dart";
import "package:ci_project/services/card_service.dart";

class ChangeCardScreen extends StatefulWidget {
  const ChangeCardScreen({super.key});

  @override
  _ChangeCardScreenState createState() => _ChangeCardScreenState();
}

class _ChangeCardScreenState extends State<ChangeCardScreen> {
  final CardService _cardService = CardService();
  List<CreditCard> _cards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    List<CreditCard> cards = await _cardService.getCards();
    setState(() {
      _cards = cards;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Change Card"), backgroundColor: Colors.blue),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _cards.isEmpty ? const Center(child: Text("No cards available")) : ListView(
        padding: const EdgeInsets.all(16.0),
        children: _cards.map((card) {
          return GestureDetector(
            onTap: () => Navigator.pop(context, card),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: true,
                    child: CreditCardWidget(
                      cardNumber: card.number,
                      expiryDate: card.expDate,
                      cardHolderName: card.ownerName,
                      cvvCode: card.cvv,
                      showBackView: false,
                      onCreditCardWidgetChange: (CreditCardBrand brand) {},
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
