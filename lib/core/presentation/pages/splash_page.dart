import 'package:flutter/material.dart';
import 'package:qr_app/core/router/app_router.dart';
import 'package:qr_app/core/services/secure_storage_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final storageService = SecureStorageService();
    await Future.delayed(const Duration(seconds: 2));

    final isAuthenticated = await storageService.isAuthenticated();
    if (isAuthenticated) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRouter.scanner);
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'QR Scanner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
