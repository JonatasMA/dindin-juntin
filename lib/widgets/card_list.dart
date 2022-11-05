import 'package:dindin_juntin/models/bill.dart';
import 'package:flutter/material.dart';
import 'iten_card.dart';

class CardList extends StatelessWidget {
  dynamic list;
  CardList(this.list, {super.key});
  @override
  Widget build(BuildContext context) {
    print(list);
    List<Widget> cards = [];
    
    for (var i = 0; i < list.length; i++) {
      cards.add(
        ItenCard(list[i].title, list[i].value, list[i].billType)
      );
    }

    return Container(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: cards,
      )
    );
  }
}