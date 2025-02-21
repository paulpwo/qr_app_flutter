import 'package:flutter/material.dart';
import 'package:qr_secure_scanner/core/router/app_router.dart';
import 'package:qr_secure_scanner/core/services/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_secure_scanner/core/presentation/bloc/theme_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Usuario',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListView(
            shrinkWrap: true,
            children: [
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return SwitchListTile(
                    secondary: Icon(
                      state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: const Text('Tema oscuro'),
                    value: state.isDarkMode,
                    onChanged: (_) =>
                        context.read<ThemeBloc>().add(ToggleTheme()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Términos y Condiciones'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navegar a Términos y Condiciones
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Políticas de Privacidad'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navegar a Políticas de Privacidad
                },
              ),
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Versión de la aplicación'),
                trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  final storage = SecureStorageService();
                  await storage.clearAuthentication();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
