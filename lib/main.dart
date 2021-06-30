import 'package:expense_planner/widgets/add_transaction.dart';
import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'package:flutter/services.dart';

import 'models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  /*
  To lock device orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);*/
  runApp(ExpensePlannerApp());
}

class ExpensePlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expense Planner",
      home: HomePage(),
      theme: ThemeData(
          primarySwatch: Colors.green,
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: "OpenSans",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _listTransaction = [
    /*Transaction(id: "Ts1", title: "Food", amount: 21, time: DateTime.now()),
    Transaction(
        id: "Ts2", title: "New shoes", amount: 69, time: DateTime.now()),*/
  ];

  List<Transaction> get _recentTransaction {
    return _listTransaction.where((tx) {
      return tx.time.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        time: chosenDate);
    setState(() {
      _listTransaction.add(newTx);
    });
  }

  void _showAddTxBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return AddTransaction(_addNewTransaction);
        });
  }

  void _onDeleteTransaction(String id) {
    setState(() {
      _listTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isLandscape) _switchContainer(),
            if (!isLandscape) _chartContainer(mediaQuery, 0.3),
            if (!isLandscape) _listTransactionContainer(mediaQuery),
            if (isLandscape)
              _showChart ? _chartContainer(mediaQuery, 0.7) : _listTransactionContainer(mediaQuery),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddTxBottomSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text("Expense Planner"),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddTxBottomSheet(context)),
      ],
    );
  }

  Widget _switchContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Show Chart "),
        Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ],
    );
  }

  Widget _chartContainer(MediaQueryData mediaQuery, double height) {
    return Container(
      height: (mediaQuery.size.height -
              _appBar().preferredSize.height -
              mediaQuery.padding.top) *
          height,
      child: Chart(_recentTransaction),
    );
  }

  Widget _listTransactionContainer(MediaQueryData mediaQuery) {
    return Container(
      height: (mediaQuery.size.height -
              mediaQuery.padding.top -
              _appBar().preferredSize.height) *
          0.7,
      child: TransactionList(_listTransaction, _onDeleteTransaction),
    );
  }
}
