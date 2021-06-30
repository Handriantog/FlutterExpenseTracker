import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function onAddNewTransactionHandler;

  AddTransaction(this.onAddNewTransactionHandler);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _chosenDate;

  void _onSubmitted() {
    final titleVal = _titleController.text;
    final amountVal = double.parse(_amountController.text);

    if (titleVal.isEmpty || amountVal <= 0 || _chosenDate == null) {
      return;
    }

    widget.onAddNewTransactionHandler(_titleController.text,
        double.parse(_amountController.text), _chosenDate);

    Navigator.of(context).pop();
  }

  void _openDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((date) {
      setState(() {
        if (date == null) return;
        _chosenDate = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                onSubmitted: (_) => _onSubmitted,
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: "Amount",
                ),
                onSubmitted: (_) => _onSubmitted,
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_chosenDate == null
                          ? "No Date Chosen"
                          : "Selected Date : ${DateFormat.yMd().format(_chosenDate)}"),
                    ),
                    TextButton(
                      onPressed: _openDatePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: Theme.of(context).textTheme.button),
                onPressed: _onSubmitted,
                child: Text("Add Transaction"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
