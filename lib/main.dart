import 'package:firebase_auth/firebase_auth.dart';
import 'package:dindin_juntin/views/home_page.dart';
import 'package:dindin_juntin/views/login.dart';
import 'package:dindin_juntin/views/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dindin_juntin/firebase_options.dart';
import 'package:flutter/material.dart';

var userLogged;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp fbApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.authStateChanges().listen((event) {
    if (event != null) {
      userLogged = event;
    }
  });
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dindin Juntin',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        // initialRoute: '/sign-up',
        initialRoute: userLogged is User ? '/' : '/login',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const Login(),
          '/sign-up': (context) => const SignUp(),
        });
  }
}
