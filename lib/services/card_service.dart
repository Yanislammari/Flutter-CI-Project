import "package:ci_project/models/credit_card.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class CardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addCard(CreditCard card) async {
    try {
      User? user = _auth.currentUser;
      if(user == null) {
        return;
      }

      String userId = user.uid;

      await _firestore.collection("credit_cards").add({
        "number": card.number,
        "expDate": card.expDate,
        "ownerName": card.ownerName,
        "cvv": card.cvv,
        "sold": card.sold,
        "iban": card.iban,
        "userId": userId,
      });

    }
    catch(e) {
      print("Erreur in adding card : $e");
    }
  }

  Future<List<CreditCard>> getCards() async {
    try {
      User? user = _auth.currentUser;
      if(user == null) {
        return [];
      }

      String userId = user.uid;

      QuerySnapshot querySnapshot = await _firestore
          .collection('credit_cards')
          .where('userId', isEqualTo: userId)
          .get();

      List<CreditCard> cards = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CreditCard.fromMap(data, id: doc.id);
      }).toList();

      return cards;
    }
    catch(e) {
      return [];
    }
  }

  Future<CreditCard?> getCardByIban(String iban) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("credit_cards")
          .where("iban", isEqualTo: iban)
          .limit(1)
          .get();

      if(querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return CreditCard.fromMap(data, id: querySnapshot.docs.first.id);
      }
      else {
        return null;
      }
    }
    catch(e) {
      return null;
    }
  }

  Future<void> deleteCard(String cardId) async {
    try {
      await _firestore.collection("credit_cards").doc(cardId).delete();
    }
    catch (e) {
      print('Error in deleting card : $e');
    }
  }
}
