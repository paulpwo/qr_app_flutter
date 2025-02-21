import 'package:mockito/annotations.dart';
import 'package:qr_secure_scanner/core/presentation/bloc/theme_bloc.dart';
import 'package:qr_secure_scanner/core/services/theme_storage_service.dart';
import 'package:qr_secure_scanner/core/services/secure_storage_service.dart';
import 'package:qr_secure_scanner/scanner/presentation/bloc/qr_scanner_bloc.dart';
import 'package:qr_secure_scanner/login/presentation/bloc/biometric_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  ThemeStorageService,
  SharedPreferences,
  QrScannerBloc,
  BiometricBloc,
  SecureStorageService,
  ThemeBloc,
])
void main() {}
