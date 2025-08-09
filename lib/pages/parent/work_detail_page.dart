// ignore_for_file: prefer_const_constructors

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/job.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/job.dart';
import 'package:homebank/providers/point.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:in_date_range/in_date_range.dart';
import 'package:provider/provider.dart';

class WorkDetailPage extends StatelessWidget {
  final int type;
  WorkDetailPage({Key key, this.type}) : super(key: key);
  TextEditingController pointCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  DateTime _currentDate = DateTime.now();
  List<DateTime> _range = [];
  UserModel selected = UserModel();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<UserModel> children =
        Provider.of<AuthProvider>(context, listen: true).children;

    if (selected.email.isEmpty && children.isNotEmpty) {
      selected = children.first;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: TextButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text("${WORK_TYPES[type]}列表",
                style: TextStyle(color: Colors.white)),
            backgroundColor: WORK_COLORS[type],
            actions: [
              if (selected.email.isNotEmpty)
                TextButton(
                  onPressed: () {
                    scaffoldKey.currentState.openEndDrawer();
                  },
                  child: CircleAvatar(
                      child: SvgPicture.string(selected.avatarSvg)),
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
                        scaffoldKey.currentState.closeEndDrawer();
                      });
                    },
                    leading: CircleAvatar(
                      child: SvgPicture.string(children[index].avatarSvg),
                    ),
                    title: Text(children[index].name),
                  );
                }),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _range.clear();
                          if (_currentDate.month > 1) {
                            _currentDate = DateTime(
                                _currentDate.year, _currentDate.month - 1, 1);
                          } else {
                            _currentDate =
                                DateTime(_currentDate.year - 1, 12, 1);
                          }
                        });
                      },
                      child: Icon(Icons.arrow_left, color: Colors.black),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (() async {
                          final config =
                              CalendarDatePicker2WithActionButtonsConfig(
                            calendarType: CalendarDatePicker2Type.range,
                            selectedDayHighlightColor: Colors.purple[800],
                            closeDialogOnCancelTapped: true,
                          );
                          List<DateTime> picked =
                              await showCalendarDatePicker2Dialog(
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
                                ? Text(
                                    "${_currentDate.year}年${_currentDate.month}月")
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
                            _currentDate = DateTime(
                                _currentDate.year, _currentDate.month + 1, 1);
                          } else {
                            _currentDate =
                                DateTime(_currentDate.year + 1, 1, 1);
                          }
                        });
                      },
                      child: Icon(Icons.arrow_right, color: Colors.black),
                    ),
                  ],
                ),
                Expanded(
                  child: buildList(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildList(BuildContext context) {
    Map<String, dynamic> all_jobs =
        Provider.of<AuthProvider>(context, listen: true).jobs;
    print("all_jobs: $all_jobs");
    List<JobModel> data = all_jobs[selected.email] ?? [];
    if (data.isNotEmpty) {
      print("data: ${data.first.toJson()}");
    }
    if (type == 0) {
      return buildHomeworkList(data);
    } else if (type == 1) {
      return buildWorkList(data);
    } else if (type == 2) {
      return buildSportList(data);
    } else if (type == 3) {
      return buildArtList(data);
    }
    return Container();
  }

  Widget buildHomeworkList(List<JobModel> data) {
    List<JobModel> job_list = [];
    for (JobModel job in data) {
      if (job.type == WORK_TYPES[0] &&
          (_range.isEmpty
              ? isInMonth(job.date, _currentDate)
              : isInRange(job.date, DateRange(_range.first, _range.last)))) {
        job_list.add(job);
      }
    }
    return ListView.builder(
      itemCount: job_list.length,
      itemBuilder: (context, index) {
        JobModel job = job_list[index];
        return buildDetailTile(context, job);
      },
    );
  }

  Widget buildWorkList(List<JobModel> data) {
    List<JobModel> job_list = [];
    for (JobModel job in data) {
      if (job.type == WORK_TYPES[1] &&
          (_range.isEmpty
              ? isInMonth(job.date, _currentDate)
              : isInRange(job.date, DateRange(_range.first, _range.last)))) {
        job_list.add(job);
      }
    }
    return ListView.builder(
      itemCount: job_list.length,
      itemBuilder: (context, index) {
        JobModel job = job_list[index];
        return buildDetailTile(context, job);
      },
    );
  }

  Widget buildSportList(List<JobModel> data) {
    List<JobModel> job_list = [];
    for (JobModel job in data) {
      if (job.type == WORK_TYPES[2] &&
          (_range.isEmpty
              ? isInMonth(job.date, _currentDate)
              : isInRange(job.date, DateRange(_range.first, _range.last)))) {
        job_list.add(job);
      }
    }
    return ListView.builder(
      itemCount: job_list.length,
      itemBuilder: (context, index) {
        JobModel job = job_list[index];
        return buildDetailTile(context, job);
      },
    );
  }

  Widget buildArtList(List<JobModel> data) {
    List<JobModel> job_list = [];
    for (JobModel job in data) {
      if (job.type == WORK_TYPES[3] &&
          (_range.isEmpty
              ? isInMonth(job.date, _currentDate)
              : isInRange(job.date, DateRange(_range.first, _range.last)))) {
        job_list.add(job);
      }
    }
    return ListView.builder(
      itemCount: job_list.length,
      itemBuilder: (context, index) {
        JobModel job = job_list[index];
        return buildDetailTile(context, job);
      },
    );
  }

  Widget buildDetailTile(BuildContext context, JobModel job) {
    return ListTile(
      title: Row(
        children: [
          Text(getShortDate(job.date)),
          SizedBox(width: 10),
          Text(job.note),
        ],
      ),
      subtitle: Row(
        children: [
          Image.asset("assets/images/coin.png", width: 20),
          SizedBox(width: 5),
          Text("${job.point}點"),
        ],
      ),
      leading: Checkbox(
        onChanged: (value) {
          if (job.finish) {
            return;
          }
          showConfimationDialog(context, job);
        },
        value: job.finish,
      ),
      trailing: job.finish
          ? null
          : IconButton(
              onPressed: () {
                if (job.finish) {
                  return;
                }
                showDeleteConfimationDialog(context, job);
              },
              icon: Icon(Icons.delete, color: Colors.red)),
    );
  }

  showDeleteConfimationDialog(BuildContext context, JobModel job) {
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '刪除工作',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              '請問是否確認刪除此項工作？',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '否',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () async {
                      EasyLoading.show(status: "刪除中...");
                      await Provider.of<JobProvider>(context, listen: false)
                          .deleteJob(
                              email: selected.email,
                              type: job.type,
                              note: job.note,
                              date: job.date,
                              point: job.point);

                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                      showToast("刪除完成！");
                    },
                    child: Text(
                      '是',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }

  showConfimationDialog(BuildContext context, JobModel job) {
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '確認完成',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              '請問是否已確認完成此項工作？\n確認後將直接發放點數！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '否',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () async {
                      EasyLoading.show(status: "發放點數中...");
                      await Provider.of<JobProvider>(context, listen: false)
                          .finishJob(
                              email: selected.email,
                              type: job.type,
                              note: job.note,
                              date: job.date,
                              point: job.point);
                      await Provider.of<PointProvider>(context, listen: false)
                          .changePoint(
                              email: selected.email,
                              type: job.type,
                              note: job.note,
                              point: job.point);
                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                      showToast("發放點數完成！");
                    },
                    child: Text(
                      '是',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      context: context,
    );
  }
}
