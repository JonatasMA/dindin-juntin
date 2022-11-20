import 'dart:ffi';

import 'package:dindin_juntin/main.dart';
import 'package:dindin_juntin/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dindin_juntin/widgets/custom_alert.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItenCard extends StatelessWidget {
  String title = '';
  num value = 0;
  String date = '10/11/2022';
  int billType = 1;
  String biller = '';
  String billerPhoto = '';
  int index;

  ItenCard(this.title, this.value, this.billType, this.date, this.biller,
      this.billerPhoto, this.index,
      {super.key});

  setIcon() {
    switch (billType) {
      case 1:
        {
          return const Icon(Icons.arrow_upward, color: Colors.green);
        }

      case 2:
        {
          return const Icon(Icons.arrow_downward, color: Colors.red);
        }

      case 3:
        {
          return const Icon(Icons.group, color: Colors.amber);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatedValue = value.toStringAsFixed(2).replaceAll('.', ',');
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.green.withAlpha(30),
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => CustomAlert(
            bills: billsList,
            index: index,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(billerPhoto),
          ),
          title: Text(title),
          subtitle: Text('R\$ $formatedValue \n$date'),
          trailing: setIcon(),
        ),
      ),
    );
  }
}
