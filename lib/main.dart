import 'package:dindin_juntin/models/saved_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dindin_juntin/views/home_page.dart';
import 'package:dindin_juntin/views/login.dart';
import 'package:dindin_juntin/views/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dindin_juntin/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dindin_juntin/variables.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp fbApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.authStateChanges().listen((event) {
    if (event != null) {
      Variables.userLogged = event;
      final FirebaseDatabase fbd = FirebaseDatabase.instance;
      fbd
          .ref('Users')
          .child(Variables.userLogged.uid)
          .onValue
          .listen((DatabaseEvent event) {
        Variables.savedUser = SavedUser.fromFirebase(event.snapshot);
      });
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
        initialRoute: Variables.userLogged is User ? '/' : '/login',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const Login(),
          '/sign-up': (context) => const SignUp(),
        });
  }
}
