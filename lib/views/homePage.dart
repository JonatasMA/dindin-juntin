import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:dindin_juntin/models/bill.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dindin_juntin/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dindin_juntin/widgets/card_list.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp(
//   //   options: DefaultFirebaseOptions.currentPlatform,
//   // );
//   runApp(Home());
// }

// class Home extends StatelessWidget {
//   final Future<FirebaseApp> _fbApp =
//       Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Dindin Juntin',
//         theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
//         home: FutureBuilder(
//           future: _fbApp,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               print('You have an error! ${snapshot.error.toString()}');
//               return Text('Somenthing went wrong!');
//             } else if (snapshot.hasData) {
//               return const HomePage(title: 'Dindin Juntin');
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         )
//         // home: const MyHomePage(title: 'Dindin Juntin'),
//         );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic _bills = [];
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  Widget place = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    String saldo = '3,00';
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    DatabaseReference _fbd =
        FirebaseDatabase.instance.ref('A1').child('jonatas').child('bills');
    _fbd.onValue.listen((DatabaseEvent event) {
      var result = event.snapshot;
      List bills = [];
      for (var i = 0; i < result.children.length; i++) {
        dynamic bill = result.child(i.toString());
        bills.add(Bills.fromFirebase(bill));
      }

      setState(() {
        _bills = bills;
        place = CardList(_bills);
      });
    });

    var _title = '';
    var _value = '';
    DateTime _date = DateTime.now();
    TextEditingController txt = TextEditingController();
    txt.text = '${_date.day}/${_date.month}/${_date.year}';

    void _saveBill() {
      DatabaseReference _testRef =
          FirebaseDatabase.instance.ref('A1').child('jonatas');
      Bills bill = Bills(_value, _title, 1, _date);
      _bills.add(bill);
      List jsonBills = [];
      _bills.forEach((value) => {jsonBills.add(value.toJson())});
      _testRef.child('bills').set(jsonBills);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dindin juntin'),
        leading: IconButton(
          tooltip: 'Menu',
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            style: style,
            onPressed: () {},
            child: Text(
              'Saldo: R\$ $saldo',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            tooltip: 'Filtrar',
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(child: place),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Cadastrar'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    onChanged: (value) => {_title = value},
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Titulo',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    onChanged: (value) => {_value = value},
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Valor',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: txt,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (newDate == null) return;
                      setState(() {
                        _date = newDate;
                        txt.text = '${_date.day}/${_date.month}/${_date.year}';
                      });
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Data',
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {_saveBill(), Navigator.pop(context, 'OK')},
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar: _BottomAppBar(
        fabLocation: _fabLocation,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
            ),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
    );
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape = const AutomaticNotchedShape(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Search',
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              tooltip: 'Favorite',
              icon: const Icon(Icons.group, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}