import 'package:dindin_juntin/models/bill.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CustomAlert extends StatefulWidget {
  List<dynamic> bills;
  CustomAlert({required this.bills, super.key});

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  var title = '';
  var value = '';

  DateTime date = DateTime.now();
  TextEditingController txt = TextEditingController();

  void saveBill() {
    DatabaseReference testRef =
        FirebaseDatabase.instance.ref('A1').child('jonatas');
    Bills bill = Bills(value, title, 2, date);
    widget.bills.add(bill);
    List jsonBills = [];
    widget.bills.forEach((value) => {jsonBills.add(value.toJson())});
    testRef.child('bills').set(jsonBills);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Processing Data'),
          backgroundColor: Colors.greenAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    txt.text = '${date.day}/${date.month}/${date.year}';

    return AlertDialog(
      scrollable: true,
      title: const Text('Cadastrar'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              onChanged: (value) => {title = value},
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Titulo',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextFormField(
              onChanged: (newValue) => {value = newValue},
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Valor',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextFormField(
              controller: txt,
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (newDate == null) return;
                setState(() {
                  date = newDate;
                  txt.text = '${date.day}/${date.month}/${date.year}';
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
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => {saveBill(), Navigator.pop(context, 'OK')},
          child: const Text('Cadastrar'),
        ),
      ],
    );
  }
}

