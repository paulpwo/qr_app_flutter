import 'package:auth_biometric/native/auth_biometric.g.dart';

final _api = NativeMobileAuthBiometricHost();

class BiometricRepositoryImpl {
  Future<bool> getResult() async {
    try {
      return await _api.isAvailable();
    } catch (e) {
      return false;
    }
  }
}
