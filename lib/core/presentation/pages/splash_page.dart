import 'package:flutter/material.dart';
import 'package:qr_secure_scanner/core/router/app_router.dart';
import 'package:qr_secure_scanner/core/services/secure_storage_service.dart';

class SplashPage extends StatefulWidget {
  final SecureStorageService? storageService;
  final Duration splashDuration;

  const SplashPage({
    super.key,
    this.storageService,
    this.splashDuration = const Duration(seconds: 2),
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SecureStorageService _storageService;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? SecureStorageService();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(widget.splashDuration);
    if (!mounted) return;

    final isAuthenticated = await _storageService.isAuthenticated();
    if (!mounted) return;

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRouter.scanner);
    } else {
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
