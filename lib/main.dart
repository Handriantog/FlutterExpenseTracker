import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_planner/widgets/add_transaction.dart';
import 'package:expense_planner/widgets/chart.dart';
import 'package:expense_planner/widgets/transaction_list.dart';
import 'models/transaction.dart';

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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final List<Transaction> _listTransaction = [
    /*Transaction(id: "Ts1", title: "Food", amount: 21, time: DateTime.now()),
    Transaction(
        id: "Ts2", title: "New shoes", amount: 69, time: DateTime.now()),*/
  ];


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

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
    return Platform.isIOS
        ? _iosScaffold(mediaQuery, isLandscape)
        : _androidScaffold(mediaQuery, isLandscape);
  }

  Widget _androidScaffold(MediaQueryData mediaQuery, bool isLandscape) {
    return Scaffold(
      appBar: _androidAppBar(),
      body: _mainBody(mediaQuery, isLandscape),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTxBottomSheet(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _iosScaffold(MediaQueryData mediaQuery, bool isLandscape) {
    return CupertinoPageScaffold(
      navigationBar: _iosAppBar(),
      child: _mainBody(mediaQuery, isLandscape),
    );
  }

  Widget _mainBody(MediaQueryData mediaQuery, bool isLandscape) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isLandscape) _switchContainer(),
            if (!isLandscape) _chartContainer(mediaQuery, 0.3),
            if (!isLandscape) _listTransactionContainer(mediaQuery),
            if (isLandscape)
              _showChart
                  ? _chartContainer(mediaQuery, 0.7)
                  : _listTransactionContainer(mediaQuery),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _androidAppBar() {
    return AppBar(
      title: const Text("Expense Planner"),
      actions: [
        IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTxBottomSheet(context)),
      ],
    );
  }

  PreferredSizeWidget _iosAppBar() {
    return CupertinoNavigationBar(
      middle: const Text("Expense Planner"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: const Icon(CupertinoIcons.add),
            onTap: () => _showAddTxBottomSheet(context),
          )
        ],
      ),
    );
  }

  Widget _switchContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Show Chart ", style: Theme.of(context).textTheme.title,),
        Switch.adaptive(
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
              _androidAppBar().preferredSize.height -
              mediaQuery.padding.top) *
          height,
      child: Chart(_recentTransaction),
    );
  }

  Widget _listTransactionContainer(MediaQueryData mediaQuery) {
    return Container(
      height: (mediaQuery.size.height -
              mediaQuery.padding.top -
              _androidAppBar().preferredSize.height) *
          0.7,
      child: TransactionList(_listTransaction, _onDeleteTransaction),
    );
  }
}
