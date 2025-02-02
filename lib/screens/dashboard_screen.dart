import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/atm_provider.dart';
import 'deposit_check_screen.dart';
import 'deposit_screen.dart';
import 'withdraw_screen.dart';
import 'transaction_history_screen.dart';
import 'generate_pin_screen.dart';
import 'change_pin_screen.dart';
import 'transfer_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _handleOptionSelected(BuildContext context, String option) {
    final provider = context.read<AtmProvider>();
    if (!provider.isLoggedIn && option != 'Generate PIN') {
      _showLoginDialog(context);
      return;
    }

    switch (option) {
      case 'Deposit Check':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DepositCheckScreen()),
        );
        break;
      case 'Withdraw Cash':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WithdrawScreen()),
        );
        break;
      case 'Deposit Cash':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DepositScreen()),
        );
        break;
      case 'Check Balance':
        if (provider.currentAccount != null) {
          _showBalanceDialog(context, provider.currentAccount!.balance);
        }
        break;
      case 'Mini Statement':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
        );
        break;
      case 'Transfer Funds':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransferScreen()),
        );
        break;
      case 'Change PIN':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePinScreen()),
        );
        break;
      case 'Generate PIN':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GeneratePinScreen()),
        );
        break;
    }
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoginDialog(),
    );
  }

  void _showBalanceDialog(BuildContext context, double balance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Current Balance',
            style: TextStyle(color: Colors.white)),
        content: Text(
          '₹${balance.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AtmProvider, bool>(
      (provider) => provider.isLoggedIn,
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
              'Indian Bank ATM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                context.read<AtmProvider>().logout();
              },
            ),
        ],
      ),
      body: Container(
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
        child: Column(
          children: [
            if (isLoggedIn) ...[
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black54,
                child: Consumer<AtmProvider>(
                  builder: (context, provider, _) {
                    final account = provider.currentAccount;
                    return Column(
                      children: [
                        Text(
                          'Welcome, ${account?.accountHolder}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Card: ${account?.accountNumber.substring(5)}',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/bank.gif",
                        height: 300,
                        width: 600,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Please Select Your Transaction',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      constraints: const BoxConstraints(
                          maxWidth: 600), // Controls max width
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ATMButton(
                                  label: 'Deposit Check',
                                  icon: Icons.library_books,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Deposit Check'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ATMButton(
                                  label: 'Generate PIN',
                                  icon: Icons.pin_invoke,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Generate PIN'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ATMButton(
                                  label: 'Withdraw Cash',
                                  icon: Icons.arrow_downward,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Withdraw Cash'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ATMButton(
                                  label: 'Deposit Cash',
                                  icon: Icons.arrow_upward,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Deposit Cash'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ATMButton(
                                  label: 'Check Balance',
                                  icon: Icons.account_balance_wallet,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Check Balance'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ATMButton(
                                  label: 'Mini Statement',
                                  icon: Icons.receipt_long,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Mini Statement'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ATMButton(
                                  label: 'Transfer Funds',
                                  icon: Icons.swap_horiz,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Transfer Funds'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ATMButton(
                                  label: 'Change PIN',
                                  icon: Icons.lock,
                                  onPressed: () => _handleOptionSelected(
                                      context, 'Change PIN'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/npci.jpg',
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Secured by NPCI',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ATMButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ATMButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A237E),
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginDialog extends StatefulWidget {
  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await context.read<AtmProvider>().login(
          _accountController.text,
          _pinController.text,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid account number or PIN'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A237E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 450, // Fixed width for the dialog
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'INDIAN BANK LOGIN',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 450, // Fixed width for input fields
                child: TextFormField(
                  controller: _accountController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    prefixIcon: const Icon(Icons.account_balance,
                        color: Colors.white70),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 450, // Fixed width for input fields
                child: TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PIN';
                    }
                    if (value.length != 4) {
                      return 'PIN must be 4 digits';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Demo Account: 123456789 | Demo PIN: 1234',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
