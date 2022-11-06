import 'package:dindin_juntin/views/homePage.dart';
import 'package:dindin_juntin/views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dindin_juntin/firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatelessWidget {
  final Future<FirebaseApp> _fbApp =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dindin Juntin',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        initialRoute: '/login',
        routes: {
          '/': (context) => HomePage(),
          '/login': (context) => const Login()
        });
  }
}
