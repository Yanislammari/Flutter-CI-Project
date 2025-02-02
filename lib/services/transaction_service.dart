import "package:ci_project/models/credit_card.dart";
import "package:ci_project/models/transaction.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "card_service.dart";

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CardService _cardService = CardService();

  Future<void> addTransaction(String iban, double amount, CreditCard senderCard) async {
    try {
      User? user = _auth.currentUser;
      if(user == null) {
        throw Exception("User not logged in");
      }

      if(senderCard.sold < amount) {
        throw Exception("Insufficient funds for the transaction");
      }

      CreditCard? receiverCard = await _cardService.getCardByIban(iban);
      if(receiverCard == null) {
        throw Exception("No card found for this IBAN");
      }

      double newReceiverSold = receiverCard.sold + amount;
      await _firestore.collection("credit_cards").doc(receiverCard.id).update({
        "sold": newReceiverSold,
      });

      double newSenderSold = senderCard.sold - amount;
      await _firestore.collection("credit_cards").doc(senderCard.id).update({
        "sold": newSenderSold,
      });

      MoneyTransaction transaction = MoneyTransaction(
        senderId: senderCard.userId,
        receiverId: receiverCard.userId,
        sold: amount,
      );

      await _firestore.collection("transactions").add(transaction.toMap());
    }
    catch(e) {
      throw Exception("Error processing transaction: ${e.toString()}");
    }
  }

  Future<List<MoneyTransaction>> getAllTransactions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("transactions").get();
      
      List<MoneyTransaction> transactions = snapshot.docs.map((doc) {
        return MoneyTransaction.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return transactions;
    }
    catch(e) {
      throw Exception("Error retrieving transactions: ${e.toString()}");
    }
  }
}
