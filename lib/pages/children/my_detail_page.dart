import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:in_date_range/in_date_range.dart';
import 'package:provider/provider.dart';

class MyDetailPage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const MyDetailPage({super.key});

  @override
  State<MyDetailPage> createState() => _MyDetailPageState();
}

class _MyDetailPageState extends State<MyDetailPage> {
  DateTime _currentDate = DateTime.now();
  List<DateTime> _range = [];
  // 修正: 移除 UserModel currentUser;，並直接在 build 方法中取得 Provider 的 user

  @override
  Widget build(BuildContext context) {
    // 修正: 使用 Provider.of 取得 UserModel，並確保它不為 null
    final currentUser = Provider.of<AuthProvider>(context, listen: true).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('查詢明細'), // 修正: 加上 const
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 10, right: 10), // 修正: 加上 const
        child: Column(
          children: [
            buildMonthNavigationRow(context), // 修正: 傳入 context
            Expanded(
              child: buildList(currentUser), // 修正: 傳入 currentUser
            ),
          ],
        ),
      ),
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
          child: const Icon(
            Icons.arrow_left,
            color: Colors.black,
          ), // 修正: 加上 const
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
          child: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ), // 修正: 加上 const
        ),
      ],
    );
  }

  Widget buildList(UserModel currentUser) {
    // 修正: 接收 currentUser
    Map<String, dynamic> all_points = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).points;
    print("all_points: $all_points");
    List<PointModel> _data = all_points[currentUser.email] ?? [];
    List<PointModel> data = _data
        .where(
          (element) => _range.isEmpty
              ? isInMonth(element.date, _currentDate)
              : isInRange(element.date, DateRange(_range.first, _range.last)),
        )
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        PointModel model = data[index];
        DateTime _date = DateTime.parse(model.date);
        return buildDetailTile(
          "${_date.month}/${_date.day}",
          model.type,
          model.note,
          model.point,
        );
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
            style: const TextStyle(
              // 修正: 加上 const
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 20), // 修正: 加上 const
          Text(type, style: TextStyle(color: getTypeColor(type), fontSize: 14)),
        ],
      ),
      subtitle: Text(
        detail,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ), // 修正: 加上 const
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
