import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addtx; //defined here to be arrivable

  NewTransaction(this.addtx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectDate;

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount < 0 || selectDate == null) {
      return; //return nothing, also stop fun execution
    }
    widget.addtx(
      //widget to access fun from statefulWidget or another class
      titleController.text,
      double.parse(amountController.text),
      selectDate,
    );
    Navigator.of(context)
        .pop(); //to close the model sheet when i press onSubmit
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((datePicker) {
      if (datePicker == null) {
        return;
      }
      setState(() {
        selectDate = datePicker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( //To make the sheet scrollable!
      child: Card(
        //TextField
        elevation: 5,
        child: Container(  //Respecting the Softkeyboard Insets
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) =>
                    submitData(), //fun needs a string, _ put it is an useless
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(selectDate == null
                          ? 'No date chosen!'
                          : 'Picked date:${DateFormat.yMd().format(selectDate)}'),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _presentDatePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
