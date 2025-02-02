import "package:flutter/material.dart";
import "package:flutter_credit_card/flutter_credit_card.dart";
import "package:ci_project/models/credit_card.dart";
import "package:ci_project/services/card_service.dart";

class DeleteCardScreen extends StatefulWidget {
  final CreditCard? currentCard;

  const DeleteCardScreen({
    super.key,
    required this.currentCard,
  });

  @override
  _DeleteCardScreenState createState() => _DeleteCardScreenState();
}

class _DeleteCardScreenState extends State<DeleteCardScreen> {
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

  void _confirmDeleteCard(CreditCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this card? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () async {
              await _cardService.deleteCard(card.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("Yes, delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Card"), backgroundColor: Colors.blue),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _cards.isEmpty ? const Center(child: Text("No cards available")) : ListView(
        padding: const EdgeInsets.all(16.0),
        children: _cards.map((card) {
          return GestureDetector(
            onTap: () {
              if (widget.currentCard != null && widget.currentCard!.id == card.id) {
                _showErrorDialog("You cannot delete the currently selected card.");
              } else {
                _confirmDeleteCard(card);
              }
            },
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
              child: AbsorbPointer(
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
            ),
          );
        }).toList(),
      ),
    );
  }
}
