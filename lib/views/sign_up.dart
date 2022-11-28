import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import '../variables.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String pass = '';
  bool guest = false;
  bool loading = false;
  File? photo;
  String? photoName;

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  String code = '';

  InputDecoration customInputDecoration(label) {
    return InputDecoration(
        border: const UnderlineInputBorder(),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue));
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    if (!isChecked) {
      Variables.savedUser.local = generateRandomString(5);
    }

    Future saveUserData(uid) async {
      DatabaseReference users =
          FirebaseDatabase.instance.ref('Users').child(uid);
      Variables.savedUser.uid = uid;
      var photoURL = '';
      if (photo != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final imagesRef = storageRef.child("files/$uid/$photoName");
        await imagesRef.putFile(photo!);
        photoURL = await imagesRef.getDownloadURL();
        Variables.savedUser.photoURL = photoURL;
      }

      FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event != null) {
          Variables.userLogged = event;
          if (photoURL != '') {
            Variables.userLogged.updatePhotoURL(photoURL);
          }
          Variables.userLogged.updateDisplayName(Variables.savedUser.name);
        }
      });
      return users.set(Variables.savedUser.toJson());
    }

    void signInUser() async {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Variables.savedUser.email!, password: pass);
      await saveUserData(userCredential.user?.uid);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: Variables.savedUser.email!, password: pass)
          .then((value) {
        final user = value.user;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Bem vindo!'), backgroundColor: Colors.greenAccent));
        Navigator.pushReplacementNamed(context, '/');
      }).catchError((error) {
        if (error != null) {
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Falha no login!'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
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
        return Colors.blue;
      }
      return Colors.blue;
    }

    Future getImage() async {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) {
        return;
      }
      photoName = image.name;
      final imageTemporary = File(image.path);

      setState(() {
        this.photo = imageTemporary;
      });
    }

    ImageProvider getImageSource() {
      if (photo != null) {
        return FileImage(photo!);
      }

      return NetworkImage(
          'https://i.natgeofe.com/k/63b1a8a7-0081-493e-8b53-81d01261ab5d/red-panda-full-body_16x9.jpg');
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: CircleAvatar(
                  backgroundImage: getImageSource(),
                  radius: 52,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_a_photo_outlined,
                      size: 52,
                      color: Colors.white,
                    ),
                    onPressed: getImage,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextFormField(
                  style: const TextStyle(color: Colors.blue),
                  onChanged: (value) => {Variables.savedUser.name = value},
                  cursorColor: Colors.blue,
                  decoration: customInputDecoration('Nome'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.blue),
                  onChanged: (value) => {Variables.savedUser.email = value},
                  cursorColor: Colors.blue,
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
                  onChanged: (value) => {pass = value},
                  style: const TextStyle(color: Colors.blue),
                  decoration: customInputDecoration('Senha'),
                  cursorColor: Colors.blue,
                ),
              ),
              // Divider(),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            Variables.savedUser.local = '';
                          }
                          isChecked = value;
                        } else {
                          isChecked = false;
                        }
                        // isChecked = value!;
                      });
                    },
                  ),
                  const Text('Foi convidado?',
                      style: TextStyle(color: Colors.blue))
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: TextFormField(
                  controller: TextEditingController(text: Variables.savedUser.local),
                  enableSuggestions: false,
                  autocorrect: false,
                  readOnly: !isChecked,
                  onChanged: (value) => {Variables.savedUser.local = value},
                  style: const TextStyle(color: Colors.blue),
                  decoration: customInputDecoration(
                      isChecked ? 'Código de convite' : 'Código de convidado'),
                  cursorColor: Colors.blue,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: loading
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          signInUser();
                          appendNewUser();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(color: Colors.white),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
