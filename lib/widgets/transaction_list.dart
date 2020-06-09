import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  //Constructor can pass data from parent widget to the child widget

  @override
  Widget build(BuildContext context) {
    return Container(
      //ListView scrolls in these 300px, avoid content overloading
      child: transactions.isEmpty
          ? //if else
          LayoutBuilder(
              builder: (cxt, constrains) {
                return Column(
                  children: <Widget>[
                    Text(
                      'No transactions added yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      //empty box to make space between tow widgets
                      height: 10,
                    ),
                    Container(
                      //wrapping image with Container to fit it with the height
                      height: constrains.maxHeight * 0.7,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover, //to make image no bigger or smaller
                      ),
                    )
                  ],
                );
              },
            )

          //else block
          : ListView.builder(
              //ListView by default with scrollable
              //scrollDirection: Axis.horizontal, //if you wanna make a Row().
              itemBuilder: (context, index) {
                //should to take this argument
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      //makes as a circles
                      radius: 35,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('\$${transactions[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? FlatButton.icon(  //with large width sizes
                            icon: Icon(Icons.delete),
                            label: Text('Delete!'),
                            textColor: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transactions[index].id),
                          )
                        : IconButton( //with normal width sizes
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transactions[index].id),
                            //()=> cause there's no arguments
                          ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
