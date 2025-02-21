import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/native/auth_biometric.g.dart',
  kotlinOut:
      'android/src/main/kotlin/dev/flutter/auth_biometric/NativeMobileAuthBiometric.g.kt',
  kotlinOptions: KotlinOptions(
    package: "dev.flutter.auth_biometric",
  ),
  dartPackageName: 'auth_biometric',
))
@HostApi()
abstract class NativeMobileAuthBiometricHost {
  @async
  bool isAvailable();
}
