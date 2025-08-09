// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_field, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/job.dart';
import 'package:homebank/models/point.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/job.dart';
import 'package:homebank/providers/point.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // 修正: 將所有狀態變數移到 State 類別中
  UserModel? selected;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _currentDate = DateTime.now();
  Map<String, List<PointModel>> _pointRecords = {};
  Map<String, List<JobModel>> _jobRecords = {};
  StreamController _streamController = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    // 修正: 將異步操作移到 initState 中
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final pointProvider = Provider.of<PointProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    selected = authProvider.children.isNotEmpty
        ? authProvider.children.first
        : null;
    if (selected != null) {
      await pointProvider.getPointRecord(email: selected!.email).then((map) {
        _pointRecords = map;
        _streamController.add("update");
      });
      await jobProvider.getJobRecord(email: selected!.email).then((map) {
        _jobRecords = map;
        _streamController.add("update");
      });
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<UserModel> children = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).children;

    if (selected == null && children.isNotEmpty) {
      selected = children.first;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('統計資料'),
        actions: [
          if (selected?.email != null && selected!.email.isNotEmpty)
            TextButton(
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer(); // 修正: 使用 ?. 進行空值檢查
              },
              child: CircleAvatar(
                child: SvgPicture.string(selected!.avatarSvg),
              ), // 修正: 使用 !
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
                  Provider.of<PointProvider>(context, listen: false)
                      .getPointRecord(email: selected!.email) // 修正: 使用 !
                      .then((map) {
                        _pointRecords = map;
                        _streamController.add("update");
                      });
                  Provider.of<JobProvider>(context, listen: false)
                      .getJobRecord(email: selected!.email) // 修正: 使用 !
                      .then((map) {
                        _jobRecords = map;
                        _streamController.add("update");
                      });
                  scaffoldKey.currentState?.closeEndDrawer(); // 修正: 使用 ?.
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
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${selected?.name}目前點數", // 修正: 加上空值檢查
                style: TextStyle(color: Color(0xFF6183DB)),
              ),
              SizedBox(height: 10),
              Text(
                "\$${selected?.point ?? 0}", // 修正: 加上空值檢查
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (_currentDate.month > 1) {
                          _currentDate = DateTime(
                            _currentDate.year,
                            _currentDate.month - 1,
                            1,
                          );
                        } else {
                          _currentDate = DateTime(_currentDate.year - 1, 12, 1);
                        }
                        _streamController.add("update");
                      });
                    },
                    child: Icon(Icons.arrow_left, color: Colors.black),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          "${_currentDate.year}年${_currentDate.month}月",
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (_currentDate.month < 12) {
                          _currentDate = DateTime(
                            _currentDate.year,
                            _currentDate.month + 1,
                            1,
                          );
                        } else {
                          _currentDate = DateTime(_currentDate.year + 1, 1, 1);
                        }
                        _streamController.add("update");
                      });
                    },
                    child: Icon(Icons.arrow_right, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Align(alignment: Alignment.centerLeft, child: Text("點數趨勢圖")),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "\$${selected?.point ?? 0}", // 修正: 加上空值檢查
                  style: TextStyle(color: Color(0xFF6183DB)),
                ),
              ),
              StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  List<PointModel> _point_record =
                      _pointRecords[getYearMonth(_currentDate)] ?? [];
                  if (_point_record.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Text("尚無資料！"),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        height: 150,
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: _point_record.map((e) {
                                  return FlSpot(
                                    _point_record.indexOf(e).toDouble(),
                                    e.total.toDouble(),
                                  );
                                }).toList(),
                                color: Color(0xFF6183DB),
                                dotData: FlDotData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border(bottom: BorderSide()),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getLongDate(_point_record.first.date),
                            style: TextStyle(color: Color(0xFF5E6773)),
                          ),
                          Text(
                            getLongDate(_point_record.last.date),
                            style: TextStyle(color: Color(0xFF5E6773)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 30),
              Align(alignment: Alignment.centerLeft, child: Text("每周完成率")),
              StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  List<JobModel> _job_record =
                      _jobRecords[getYearMonth(_currentDate)] ?? [];
                  if (_job_record.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Text("尚無資料！"),
                    );
                  } else {
                    print(_job_record);
                    List<int> work = [0, 0, 0, 0];
                    List<int> house = [0, 0, 0, 0];
                    List<int> sport = [0, 0, 0, 0];
                    List<int> art = [0, 0, 0, 0];

                    List<int> finished_work = [0, 0, 0, 0];
                    List<int> finished_house = [0, 0, 0, 0];
                    List<int> finished_sport = [0, 0, 0, 0];
                    List<int> finished_art = [0, 0, 0, 0];

                    for (JobModel job in _job_record) {
                      if (job.type == WORK_TYPES[0]) {
                        int index = getWeekOfMonth(job.date) - 1;
                        if (index >= 0 && index < 4) {
                          // 修正: 新增索引邊界檢查
                          work[index]++;
                          if (job.finish) {
                            finished_work[index]++;
                          }
                        }
                      } else if (job.type == WORK_TYPES[1]) {
                        int index = getWeekOfMonth(job.date) - 1;
                        if (index >= 0 && index < 4) {
                          // 修正: 新增索引邊界檢查
                          house[index]++;
                          if (job.finish) {
                            finished_house[index]++;
                          }
                        }
                      } else if (job.type == WORK_TYPES[2]) {
                        int index = getWeekOfMonth(job.date) - 1;
                        if (index >= 0 && index < 4) {
                          // 修正: 新增索引邊界檢查
                          sport[index]++;
                          if (job.finish) {
                            finished_sport[index]++;
                          }
                        }
                      } else if (job.type == WORK_TYPES[3]) {
                        int index = getWeekOfMonth(job.date) - 1;
                        if (index >= 0 && index < 4) {
                          // 修正: 新增索引邊界檢查
                          art[index]++;
                          if (job.finish) {
                            finished_art[index]++;
                          }
                        }
                      }
                    }
                    print("total: $work, $house, $sport, $art");
                    print(
                      "finished: $finished_work, $finished_house, $finished_sport, $finished_art",
                    );
                    return Column(
                      children: [
                        Container(
                          height: 150,
                          child: BarChart(
                            BarChartData(
                              maxY: 100,
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barRods: [
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: work[0] == 0
                                          ? 0
                                          : (finished_work[0] * 100) / work[0],
                                      color: WORK_COLORS[0],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: house[0] == 0
                                          ? 0
                                          : (finished_house[0] * 100) /
                                                house[0],
                                      color: WORK_COLORS[1],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: sport[0] == 0
                                          ? 0
                                          : (finished_sport[0] * 100) /
                                                sport[0],
                                      color: WORK_COLORS[2],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: art[0] == 0
                                          ? 0
                                          : (finished_art[0] * 100) / art[0],
                                      color: WORK_COLORS[3],
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: work[1] == 0
                                          ? 0
                                          : (finished_work[1] * 100) / work[1],
                                      color: WORK_COLORS[0],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: house[1] == 0
                                          ? 0
                                          : (finished_house[1] * 100) /
                                                house[1],
                                      color: WORK_COLORS[1],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: sport[1] == 0
                                          ? 0
                                          : (finished_sport[1] * 100) /
                                                sport[1],
                                      color: WORK_COLORS[2],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: art[1] == 0
                                          ? 0
                                          : (finished_art[1] * 100) / art[1],
                                      color: WORK_COLORS[3],
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: work[2] == 0
                                          ? 0
                                          : (finished_work[2] * 100) / work[2],
                                      color: WORK_COLORS[0],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: house[2] == 0
                                          ? 0
                                          : (finished_house[2] * 100) /
                                                house[2],
                                      color: WORK_COLORS[1],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: sport[2] == 0
                                          ? 0
                                          : (finished_sport[2] * 100) /
                                                sport[2],
                                      color: WORK_COLORS[2],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: art[2] == 0
                                          ? 0
                                          : (finished_art[2] * 100) / art[2],
                                      color: WORK_COLORS[3],
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 3,
                                  barRods: [
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: work[3] == 0
                                          ? 0
                                          : (finished_work[3] * 100) / work[3],
                                      color: WORK_COLORS[0],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: house[3] == 0
                                          ? 0
                                          : (finished_house[3] * 100) /
                                                house[3],
                                      color: WORK_COLORS[1],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: sport[3] == 0
                                          ? 0
                                          : (finished_sport[3] * 100) /
                                                sport[3],
                                      color: WORK_COLORS[2],
                                    ),
                                    BarChartRodData(
                                      fromY: 0,
                                      toY: art[3] == 0
                                          ? 0
                                          : (finished_art[3] * 100) / art[3],
                                      color: WORK_COLORS[3],
                                    ),
                                  ],
                                ),
                              ],
                              titlesData: FlTitlesData(
                                show: true,
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(bottom: BorderSide()),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Week1",
                              style: TextStyle(color: Color(0xFF5E6773)),
                            ),
                            Text(
                              "Week2",
                              style: TextStyle(color: Color(0xFF5E6773)),
                            ),
                            Text(
                              "Week3",
                              style: TextStyle(color: Color(0xFF5E6773)),
                            ),
                            Text(
                              "Week4",
                              style: TextStyle(color: Color(0xFF5E6773)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: WORK_COLORS[0],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  WORK_TYPES[0],
                                  style: TextStyle(color: WORK_COLORS[0]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: WORK_COLORS[1],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  WORK_TYPES[1],
                                  style: TextStyle(color: WORK_COLORS[1]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: WORK_COLORS[2],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  WORK_TYPES[2],
                                  style: TextStyle(color: WORK_COLORS[2]),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: WORK_COLORS[3],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(3),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  WORK_TYPES[3],
                                  style: TextStyle(color: WORK_COLORS[3]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getWeekOfMonth(String _date) {
    print("parse $_date");
    DateTime date = DateTime.parse(_date);
    if (date.day > 28) {
      return 4;
    }
    return (date.day / 7).ceil();
  }
}
