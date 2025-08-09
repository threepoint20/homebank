import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:in_date_range/in_date_range.dart';
import 'package:provider/provider.dart';

class MyDetailPage extends StatefulWidget {
  const MyDetailPage({Key key}) : super(key: key);

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  DateTime _currentDate = DateTime.now();
  List<DateTime> _range = [];
  UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<AuthProvider>(context, listen: true).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('查詢明細'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            buildMonthNavigationRow(),
            Expanded(
              child: buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMonthNavigationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _range.clear();
              if (_currentDate.month > 1) {
                _currentDate =
                    DateTime(_currentDate.year, _currentDate.month - 1, 1);
              } else {
                _currentDate = DateTime(_currentDate.year - 1, 12, 1);
              }
            });
          },
          child: Icon(Icons.arrow_left, color: Colors.black),
        ),
        Expanded(
          child: GestureDetector(
            onTap: (() async {
              final config = CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.range,
                selectedDayHighlightColor: Colors.purple[800],
                closeDialogOnCancelTapped: true,
              );
              List<DateTime> picked = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                initialValue: [_currentDate],
                dialogBackgroundColor: Colors.white,
              );
              if (picked.isNotEmpty) {
                setState(
                  () {
                    _range = picked;
                  },
                );
              }
            }),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: _range.isEmpty
                    ? Text("${_currentDate.year}年${_currentDate.month}月")
                    : Column(children: [
                        Text(
                            "${_range.first.year}-${_range.first.month}-${_range.first.day} ~ ${_range.last.year}-${_range.last.month}-${_range.last.day}")
                      ]),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _range.clear();
              if (_currentDate.month < 12) {
                _currentDate =
                    DateTime(_currentDate.year, _currentDate.month + 1, 1);
              } else {
                _currentDate = DateTime(_currentDate.year + 1, 1, 1);
              }
            });
          },
          child: Icon(Icons.arrow_right, color: Colors.black),
        ),
      ],
    );
  }

  Widget buildList() {
    Map<String, dynamic> all_points =
        Provider.of<AuthProvider>(context, listen: true).points;
    print("all_points: $all_points");
    List<PointModel> _data = all_points[currentUser.email] ?? [];
    List<PointModel> data = _data
        .where((element) => _range.isEmpty
            ? isInMonth(element.date, _currentDate)
            : isInRange(element.date, DateRange(_range.first, _range.last)))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        PointModel model = data[index];
        DateTime _date = DateTime.parse(model.date);
        return buildDetailTile(
            "${_date.month}/${_date.day}", model.type, model.note, model.point);
      },
      itemCount: data.length,
    );
  }

  Widget buildDetailTile(String date, String type, String detail, int point) {
    return ListTile(
      title: Row(
        children: [
          Text(
            date,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 20),
          Text(
            type,
            style: TextStyle(
              color: getTypeColor(type),
              fontSize: 14,
            ),
          ),
        ],
      ),
      subtitle:
          Text(detail, style: TextStyle(color: Colors.black, fontSize: 16)),
      trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            Text(
              "${point > 0 ? "+" : "-"}$point點",
              style: TextStyle(color: point > 0 ? Colors.black87 : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
