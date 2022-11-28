import 'package:flutter/material.dart';
import 'iten_card.dart';

class CardList extends StatelessWidget {
  dynamic list;
  CardList(this.list, {super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];
    
    for (var i = 0; i < list.length; i++) {
      String date = '${list[i].date.day}/${list[i].date.month}/${list[i].date.year}';
      cards.add(
        ItenCard(list[i], i)
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: cards,
    );
  }
}