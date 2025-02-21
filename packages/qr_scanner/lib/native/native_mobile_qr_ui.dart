import 'qr_scanner.g.dart';

final _api = NativeHostQr();

Future<String> getNativeUiResult() async {
  try {
    final r = await _api.getNativeUiResult();
    return r;
  } catch (e) {
    return 'Failed to retrieve result';
  }
}
