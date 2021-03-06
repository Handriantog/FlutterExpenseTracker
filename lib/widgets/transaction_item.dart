import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_planner/models/transaction.dart';

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final Function onDelete;

  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.onDelete,
  }) : super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: FittedBox(child: Text("\$${widget.transaction.amount}")),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.time)),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                onPressed: () => widget.onDelete(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: Text("Delete"),
                style: TextButton.styleFrom(primary: Colors.red),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.onDelete(widget.transaction.id),
              ),
      ),
    );
  }

  @override
  void initState() {
    final colorList = [Colors.black, Colors.blue, Colors.green, Colors.purple];

    _bgColor = colorList[Random().nextInt(4)];
    super.initState();
  }
}
