import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/presentation/screens/account/account_screen.dart';
import 'package:lockitem_movil/presentation/screens/home/store_list_screen.dart';
import 'package:lockitem_movil/presentation/screens/saved/save_screen.dart';
import 'package:lockitem_movil/presentation/screens/search/search_screen.dart';
import 'package:lockitem_movil/presentation/widgets/bottom_navbar.dart';

import '../../injection_container.dart' as di;
import '../bloc/favorite_bloc.dart';


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
    const SaveScreen(),
    const AccountScreen(),
  ];

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  /*
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(LoadFavoriteItems());
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
