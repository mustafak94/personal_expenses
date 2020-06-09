import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, //generate takes length and index 7 days of the week
        (index) {
      //function to execute for every generated list element
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      return {
        //return map
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        //.E is shortcut day of the week, T,W,F... with help of .substring(0, 1)
        'amount': totalSum,
      };
    }).reversed.toList();//to make today is first of them
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      //0.0 initial value
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(groupedTransactionValues);   //debugging purposes
    return Card(
      elevation: 6, // to give some shadow
      margin: EdgeInsets.all(20),
      child: Padding(
        //if use only padding, will use padding widget not container
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            //any name you choose
            //this fun will execute for every element in the list
            return Flexible(
              //wrapping with a widget
              fit: FlexFit.tight,
              //the child is forced to fill the available space
              //so, every item will take the same space
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0 //if else
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
