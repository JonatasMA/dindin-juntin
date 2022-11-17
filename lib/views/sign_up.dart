import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/saved_user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  InputDecoration customInputDecoration(label) {
    return InputDecoration(
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white));
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    String email = '';
    String pass = '';
    bool guest;
    String code = '';

    void saveUserData() {
      DatabaseReference users =
          FirebaseDatabase.instance.ref('Users').child(email);
      SavedUser savedUser = SavedUser(email: email, local: code);
      users.set(savedUser.toJson());
    }

    void signInUser() async {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
      saveUserData();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((value) {
        final user = value.user;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Bem vindo!'), backgroundColor: Colors.greenAccent));
        Navigator.pushReplacementNamed(context, '/');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Falha no login!'),
            backgroundColor: Colors.redAccent));
      });
    }

    void appendNewUser() async {
      'uiui';
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Colors.white;
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => {email = value},
              cursorColor: Colors.white,
              decoration: customInputDecoration('E-mail'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextFormField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (value) => {pass = value},
              style: const TextStyle(color: Colors.white),
              decoration: customInputDecoration('Senha'),
              cursorColor: Colors.white,
            ),
          ),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.blue,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      isChecked = value;
                    } else {
                      isChecked = false;
                    }
                    isChecked = value!;
                  });
                },
              ),
              const Text('Foi convidado?', style: TextStyle(color: Colors.white))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: TextFormField(
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (value) => {code = value},
              style: const TextStyle(color: Colors.white),
              decoration: customInputDecoration(
                  isChecked ? 'Código de convite' : 'Código de convidado'),
              cursorColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextButton(
                onPressed: () {
                  signInUser();
                  appendNewUser();
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: const Text('Cadastrar')),
          ),
        ],
      ),
    );
  }
}
