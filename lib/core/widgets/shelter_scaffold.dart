import 'package:flutter/material.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';

/// Scaffold con BottomNavigationBar para refugios
class ShelterScaffold extends StatelessWidget {
  final Widget body;
  final String currentRoute;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  const ShelterScaffold({
    Key? key,
    required this.body,
    required this.currentRoute,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.appBar,
  }) : super(key: key);

  int _getSelectedIndex() {
    switch (currentRoute) {
      case AppRoutes.shelterHome:
        return 0;
      case AppRoutes.managePets:
        return 1;
      case AppRoutes.shelterRequests:
        return 2;
      case 'profile':
        return 3;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    String route = '';
    switch (index) {
      case 0:
        route = AppRoutes.shelterHome;
        break;
      case 1:
        route = AppRoutes.managePets;
        break;
      case 2:
        route = AppRoutes.shelterRequests;
        break;
      case 3:
        route = 'profile';
        break;
    }

    if (route != currentRoute && route.isNotEmpty) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ??
          (title != null
              ? AppBar(
                  title: Text(title!),
                  actions: actions,
                  automaticallyImplyLeading: false,
                )
              : null),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(),
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Mascotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
