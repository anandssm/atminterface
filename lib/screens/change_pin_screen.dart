import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isChanging = false;
  bool _obscureCurrentPin = true;
  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;

  Future<void> _changePin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isChanging = true);

    final success = await context.read<AtmProvider>().changePin(
          _currentPinController.text,
          _newPinController.text,
        );

    if (!mounted) return;

    setState(() => _isChanging = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PIN changed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Current PIN is incorrect'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              'Change PIN',
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
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Change Your PIN',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: _currentPinController,
                              decoration: InputDecoration(
                                labelText: 'Current PIN',
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
                                prefixIcon: const Icon(Icons.lock_open,
                                    color: Colors.white70),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureCurrentPin
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureCurrentPin = !_obscureCurrentPin),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              obscureText: _obscureCurrentPin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your current PIN';
                                }
                                if (value.length != 4) {
                                  return 'PIN must be 4 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _newPinController,
                              decoration: InputDecoration(
                                labelText: 'New PIN',
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
                                prefixIcon: const Icon(Icons.lock,
                                    color: Colors.white70),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNewPin
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscureNewPin = !_obscureNewPin),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              obscureText: _obscureNewPin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new PIN';
                                }
                                if (value.length != 4) {
                                  return 'PIN must be 4 digits';
                                }
                                if (value == _currentPinController.text) {
                                  return 'New PIN must be different from current PIN';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPinController,
                              decoration: InputDecoration(
                                labelText: 'Confirm New PIN',
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
                                prefixIcon: const Icon(Icons.lock_clock,
                                    color: Colors.white70),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPin
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscureConfirmPin = !_obscureConfirmPin),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              obscureText: _obscureConfirmPin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your new PIN';
                                }
                                if (value != _newPinController.text) {
                                  return 'PINs do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: _isChanging ? null : _changePin,
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
                              child: _isChanging
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
                                      'Change PIN',
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
                  'Choose a PIN you haven\'t used before',
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
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}
