import 'package:expense_planner/widgets/transaction_item.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _listTransaction;
  final Function _onDelete;

  TransactionList(this._listTransaction, this._onDelete);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 294,
      child: _listTransaction.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Column(
                  children: [
                    Text(
                      "No Data Added Yet!",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        "assets/image/waiting.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                );
              },
            )
          : ListView(
              children: _listTransaction
                  .map((tx) => TransactionItem(
                        key: ValueKey(tx.id),
                        transaction: tx,
                        onDelete: _onDelete,
                      ))
                  .toList(),
            ),
    );
  }
}
