import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_secure_scanner/core/presentation/bloc/theme_bloc.dart';
import 'package:qr_secure_scanner/login/presentation/bloc/biometric_bloc.dart';
import 'package:qr_secure_scanner/main.dart';
import 'package:qr_secure_scanner/scanner/presentation/bloc/qr_scanner_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mocks.mocks.dart';

void main() {
  late MockThemeStorageService mockThemeService;
  late MockQrScannerBloc mockQrScannerBloc;
  late MockBiometricBloc mockBiometricBloc;
  late MockSecureStorageService mockSecureStorageService;
  late MockThemeBloc mockThemeBloc;

  setUp(() {
    mockThemeService = MockThemeStorageService();
    mockQrScannerBloc = MockQrScannerBloc();
    mockBiometricBloc = MockBiometricBloc();
    mockSecureStorageService = MockSecureStorageService();
    mockThemeBloc = MockThemeBloc();
  });

  testWidgets('App initializes with light theme', (WidgetTester tester) async {
    when(mockThemeService.getDarkMode()).thenReturn(false);
    when(mockThemeService.isFirstTime()).thenReturn(true);
    when(mockThemeService.setDarkMode(any)).thenAnswer((_) => Future.value());
    when(mockSecureStorageService.isAuthenticated())
        .thenAnswer((_) => Future.value(false));
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<QrScannerBloc>.value(value: mockQrScannerBloc),
          BlocProvider<BiometricBloc>.value(value: mockBiometricBloc),
        ],
        child: MyApp(themeService: mockThemeService),
      ),
    );

    await tester.pump();

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));

    verify(mockThemeService.getDarkMode()).called(1);
    expect(Theme.of(tester.element(find.byType(MaterialApp))).brightness,
        equals(Brightness.light));
  });

  testWidgets('App initializes with dark theme', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'is_first_time': false,
      'is_dark_mode': true,
    });

    when(mockThemeService.getDarkMode()).thenReturn(true);
    when(mockThemeService.isFirstTime()).thenReturn(false);
    when(mockThemeService.setDarkMode(any)).thenAnswer((_) => Future.value());
    when(mockSecureStorageService.isAuthenticated())
        .thenAnswer((_) => Future.value(false));
    when(mockThemeBloc.state).thenReturn(const ThemeState(isDarkMode: true));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<QrScannerBloc>.value(value: mockQrScannerBloc),
          BlocProvider<BiometricBloc>.value(value: mockBiometricBloc),
        ],
        child: MyApp(themeService: mockThemeService),
      ),
    );

    await tester.pump();

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 2));

    verify(mockThemeService.getDarkMode()).called(2);
  });
}
