import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/auth_bloc.dart';
import 'package:lockitem_movil/presentation/bloc/favorite_bloc.dart';
import 'package:lockitem_movil/presentation/screens/account/login_screen.dart';
import 'package:lockitem_movil/presentation/screens/account/signup_screen.dart';
import 'package:lockitem_movil/presentation/screens/main_screen.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              di.sl<AuthBloc>(),
        ),
        BlocProvider<FavoriteBloc>(
          create: (_) =>
          di.sl<FavoriteBloc>()
            ..add(LoadFavoriteItems()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LockItem App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}