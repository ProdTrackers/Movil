import 'package:flutter/material.dart';
import 'package:lockitem_movil/screens/account/login_screen.dart';
import 'package:lockitem_movil/screens/account/signup_screen.dart';
import 'package:lockitem_movil/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LockItem App',
      initialRoute: '/home',
      routes: {
        //'/login': (context) => const LoginScreen(),
        //'/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
