import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/native/qr_scanner.g.dart',
  kotlinOut:
      'android/src/main/kotlin/dev/flutter/qr_scanner/NativeMobileQr.g.kt',
  kotlinOptions: KotlinOptions(
    package: "dev.flutter.qr_scanner",
  ),
  dartPackageName: 'qr_scanner',
))
@HostApi()
abstract class NativeHostQr {
  @async
  String getNativeUiResult();
}
