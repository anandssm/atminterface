class Account {
  final String accountNumber;
  String pin;
  double balance;
  final String accountHolder;

  Account({
    required this.accountNumber,
    required this.pin,
    required this.balance,
    required this.accountHolder,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'pin': pin,
      'balance': balance,
      'accountHolder': accountHolder,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountNumber: json['accountNumber'],
      pin: json['pin'],
      balance: json['balance']?.toDouble() ?? 0.0,
      accountHolder: json['accountHolder'],
    );
  }
}
