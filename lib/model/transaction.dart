import 'package:flutter/foundation.dart';

enum TransactionType { income, expense }

class Transaction {
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final String? imagePath; // New property for storing the image path

  Transaction({
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    this.imagePath, // Optional image path
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      type: TransactionType.values[json['type']],
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }
}
