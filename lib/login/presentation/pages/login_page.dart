import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_app/core/router/app_router.dart';
import '../bloc/biometric_bloc.dart';

extension BiometricContextX on BuildContext {
  void authenticateWithBiometric() {
    read<BiometricBloc>().add(BiometricCheckAvailabe());
  }

  void showCodeBottomSheet() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ingresa tu código de acceso',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Por favor, introduce el código de 6 dígitos',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '123456',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  read<BiometricBloc>()
                      .add(BiometricCheckCode(controller.text));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Verificar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key});

  @override
  State<BiometricPage> createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  @override
  void initState() {
    super.initState();
    // Ya no necesitamos hacer el check aquí porque se hace en main
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<BiometricBloc>().add(BiometricCheckStoredAuth());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<BiometricBloc, BiometricState>(
          listener: (context, state) {
            if (state is BiometricSuccess && state.shouldRedirect) {
              AppRouter.navigateToScanner(context);
            }
          },
          child: BlocBuilder<BiometricBloc, BiometricState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.qr_code,
                      size: 100,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'QR Scanner Security',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    if (state is BiometricLoading)
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Verificando...'),
                          ],
                        ),
                      )
                    else if (state is BiometricSuccess)
                      Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 55,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '¡Autenticación exitosa!',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (!state.shouldRedirect)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      AppRouter.navigateToScanner(context),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child:
                                      const Text('Empezar a escanear QRs 🚀'),
                                ),
                              ),
                          ],
                        ),
                      )
                    else if (state is BiometricError)
                      Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.authenticateWithBiometric(),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Reintentar'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () => context.showCodeBottomSheet(),
                            icon: const Icon(Icons.lock_outline),
                            label: const Text('Usar código de acceso'),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => context.authenticateWithBiometric(),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.fingerprint),
                          label: const Text(
                            'Autenticar con biometría',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
