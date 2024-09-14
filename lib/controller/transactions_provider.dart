import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:money_tracker/model/transaction.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionsProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionsJson = prefs.getString('transactions');
    if (transactionsJson != null) {
      final List<dynamic> decodedList = json.decode(transactionsJson);
      _transactions =
          decodedList.map((item) => Transaction.fromJson(item)).toList();
      _sortTransactions();
      notifyListeners();
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList =
        json.encode(_transactions.map((t) => t.toJson()).toList());
    await prefs.setString('transactions', encodedList);
  }

  void _sortTransactions() {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _saveTransactions();
    _sortTransactions();
    notifyListeners();
  }

  void removeTransaction(Transaction transaction) {
    _transactions.remove(transaction);
    _saveTransactions();
    notifyListeners();
  }

  double getBalance() {
    return _transactions.fold(0, (sum, item) => sum + item.amount);
  }

  double getTotalIncomes() {
    return _transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, item) => sum + item.amount);
  }

  double getTotalExpenses() {
    return _transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, item) => sum + item.amount.abs());
  }
}
