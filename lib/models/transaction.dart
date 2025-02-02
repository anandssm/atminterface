enum TransactionType { withdrawal, deposit }

class Transaction {
  final String id;
  final String accountNumber;
  final double amount;
  final TransactionType type;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.accountNumber,
    required this.amount,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountNumber': accountNumber,
      'amount': amount,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      accountNumber: json['accountNumber'],
      amount: json['amount']?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.withdrawal,
      ),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
