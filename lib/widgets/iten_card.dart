import 'package:dindin_juntin/models/bill.dart';
import 'package:dindin_juntin/variables.dart';
import 'package:flutter/material.dart';
import 'package:dindin_juntin/widgets/custom_alert.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItenCard extends StatelessWidget {
  Bills bill;
  int index;

  ItenCard(this.bill, this.index, {super.key});

  setIcon() {
    switch (bill.billType) {
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
    String formatedValue = bill.value?.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00';
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.green.withAlpha(30),
        onTap: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => CustomAlert(
            bills: Variables.bills,
            index: index,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(bill.billerPhoto ?? ''),
          ),
          title: Text(bill.title ?? ''),
          subtitle: Text('R\$ $formatedValue \n${bill.date}'),
          trailing: setIcon(),
        ),
      ),
    );
  }
}
