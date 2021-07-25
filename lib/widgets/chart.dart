import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        final tx = recentTransaction[i];
        if (tx.time.day == weekDay.day &&
            tx.time.month == weekDay.month &&
            tx.time.year == weekDay.year) {
          totalSum += tx.amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay).substring(0, 1), 'amount': totalSum};
    }).reversed.toList();
  }

  double get totalSum {
    return groupedTransactionValues.fold(0.0, (sum, currentTx) {
      return sum += currentTx['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(data['day'], data['amount'],
                    totalSum == 0.0 ? 0.0 : (data['amount'] as double) / totalSum),
          );
        }).toList()),
      ),
    );
  }
}
