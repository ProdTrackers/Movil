import 'package:flutter/material.dart';
import 'package:lockitem_movil/presentation/screens/account/account_screen.dart';
import 'package:lockitem_movil/presentation/screens/home/store_list_screen.dart';
import 'package:lockitem_movil/presentation/screens/saved/save_screen.dart';
import 'package:lockitem_movil/presentation/screens/search/search_screen.dart';
import 'package:lockitem_movil/presentation/widgets/bottom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StoreListScreen(),
    const SearchScreen(),
    SaveScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
