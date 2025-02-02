import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/atm_provider.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: Row(
          children: [
            Image.asset(
              'assets/indian-bank.jpg',
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Mini Statement',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black54,
            child: Consumer<AtmProvider>(
              builder: (context, provider, _) {
                final account = provider.currentAccount;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Account: ${account?.accountNumber ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Balance: ₹${account?.balance.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1A237E),
                    Color(0xFF0D47A1),
                  ],
                ),
              ),
              child: Consumer<AtmProvider>(
                builder: (context, provider, _) {
                  final transactions = provider.transactions;

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        'No transactions yet',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return _TransactionCard(transaction: transaction);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.info_outline, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'Shows last 10 transactions',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isWithdrawal = transaction.type == TransactionType.withdrawal;
    final color = isWithdrawal ? Colors.red : Colors.green;
    final icon = isWithdrawal ? Icons.arrow_downward : Icons.arrow_upward;
    final typeText = isWithdrawal ? 'Withdrawal' : 'Deposit';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Row(
          children: [
            Text(
              typeText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Text(
              '₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        subtitle: Text(
          _formatDateTime(transaction.timestamp),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} $hour:$minute';
  }
}
