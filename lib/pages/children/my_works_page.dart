// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/job.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:in_date_range/in_date_range.dart';
import 'package:provider/provider.dart';

class MyWorksPage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const MyWorksPage({super.key});

  @override
  State<MyWorksPage> createState() => _MyWorksPageState();
}

class _MyWorksPageState extends State<MyWorksPage> {
  Color buttonColor = Color.fromARGB(255, 103, 132, 213);
  DateTime _currentDate = DateTime.now();
  List<DateTime> _range = [];
  bool finished = false;
  // 修正: 移除 UserModel currentUser;，並直接在 build 方法中取得 Provider 的 user

  @override
  Widget build(BuildContext context) {
    // 修正: 使用 Provider.of 取得 UserModel，並確保它不為 null
    final currentUser = Provider.of<AuthProvider>(context, listen: true).user;
    return Scaffold(
      appBar: AppBar(title: Text('工作項目')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            buildMonthNavigationRow(context), // 修正: 傳入 context
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      finished = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: finished ? Colors.white : buttonColor,
                      border: Border.all(
                        color: finished ? Colors.white : buttonColor,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "未完成",
                      style: TextStyle(
                        color: finished ? buttonColor : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      finished = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: finished ? buttonColor : Colors.white,
                      border: Border.all(
                        color: finished ? buttonColor : Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "已完成",
                      style: TextStyle(
                        color: finished ? Colors.white : buttonColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: buildList(currentUser), // 修正: 傳入 currentUser
            ),
          ],
        ),
      ),
    );
  }

  // 修正: 接收 currentUser 作為參數
  Widget buildList(UserModel currentUser) {
    Map<String, dynamic> all_jobs = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).jobs;
    print("all_jobs: $all_jobs");
    List<JobModel> _data = all_jobs[currentUser.email] ?? [];
    List<JobModel> data = _data
        .where((job) => job.finish == finished)
        .where(
          (job) => _range.isEmpty
              ? isInMonth(job.date, _currentDate)
              : isInRange(job.date, DateRange(_range.first, _range.last)),
        )
        .toList();
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return buildDetailTile(
          getShortDate(data[index].date),
          data[index].type,
          data[index].note,
          data[index].point,
        );
      },
    );
  }

  Widget buildMonthNavigationRow(BuildContext context) {
    // 修正: 接收 context
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            setState(() {
              _range.clear();
              if (_currentDate.month > 1) {
                _currentDate = DateTime(
                  _currentDate.year,
                  _currentDate.month - 1,
                  1,
                );
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
              List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
                // 修正: 變數改為可空
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: [_currentDate], // 修正: 將 initialValue 改為 value
                dialogBackgroundColor: Colors.white,
              );
              if (picked != null && picked.isNotEmpty) {
                // 修正: 進行空值檢查
                setState(() {
                  _range = picked
                      .whereType<DateTime>()
                      .toList(); // 修正: 過濾掉 null
                });
              }
            }),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: _range.isEmpty
                    ? Text("${_currentDate.year}年${_currentDate.month}月")
                    : Column(
                        children: [
                          Text(
                            "${_range.first.year}-${_range.first.month}-${_range.first.day} ~ ${_range.last.year}-${_range.last.month}-${_range.last.day}",
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _range.clear();
              if (_currentDate.month < 12) {
                _currentDate = DateTime(
                  _currentDate.year,
                  _currentDate.month + 1,
                  1,
                );
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

  Widget buildDetailTile(String date, String type, String detail, int point) {
    return ListTile(
      title: Row(
        children: [
          Text(date, style: TextStyle(color: Colors.black87, fontSize: 14)),
          SizedBox(width: 20),
          Text(type, style: TextStyle(color: getTypeColor(type), fontSize: 14)),
        ],
      ),
      subtitle: Text(
        detail,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            Image.asset("assets/images/coin.png", width: 20),
            Text("  $point點"),
          ],
        ),
      ),
    );
  }
}
