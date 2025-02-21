import 'package:qr_scanner/native/native_mobile_qr_ui.dart';

class QrScannerRepositoryImpl {
  Future<String> getResult() async {
    try {
      return await getNativeUiResult();
    } catch (e) {
      return 'Failed to retrieve result';
    }
  }
}
