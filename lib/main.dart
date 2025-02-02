import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/atm_provider.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (_) => AtmProvider(prefs),
      child: const AtmApp(),
    ),
  );
}

class AtmApp extends StatelessWidget {
  const AtmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM Interface',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
