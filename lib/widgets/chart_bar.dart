import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPcOfTotal; //spendingPcOfTotal, Pc is percent
  ChartBar(this.label, this.spendingAmount, this.spendingPcOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (cxt, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight*0.15,
              child: FittedBox(
                  //wrap with widget, to force Text() to take a size no longer
                  child: Text(
                      '\$${spendingAmount.toStringAsFixed(0)}') //toStringAsFixed removes decimal
                  ),
            ),
            SizedBox(
              height: constraints.maxHeight*0.05,
            ),
            Container(
              height: constraints.maxHeight*0.6,
              width: 10,
              child: Stack(
                //on top other but with wrapping not like a Column
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Colors.grey[350],
                      //color: Color.fromARGB(220, 220, 2200, 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  FractionallySizedBox(
                    //sized ad a percent value
                    heightFactor: spendingPcOfTotal, //takes value

                    child: Container(

                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: constraints.maxHeight*0.05,
            ),
            Container(
                height: constraints.maxHeight*0.15,
                child: FittedBox(
                    child: Text(label))
            ),
          ],
        );
      },
    );
  }
}
