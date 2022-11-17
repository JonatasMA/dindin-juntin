import 'package:dindin_juntin/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ]),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.blue.shade700,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, bottom: 24),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(
                      'https://i.natgeofe.com/k/63b1a8a7-0081-493e-8b53-81d01261ab5d/red-panda-full-body_16x9.jpg'),
                ),
                SizedBox(height: 12),
                Text(
                  'Jonatas',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  'jonatasmacedo70@hotmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
              leading: const Icon(Icons.info_outlined),
              title: const Text('Sobre'),
              onTap: () => {
                    Navigator.pop(context),
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            scrollable: true,
                            title: const Text('Sobre'),
                            content: Column(
                              children: const [
                                Text('Desenvolvido por GitHub:JonatasMA')
                              ],
                            ))),
                  }),
          ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair'),
              onTap: () => {
                    FirebaseAuth.instance.signOut(),
                    Navigator.pushReplacementNamed(context, '/login')
                  }),
        ],
      );

  String userPhoto() {
    String photo =
        'https://i.natgeofe.com/k/63b1a8a7-0081-493e-8b53-81d01261ab5d/red-panda-full-body_16x9.jpg';
    // if (userLogged != null && userLogged.photoURL != null) {
    //   photo = userLogged.photoURL;
    // }
    return photo;
  }
}
