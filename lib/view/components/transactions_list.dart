import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transactions_provider.dart';
import 'package:money_tracker/model/transaction.dart';
import 'package:money_tracker/view/components/transaction_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final transactionsProvider = Provider.of<TransactionsProvider>(context);
    final transactions = transactionsProvider.transactions;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final type = transaction.type == TransactionType.income
                  ? 'Income'
                  : 'Expense';
              final value = transaction.type == TransactionType.expense
                  ? '-\$ ${transaction.amount.abs().toStringAsFixed(2)}'
                  : '\$ ${transaction.amount.toStringAsFixed(2)}';
              final color = transaction.type == TransactionType.expense
                  ? Colors.red
                  : Colors.teal;
              final dateFormatted =
                  DateFormat('dd/MM/yyyy').format(transaction.date);

              return Dismissible(
                key: Key(transaction.hashCode.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  transactionsProvider.removeTransaction(transaction);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${transaction.description} removed')),
                  );
                },
                child: ListTile(
                  leading: transaction.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(transaction.imagePath!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  title: Text(transaction.description),
                  subtitle: Text('$type - $dateFormatted'),
                  trailing: Text(
                    value,
                    style: TextStyle(fontSize: 14, color: color),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TransactionDetailScreen(transaction: transaction),
                      ),
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
