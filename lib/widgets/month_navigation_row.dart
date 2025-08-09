import 'package:flutter/material.dart';

class MonthNavigationRow extends StatefulWidget {
  const MonthNavigationRow({Key? key}) : super(key: key);

  @override
  _MonthNavigationRowState createState() => _MonthNavigationRowState();
}

class _MonthNavigationRowState extends State<MonthNavigationRow> {
  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Semantics(
          child: TextButton(
            onPressed: () {
              setState(() {
                if (date.month > 1) {
                  date = DateTime(date.year, date.month - 1, 1);
                } else {
                  date = DateTime(date.year - 1, 12, 1);
                }
              });
            },
            child: const Icon(Icons.chevron_left),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Center(
              child: ExcludeSemantics(
                child: Text(
                  "${date.year}年${date.month}月",
                ), // 修正: 顯示格式化的日期
              ),
            ),
          ),
        ),
        Semantics(
          child: TextButton(
            onPressed: () {
              setState(() {
                if (date.month < 12) {
                  date = DateTime(date.year, date.month + 1, 1);
                } else {
                  date = DateTime(date.year + 1, 1, 1);
                }
              });
            },
            child: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}
