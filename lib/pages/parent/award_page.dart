// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/parent/award_add_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/point.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:in_date_range/in_date_range.dart';
import 'package:provider/provider.dart';

class AwardPage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const AwardPage({super.key});

  @override
  State<AwardPage> createState() => _AwardPageState();
}

class _AwardPageState extends State<AwardPage> {
  DateTime _currentDate = DateTime.now();
  List<DateTime> _range = [];
  UserModel selected = UserModel();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<UserModel> children = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).children;
    if (selected.email.isEmpty && children.isNotEmpty) {
      selected = children.first;
    }
    // 修正: 移除未使用變數 String year_month
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('獎勵專區'),
        actions: [
          if (selected.email.isNotEmpty)
            TextButton(
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer(); // 修正: 使用 ?. 進行空值檢查
              },
              child: CircleAvatar(child: SvgPicture.string(selected.avatarSvg)),
            ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                setState(() {
                  selected = children[index];
                  scaffoldKey.currentState
                      ?.closeEndDrawer(); // 修正: 使用 ?. 進行空值檢查
                });
              },
              leading: CircleAvatar(
                child: SvgPicture.string(children[index].avatarSvg),
              ),
              title: Text(children[index].name),
            );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            buildMonthNavigationRow(context), // 修正: 傳入 context
            if (selected.email.isNotEmpty)
              Expanded(
                child: buildList(context), // 修正: 傳入 context
              ),
            if (selected.email.isEmpty) Expanded(child: Container()),
            LargeButton(
              onTap: () {
                Navigator.push(
                  context,
                  navegateFadein(context, AwardAddPage()),
                );
              },
              title: "新增獎勵",
              fontSize: 16,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    Map<String, dynamic> all_points = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).points;
    print("all_points: $all_points");
    List<PointModel> _data = all_points[selected.email] ?? [];
    List<PointModel> data = _data
        .where((element) => element.type == ALL_WORK_TYPES.last)
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
          model.note,
          model.point,
        );
      },
      itemCount: data.length,
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

  Widget buildDetailTile(String date, String detail, int point) {
    return ListTile(
      title: Row(
        children: [
          Text(date, style: TextStyle(color: Colors.black87, fontSize: 14)),
          SizedBox(width: 20),
          Text(detail, style: TextStyle(color: Colors.black, fontSize: 15)),
        ],
      ),
      trailing: SizedBox(
        width: 80,
        child: Row(
          children: [
            Image.asset("assets/images/coin.png", width: 20),
            Text("  ${-point}點"),
          ],
        ),
      ),
    );
  }
}
