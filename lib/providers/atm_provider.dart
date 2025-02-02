import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class AtmProvider with ChangeNotifier {
  Account? _currentAccount;
  List<Transaction> _transactions = [];
  final SharedPreferences _prefs;

  AtmProvider(this._prefs) {
    _loadDemoData();
  }

  Account? get currentAccount => _currentAccount;
  List<Transaction> get transactions => _transactions;
  bool get isLoggedIn => _currentAccount != null;

  void _loadDemoData() {
    // Demo account data
    if (_prefs.getString('demoAccount') == null) {
      final demoAccount = Account(
        accountNumber: '123456789',
        pin: '1234',
        balance: 10000.0,
        accountHolder: 'Chandan Pathak',
      );
      _prefs.setString('demoAccount', jsonEncode(demoAccount.toJson()));
    }
  }

  Future<bool> login(String accountNumber, String pin) async {
    final savedAccountJson = _prefs.getString('demoAccount');
    if (savedAccountJson != null) {
      final savedAccount = Account.fromJson(jsonDecode(savedAccountJson));
      if (savedAccount.accountNumber == accountNumber &&
          savedAccount.pin == pin) {
        _currentAccount = savedAccount;
        _loadTransactions();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void logout() {
    _currentAccount = null;
    _transactions = [];
    notifyListeners();
  }

  Future<bool> withdraw(double amount) async {
    if (_currentAccount == null || _currentAccount!.balance < amount) {
      return false;
    }

    _currentAccount!.balance -= amount;
    await _prefs.setString(
        'demoAccount', jsonEncode(_currentAccount!.toJson()));

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      accountNumber: _currentAccount!.accountNumber,
      amount: amount,
      type: TransactionType.withdrawal,
      timestamp: DateTime.now(),
    );

    _transactions.insert(0, transaction);
    _saveTransactions();
    notifyListeners();
    return true;
  }

  Future<bool> changePin(String currentPin, String newPin) async {
    if (_currentAccount == null) return false;
    if (_currentAccount!.pin != currentPin) return false;

    _currentAccount!.pin = newPin;
    await _prefs.setString(
        'demoAccount', jsonEncode(_currentAccount!.toJson()));
    notifyListeners();
    return true;
  }

  Future<bool> transfer(String toAccountNumber, double amount) async {
    if (_currentAccount == null) return false;
    if (_currentAccount!.accountNumber == toAccountNumber) return false;
    if (_currentAccount!.balance < amount) return false;

    // For demo purposes, we'll just deduct from current account
    _currentAccount!.balance -= amount;
    await _prefs.setString(
        'demoAccount', jsonEncode(_currentAccount!.toJson()));

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      accountNumber: toAccountNumber,
      amount: amount,
      type: TransactionType.withdrawal,
      timestamp: DateTime.now(),
    );

    _transactions.insert(0, transaction);
    _saveTransactions();
    notifyListeners();
    return true;
  }

  Future<bool> deposit(double amount) async {
    if (_currentAccount == null) return false;

    _currentAccount!.balance += amount;
    await _prefs.setString(
        'demoAccount', jsonEncode(_currentAccount!.toJson()));

    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      accountNumber: _currentAccount!.accountNumber,
      amount: amount,
      type: TransactionType.deposit,
      timestamp: DateTime.now(),
    );

    _transactions.insert(0, transaction);
    _saveTransactions();
    notifyListeners();
    return true;
  }

  void _loadTransactions() {
    final transactionsJson = _prefs
            .getStringList('transactions_${_currentAccount!.accountNumber}') ??
        [];
    _transactions = transactionsJson
        .map((json) => Transaction.fromJson(jsonDecode(json)))
        .toList();
  }

  void _saveTransactions() {
    if (_currentAccount == null) return;
    final transactionsJson = _transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    _prefs.setStringList(
        'transactions_${_currentAccount!.accountNumber}', transactionsJson);
  }
}
