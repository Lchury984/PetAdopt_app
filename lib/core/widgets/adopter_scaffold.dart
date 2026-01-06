import 'package:flutter/material.dart';
import 'package:petadopt_prueba2_app/core/constants/app_routes.dart';

/// Scaffold con BottomNavigationBar para adoptantes
class AdopterScaffold extends StatelessWidget {
  final Widget body;
  final String currentRoute;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  const AdopterScaffold({
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
      case AppRoutes.adopterHome:
        return 0;
      case AppRoutes.map:
        return 1;
      case 'chat':
      case AppRoutes.chatAi:
        return 2;
      case AppRoutes.adoptionRequests:
        return 3;
      case 'profile':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    String route = '';
    switch (index) {
      case 0:
        route = AppRoutes.adopterHome;
        break;
      case 1:
        route = AppRoutes.map;
        break;
      case 2:
        route = 'chat';
        break;
      case 3:
        route = AppRoutes.adoptionRequests;
        break;
      case 4:
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
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat IA',
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
