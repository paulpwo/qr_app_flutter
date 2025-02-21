import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_app/profile/presentation/profile_page.dart';
import '../bloc/qr_scanner_bloc.dart';
import '_pages/qr_page.dart';
import 'widgets/nav_item.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const QRsPage(),
    const ProfilePage(),
  ];

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'Mis QRs Escaneados';
      case 1:
        return 'Mi Perfil';
      default:
        return 'QR Scanner';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Implementar filtro de QRs
              },
            ),
          if (_selectedIndex == 1)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO: Implementar configuración
              },
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<QrScannerBloc>().add(QrScanned(''));
        },
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.primaryFixed,
        child: const Icon(Icons.qr_code_scanner, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 12,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<QrScannerBloc, QrScannerState>(
                builder: (context, state) {
                  String? badge;
                  if (state is QrScannerSuccess) {
                    badge = state.scannedCodes.length.toString();
                  }
                  return NavBarItem(
                    icon: Icons.qr_code,
                    label: 'Mis QRs',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                    badge: badge,
                  );
                },
              ),
              const SizedBox(width: 40),
              NavBarItem(
                icon: Icons.person,
                label: 'Mi Perfil',
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
