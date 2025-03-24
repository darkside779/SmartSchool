import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/payment.dart';
import '../../models/receipt.dart';
import '../../providers/parent_provider.dart';
import 'package:intl/intl.dart';

class PaymentReceiptsScreen extends StatelessWidget {
  final int studentId;
  final String studentName;

  const PaymentReceiptsScreen({
    Key? key,
    required this.studentId,
    required this.studentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(studentName),
            Text(
              'Payment Receipts',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: context.read<ParentProvider>().getChildPayments(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading payments: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ParentProvider>().getChildPayments(studentId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final payments = snapshot.data as List<Payment>;
          
          if (payments.isEmpty) {
            return const Center(
              child: Text('No payment records found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final hasReceipts = payment.receipts != null && payment.receipts!.isNotEmpty;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(payment.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: \$${payment.amount.toStringAsFixed(2)}'),
                      Text('Reference: ${payment.refNo}'),
                      Text('Method: ${payment.method}'),
                      Text('Academic Year: ${payment.year}'),
                      if (payment.description != null)
                        Text('Description: ${payment.description}'),
                      Text(
                        'Balance: \$${payment.balance.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: payment.isPaid ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Paid: \$${payment.totalPaid.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  children: [
                    if (hasReceipts)
                      ...payment.receipts!.map((receipt) => _buildReceiptTile(receipt))
                    else
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No receipts available'),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildReceiptTile(Receipt receipt) {
    return ListTile(
      title: Text('Payment of \$${receipt.amountPaid.toStringAsFixed(2)}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance after payment: \$${receipt.balance.toStringAsFixed(2)}'),
          Text('Year: ${receipt.year}'),
          if (receipt.createdAt != null)
            Text('Date: ${DateFormat('MMM dd, yyyy').format(receipt.createdAt!)}'),
        ],
      ),
    );
  }
}
