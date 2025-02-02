import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isProcessing = false;
  final _standardAmounts = [100, 500, 1000, 5000];

  Future<void> _transfer(double amount) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final success = await context.read<AtmProvider>().transfer(
          _accountNumberController.text,
          amount,
        );

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Successfully transferred ₹${amount.toStringAsFixed(2)} to ${_accountNumberController.text}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transfer failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCustomAmount() async {
    if (!_formKey.currentState!.validate()) return;
    await _transfer(double.parse(_amountController.text));
  }

  @override
  Widget build(BuildContext context) {
    final currentBalance = context.select<AtmProvider, double>(
      (provider) => provider.currentAccount?.balance ?? 0,
    );

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
              'Transfer Funds',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Balance:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '₹${currentBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
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
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _accountNumberController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'To Account Number',
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: const Icon(Icons.account_balance,
                                  color: Colors.white70),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter recipient account number';
                              }
                              if (value.length < 8) {
                                return 'Account number must be at least 8 digits';
                              }
                              final currentAccount =
                                  context.read<AtmProvider>().currentAccount;
                              if (value == currentAccount?.accountNumber) {
                                return 'Cannot transfer to your own account';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Select Amount',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 2,
                            children: _standardAmounts.map((amount) {
                              final isDisabled =
                                  _isProcessing || amount > currentBalance;
                              return ElevatedButton(
                                onPressed: isDisabled
                                    ? null
                                    : () => _transfer(amount.toDouble()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1A237E),
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  disabledBackgroundColor:
                                      Colors.white.withOpacity(0.3),
                                ),
                                child: Text(
                                  '₹$amount',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Other Amount',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _amountController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Enter Amount',
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              prefixText: '₹',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.amber),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: const Icon(Icons.attach_money,
                                  color: Colors.white70),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              final amount = double.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
                              }
                              if (amount > currentBalance) {
                                return 'Insufficient funds';
                              }
                              if (amount > 10000) {
                                return 'Maximum transfer amount is ₹10,000';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed:
                                _isProcessing ? null : _handleCustomAmount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black54),
                                    ),
                                  )
                                : const Text(
                                    'Transfer',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                  'Maximum transfer amount: ₹10,000',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
