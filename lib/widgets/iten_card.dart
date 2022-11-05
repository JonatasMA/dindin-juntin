import 'dart:ffi';

import 'package:flutter/material.dart';

class ItenCard extends StatelessWidget {
  String title = '';
  String value = '0,00';
  int billType = 1;

  ItenCard(this.title, this.value, this.billType, {super.key});

  setIcon() {
    switch (billType) {
      case 1: {
        return const Icon(Icons.check, color: Colors.green);
      }
      break;

      case 2: {
        return const Icon(Icons.close, color: Colors.red);
      }
      break;

      case 3: {
        return const Icon(Icons.remove, color: Colors.yellow);
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          debugPrint('Card tapped.');
        },
        child: ListTile(
          title: Text(title),
          subtitle: Text('R\$ $value'),
          trailing: setIcon(),
        ),
      ),
    );
  }
}
