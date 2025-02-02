import 'package:ci_project/components/transaction_widget.dart';
import 'package:ci_project/models/transaction.dart';
import 'package:ci_project/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final TransactionService _transactionService = TransactionService();
  late User? _user;
  List<MoneyTransaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      List<MoneyTransaction> transactions = await _transactionService.getAllTransactions();

      setState(() {
        _transactions = transactions.where((transaction) {
          return transaction.senderId == _user?.uid || transaction.receiverId == _user?.uid;
        }).toList();
      });
    }
    catch(e) {
      print('Error fetching transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _transactions.isEmpty ? const Center(child: CircularProgressIndicator()) : ListView.builder(
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              MoneyTransaction transaction = _transactions[index];

              List<Widget> widgets = [];

              if(_user?.uid == transaction.senderId) {
                widgets.add(
                  TransactionWidget(
                    sender: _user!.email ?? "Unknown Sender",
                    receiver: transaction.receiverId,
                    sold: transaction.sold,
                    isGain: false,
                  ),
                );
              }
              if(_user?.uid == transaction.receiverId) {
                widgets.add(
                  TransactionWidget(
                    sender: transaction.senderId,
                    receiver: _user!.email ?? "Unknown Receiver",
                    sold: transaction.sold,
                    isGain: true,
                  ),
                );
              }
              return Column(
                children: widgets,
              );
            },
          ),
        ),
      ),
    );
  }
}
