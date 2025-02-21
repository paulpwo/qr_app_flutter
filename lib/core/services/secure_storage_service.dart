import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _authKey = 'is_authenticated';
  final FlutterSecureStorage _storage;

  SecureStorageService() : _storage = const FlutterSecureStorage();

  Future<void> saveAuthenticationStatus(bool isAuthenticated) async {
    await _storage.write(key: _authKey, value: isAuthenticated.toString());
  }

  Future<bool> isAuthenticated() async {
    final value = await _storage.read(key: _authKey);
    return value == 'true';
  }

  Future<void> clearAuthentication() async {
    await _storage.delete(key: _authKey);
  }
}
