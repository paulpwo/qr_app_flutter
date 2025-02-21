import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_app/core/router/app_router.dart';
import 'package:qr_app/core/theme/app_theme.dart';
import 'package:qr_app/login/presentation/bloc/biometric_bloc.dart';
import 'package:qr_app/scanner/presentation/bloc/qr_scanner_bloc.dart';
import 'package:auth_biometric/auth_biometric.dart';
import 'package:qr_scanner/qr_scanner.dart';
import 'package:qr_app/core/presentation/bloc/theme_bloc.dart';
import 'package:qr_app/core/services/theme_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'scanner/domain/models/qr_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QrModelAdapter());
  await Hive.openBox<QrModel>(qrBoxName);
  final themeService = await ThemeStorageService.init();
  runApp(MyApp(themeService: themeService));
}

class MyApp extends StatelessWidget {
  final ThemeStorageService themeService;

  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ThemeBloc(themeService)..add(InitializeTheme())),
        BlocProvider(
          create: (context) => BiometricBloc(BiometricRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => QrScannerBloc(QrScannerRepositoryImpl()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QR Scanner',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRouter.initial,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
