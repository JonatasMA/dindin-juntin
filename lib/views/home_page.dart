import 'package:dindin_juntin/models/bill.dart';
import 'package:dindin_juntin/widgets/custom_alert.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dindin_juntin/widgets/card_list.dart';

import '../widgets/bottom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic _bills = [];

  final _fabLocation = FloatingActionButtonLocation.miniEndDocked;

  Widget futureWidget = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    String saldo = '3,00';
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    final DatabaseReference fbd =
        FirebaseDatabase.instance.ref('A1').child('jonatas').child('bills');
    fbd.onValue.listen((DatabaseEvent event) {
      var result = event.snapshot;
      List bills = [];
      for (var i = 0; i < result.children.length; i++) {
        dynamic bill = result.child(i.toString());
        bills.add(Bills.fromFirebase(bill));
      }

      setState(() {
        _bills = bills;
        futureWidget = CardList(_bills);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dindin juntin'),
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
      body: Center(child: futureWidget),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => CustomAlert(bills: _bills),
        ),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: _fabLocation,
      bottomNavigationBar: CustomBottomAppBar(
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
