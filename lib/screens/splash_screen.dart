import 'package:flutter/material.dart';
import '../../services/storage_service.dart';
import 'auth/login_screen.dart';
import '../main.dart'; // For OnboardingScreen / MeasurementInputScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Add a slight delay for aesthetic splash
    await Future.delayed(const Duration(seconds: 1));
    final email = await StorageService.getCurrentUserEmail();
    if (!mounted) return;

    if (email != null) {
      // Already logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MeasurementInputScreen()),
      );
    } else {
      // Needs to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1a0b2e),
      body: Center(
        child: Icon(Icons.auto_awesome, size: 80, color: Color(0xFFD4A396)),
      ),
    );
  }
}
