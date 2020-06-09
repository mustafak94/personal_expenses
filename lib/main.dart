import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import 'models/transactions.dart';
import 'widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    to cancel rotation:
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp,
//      DeviceOrientation.portraitUp,
//    ]);

    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          //default color for all widgets
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          errorColor: Colors.red,
          textTheme: //default textTheme for all text types
              ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    button: TextStyle(color: Colors.white),
                  ),
          appBarTheme: AppBarTheme(
              //to make default font or all appBars
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
//  String titleInput;
//  String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [
//    Transaction(
//        //using my class as a constructor
//        id: 't1',
//        title: 'Shoes',
//        amount: 15.75,
//        date: DateTime.now()),
//    Transaction(
//        //second
//        id: 't2',
//        title: 'Headphone',
//        amount: 10.25,
//        date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList(); //it's not a list, it's a iterable
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenTime) {
    final newtx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenTime,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newtx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      // fun provided by Flutter
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          //to remove the sheet when you tap outside
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery= MediaQuery.of(context); //more efficient way
    //to Know if the device is landscape or not, var will carry true
    final isLandscape= mediaQuery.orientation==Orientation.landscape;

    final appBar = AppBar(
      //variable to access from anywhere
      title: Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          iconSize: 40,
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );

    final txListWidget=Container(  //made it a var to avoid duplicate
      height: ( mediaQuery.size.height //60%
          -
          appBar.preferredSize.height -
           mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start, //The default is start
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //to show chart when you active rotation mode, cause of its little size
            if(isLandscape)Row( //special if, called if inside list, without {}
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  },
                )
              ],
            ),
            if(!isLandscape)Container(  //if _showChart is true:
              height: ( mediaQuery.size.height //30%
                  -appBar.preferredSize.height -
                   mediaQuery.padding.top) *
                  0.3, //padding.top refer to stateBar
              //preferredSize property store appBar dimensions
              child: Chart(_recentTransactions),
            ),
            if(!isLandscape)
              txListWidget,
            if(isLandscape)
              _showChart?
            Container(  //if _showChart is true:
              height: ( mediaQuery.size.height //30%
                      -appBar.preferredSize.height -
                       mediaQuery.padding.top) *
                  0.7, //padding.top refer to stateBar
              //preferredSize property store appBar dimensions
              child: Chart(_recentTransactions),
            )
            : txListWidget //if _showChart is false
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, //direction purposes
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}
