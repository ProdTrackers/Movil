import 'package:flutter/material.dart';
import 'package:lockitem_movil/screens/account/account_screen.dart';
import 'package:lockitem_movil/screens/home/home_screen.dart';
import 'package:lockitem_movil/screens/search/search_screen.dart';
import 'package:lockitem_movil/shared/widgets/bottom_navbar.dart';
import 'package:lockitem_movil/screens/saved/save_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // Índice del BottomNavBar

  // Lista de pantallas para cada índice del BottomNavBar
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    SaveScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Actualiza el índice seleccionado
          });
        },
      ),
    );
  }
}
