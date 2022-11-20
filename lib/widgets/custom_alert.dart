import 'package:dindin_juntin/models/bill.dart';
import 'package:dindin_juntin/models/saved_user.dart';
import 'package:dindin_juntin/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class CustomAlert extends StatefulWidget {
  List<dynamic> bills;
  int index = -1;
  SavedUser? user;
  CustomAlert({required this.bills, this.index = -1, this.user, super.key});

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  var title = '';
  num value = 0;

  DateTime date = DateTime.now();
  TextEditingController txt = TextEditingController();

  void saveBill() {
    DatabaseReference testRef =
        FirebaseDatabase.instance.ref(widget.user?.local);
    Bills bill =
        Bills(value, title, 2, date, widget.user?.uid, widget.user?.photoURL);
    if (widget.index > -1) {
      widget.bills[widget.index] = bill;
    } else {
      widget.bills.add(bill);
    }
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
    var type;
    if (widget.index > -1) {
      var bill = widget.bills[widget.index];
      title = bill.title;
      value = bill.value;
      txt.text = bill.getFormattedDate();
      date = bill.date;
    }

    final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(
        locale: 'pt-br',
        decimalDigits: 2,
        symbol: 'R\$',
        enableNegative: false);

    return AlertDialog(
      scrollable: true,
      title: Text(widget.index > -1 ? 'Editar' : 'Cadastrar'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              initialValue: title,
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
              initialValue: formatter.format(value.toStringAsFixed(2)),
              inputFormatters: [formatter],
              onChanged: (newValue) =>
                  {value = formatter.getUnformattedValue()},
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
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       // ListTile(
          //       //   title: const Text('Individual'),
          //       //   leading: Radio(
          //       //     value: 1,
          //       //     groupValue: type,
          //       //     onChanged: (a) {},
          //       //   ),
          //       // ),
          //       // ListTile(
          //       //   title: const Text('Grupo'),
          //       //   leading: Radio(
          //       //     value: 2,
          //       //     groupValue: type,
          //       //     onChanged: (a) {},
          //       //   ),
          //       // )
          //     ],
          //   ),
          // ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => {saveBill(), Navigator.pop(context, 'OK')},
          child: Text(widget.index > -1 ? 'Ok' : 'Cadastrar'),
        ),
      ],
    );
  }
}
