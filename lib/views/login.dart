import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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

  @override
  Widget build(BuildContext context) {
    String _value;
    String _title;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Card(
            color: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    'Dindin Juntin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => {_title = value},
                    cursorColor: Colors.white,
                    decoration: customInputDecoration('E-mail'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) => {_value = value},
                    style: const TextStyle(color: Colors.white),
                    decoration: customInputDecoration('Senha'),
                    cursorColor: Colors.white,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: TextButton(
                      onPressed: () {Navigator.pushNamed(context, '/');},
                      child: Text('Login'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
