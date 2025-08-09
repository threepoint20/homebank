import 'package:flutter/material.dart';

class MonthNavigationRow extends StatelessWidget {
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Semantics(
          child: TextButton(
            onPressed: () {
              if (date.month > 1) {
                date = DateTime(date.year, date.month - 1, 1);
              } else {
                date = DateTime(date.year - 1, 12, 1);
              }
            },
            child: Icon(Icons.chevron_left),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Center(
              child: ExcludeSemantics(
                child: Text(date.toString().split(" ").first),
              ),
            ),
          ),
        ),
        Semantics(
          child: TextButton(
            onPressed: () {
              if (date.month < 12) {
                date = DateTime(date.year, date.month + 1, 1);
              } else {
                date = DateTime(date.year + 1, 1, 1);
              }
            },
            child: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}
