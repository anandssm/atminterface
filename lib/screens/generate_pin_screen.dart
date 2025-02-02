import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class GeneratePinScreen extends StatefulWidget {
  const GeneratePinScreen({super.key});

  @override
  State<GeneratePinScreen> createState() => _GeneratePinScreenState();
}

class _GeneratePinScreenState extends State<GeneratePinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  String? _generatedPin;
  bool _isGenerating = false;

  void _generatePin() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isGenerating = true);

    // Simulate PIN generation delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      // Generate a random 4-digit PIN
      final random = Random();
      final pin = List.generate(4, (_) => random.nextInt(10)).join();

      setState(() {
        _generatedPin = pin;
        _isGenerating = false;
      });
    });
  }

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
              'Generate PIN',
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
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Generate New PIN',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _accountNumberController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Account Number',
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
                                    return 'Please enter your account number';
                                  }
                                  if (value.length < 8) {
                                    return 'Account number must be at least 8 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _isGenerating ? null : _generatePin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isGenerating
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.black54),
                                        ),
                                      )
                                    : const Text(
                                        'Generate PIN',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        if (_generatedPin != null) ...[
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Your New PIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _generatedPin!,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 12,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Please memorize this PIN and keep it secure.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
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
                Icon(Icons.security, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'Your PIN is your security key',
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
    super.dispose();
  }
}
