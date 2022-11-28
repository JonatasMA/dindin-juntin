import 'package:dindin_juntin/models/bill.dart';
import 'package:dindin_juntin/models/saved_user.dart';
import 'package:dindin_juntin/variables.dart';
import 'package:flutter/foundation.dart';
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
  int _index = -1;
  var title = '';
  num value = 0;
  List<bool> type = [true, false];
  List<bool> isPaid = [false];

  DateTime date = DateTime.now();
  TextEditingController txt = TextEditingController();

  int getType() {
    if (listEquals(type, [true, false])) {
      return 2;
    }
    return 3;
  }

  List<bool> setType(int billType) {
    switch (billType) {
      case 2:
        return [true, false];
      case 3:
        return [false, true];
    }

    return type;
  }

  void saveBill() {
    DatabaseReference billsRef =
        FirebaseDatabase.instance.ref(Variables.savedUser.local);
    Bills bill = Bills(
      value: value,
      title: title,
      billType: getType(),
      date: date,
      biller: Variables.savedUser.uid,
      billerPhoto: Variables.savedUser.photoURL,
      paid: isPaid[0]
    );

    if (widget.index > -1) {
      Variables.bills[widget.index] = bill;
    } else {
      Variables.bills.add(bill);
    }

    List jsonBills = [];
    Variables.bills.forEach((value) => {jsonBills.add(value.toJson())});
    billsRef.child('bills').set(jsonBills);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Dados salvos'),
          backgroundColor: Colors.greenAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index > -1 && _index == -1) {
      _index = widget.index;
      var bill = widget.bills[widget.index];
      title = bill.title;
      value = bill.value;
      txt.text = bill.getFormattedDate();
      date = bill.date;
      type = setType(bill.billType);
      isPaid = [bill.paid];
    }
    txt.text = '${date.day}/${date.month}/${date.year}';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                ToggleButtons(
                  isSelected: type,
                  onPressed: (index) {
                    setState(() {
                      type = [false, false];
                      type[index] = !type[index];
                    });
                  },
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 40.0,
                  ),
                  color: Colors.grey,
                  selectedColor: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  children: const [
                    Icon(Icons.person),
                    Icon(Icons.people),
                  ],
                ),
                const Spacer(),
                ToggleButtons(
                  isSelected: isPaid,
                  onPressed: (index) {
                    setState(() {
                      isPaid[index] = !isPaid[index];
                    });
                  },
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 60.0,
                  ),
                  selectedBorderColor: Colors.green[300],
                  selectedColor: Colors.green[900],
                  fillColor: Colors.green[100],
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  children: const [
                    Text('pago'),
                  ],
                ),
                const Spacer(),
              ],
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
          child: Text(widget.index > -1 ? 'Ok' : 'Cadastrar'),
        ),
      ],
    );
  }
}
