import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';

class DepositCheckScreen extends StatefulWidget {
  const DepositCheckScreen({super.key});

  @override
  State<DepositCheckScreen> createState() => _DepositCheckScreenState();
}

class _DepositCheckScreenState extends State<DepositCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _checkNumberController = TextEditingController();
  bool _isProcessing = false;

  Future<void> _depositCheck() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final success = await context.read<AtmProvider>().deposit(
          double.parse(_amountController.text),
        );

    if (!mounted) return;

    setState(() => _isProcessing = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Check #${_checkNumberController.text} for ₹${_amountController.text} deposited successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to deposit check. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              'Deposit Check',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter Check Details',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[700]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _checkNumberController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Check Number',
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
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter check number';
                                }
                                if (value.length < 4) {
                                  return 'Check number must be at least 4 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _amountController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Check Amount',
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter check amount';
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Important:\n1. Check must be signed\n2. Amount in words and numbers must match\n3. Date must be valid',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: _isProcessing ? null : _depositCheck,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Deposit Check',
                                style: TextStyle(fontSize: 18),
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
                  'Maximum check deposit: ₹10,000',
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
    _checkNumberController.dispose();
    super.dispose();
  }
}
