import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/auth_bloc.dart';
import 'package:lockitem_movil/presentation/screens/account/login_screen.dart';
import 'package:lockitem_movil/presentation/screens/account/signup_screen.dart';
import 'package:lockitem_movil/presentation/screens/main_screen.dart';
import 'injection_container.dart' as di; // dependency injector
import 'injection_container.dart'; // Importa el sl

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario si usas async en main
  await di.init(); // Inicializa las dependencias
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LockItem App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: LoginScreen(), // <--- ELIMINA O COMENTA ESTO
        initialRoute: '/', // <--- Especifica la ruta inicial
        routes: {
          '/': (context) => LoginScreen(), // Tu pantalla de inicio
          '/signup': (context) => SignupScreen(), // Asegúrate de tener esta pantalla importada
          // '/main': (context) => MainScreen(), // Y esta también, si la usas
          // ... otras rutas
        },
      ),
    );
  }
}