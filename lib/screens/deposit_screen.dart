import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _isProcessing = false;
  final _standardAmounts = [20, 50, 100, 200, 500, 1000];

  Future<void> _deposit(double amount) async {
    setState(() => _isProcessing = true);

    final success = await context.read<AtmProvider>().deposit(amount);

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully deposited ₹${amount.toStringAsFixed(2)}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to deposit money'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCustomAmount() async {
    if (!_formKey.currentState!.validate()) return;
    await _deposit(double.parse(_amountController.text));
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
              'Deposit Cash',
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
                  'Current Balance:',
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Select Deposit Amount',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: _standardAmounts.map((amount) {
                          return SizedBox(
                            width: 150,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _isProcessing
                                  ? null
                                  : () => _deposit(amount.toDouble()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                '₹$amount',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Other Amount',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _amountController,
                              decoration: InputDecoration(
                                labelText: 'Enter Amount',
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
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.attach_money,
                                    color: Colors.white70),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                                if (amount > 10000) {
                                  return 'Maximum deposit amount is ₹10,000';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed:
                                  _isProcessing ? null : _handleCustomAmount,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: _isProcessing
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Deposit Custom Amount',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  'Maximum deposit amount: ₹10,000',
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
    _amountController.dispose();
    super.dispose();
  }
}
