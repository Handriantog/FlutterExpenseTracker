import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  static const double TOTAL_SPEND_SIZE = 0.15;
  static const double BAR_CHART_SIZE = 0.6;
  static const double SPACING_SIZE = 0.05;
  static const double LABEL_SIZE = 0.15;

  final String label;
  final double spendingAmount;
  final double spendingPercentOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPercentOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: [
            Container(
              height: constraints.maxHeight * TOTAL_SPEND_SIZE,
              child: FittedBox(
                  child: Text(
                "\$${spendingAmount.toStringAsFixed(0)}",
              )),
            ),
            SizedBox(
              height: constraints.maxHeight * SPACING_SIZE,
            ),
            Container(
              height: constraints.maxHeight * BAR_CHART_SIZE,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.0),
                        color: Color.fromRGBO(220, 220, 220, 1),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPercentOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * SPACING_SIZE,
            ),
            Container(
              height: constraints.maxHeight * LABEL_SIZE,
              child: FittedBox(
                child: Text("$label"),
              ),
            ),
          ],
        );
      },
    );
  }
}
