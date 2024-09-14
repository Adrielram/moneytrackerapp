import 'dart:io';
import 'package:flutter/material.dart';
import 'package:money_tracker/model/transaction.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type =
        transaction.type == TransactionType.income ? 'Income' : 'Expense';
    final value = transaction.type == TransactionType.expense
        ? '-\$ ${transaction.amount.abs().toStringAsFixed(2)}'
        : '\$ ${transaction.amount.toStringAsFixed(2)}';
    final color =
        transaction.type == TransactionType.expense ? Colors.red : Colors.teal;
    final dateFormatted =
        DateFormat('dd/MM/yyyy HH:mm').format(transaction.date);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (transaction.imagePath != null)
              _buildImage(transaction.imagePath!),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: color),
                  ),
                  SizedBox(height: 8),
                  Text('Type: $type'),
                  SizedBox(height: 8),
                  Text('Date: $dateFormatted'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return FutureBuilder<bool>(
      future: File(imagePath).exists(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return GestureDetector(
              onTap: () => _showFullScreenImage(context, imagePath),
              child: Hero(
                tag: 'transactionImage',
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  height: 300,
                  width: double.infinity,
                ),
              ),
            );
          } else {
            print('Image file does not exist: $imagePath');
            return Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[300],
              child: Icon(Icons.image_not_supported),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: Hero(
                    tag: 'transactionImage',
                    child: InteractiveViewer(
                      panEnabled: true,
                      boundaryMargin: EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 4,
                      child: Image.file(File(imagePath)),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
      fullscreenDialog: true,
    ));
  }
}
