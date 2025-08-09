// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/job.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class WorkAddPage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const WorkAddPage({super.key});

  @override
  State<WorkAddPage> createState() => _WorkAddPageState();
}

class _WorkAddPageState extends State<WorkAddPage> {
  final TextEditingController pointCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  String? selectedChild;
  String? selectedJob;
  final TextEditingController selectedDateController = TextEditingController();
  List<DateTime?> selectedDate = [DateTime.now()];

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).user;
    List<UserModel> children = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).children;
    if (selectedChild == null && children.isNotEmpty) {
      selectedChild = children.first.email;
    }
    if (selectedJob == null) {
      selectedJob = WORK_TYPES.first;
    }
    selectedDateController.text = getDateString(
      selectedDate.whereType<DateTime>().toList(),
    ); // 修正: 處理可空列表
    return Scaffold(
      appBar: AppBar(title: Text('新增工作')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/img_piggy_add_task.png", height: 100),
              SizedBox(height: 20),
              // StatefulBuilder 被移除，因為整個頁面已經是 StatefulWidget
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: selectedDateController,
                  autocorrect: false,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  readOnly: true,
                  onTap: (() async {
                    final config = CalendarDatePicker2WithActionButtonsConfig(
                      calendarType: CalendarDatePicker2Type.multi,
                      selectedDayHighlightColor: Colors.purple[800],
                      closeDialogOnCancelTapped: true,
                    );
                    List<DateTime?>? picked =
                        await showCalendarDatePicker2Dialog(
                          // 修正: 變數改為可空
                          context: context,
                          config: config,
                          dialogSize: const Size(325, 400),
                          borderRadius: BorderRadius.circular(15),
                          value: selectedDate, // 修正: 將 initialValue 改為 value
                          dialogBackgroundColor: Colors.white,
                        );
                    if (picked != null && picked.isNotEmpty) {
                      setState(() {
                        selectedDate = picked;
                        selectedDateController.text = getDateString(
                          selectedDate.whereType<DateTime>().toList(),
                        );
                      });
                    }
                  }),
                  decoration: InputDecoration(
                    isDense: true,
                    prefixText: "日期：",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // StatefulBuilder 被移除
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    prefix: Text("指派對象："),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: selectedChild,
                      items: children
                          .map(
                            (user) => DropdownMenuItem(
                              child: Text(user.name),
                              value: user.email,
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        // 修正: 參數為可空
                        setState(() {
                          selectedChild = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // StatefulBuilder 被移除
              Container(
                child: InputDecorator(
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                    prefix: Text("工作類別："),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: selectedJob,
                      items: WORK_TYPES
                          .map(
                            (e) => DropdownMenuItem(child: Text(e), value: e),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        // 修正: 參數為可空
                        setState(() {
                          selectedJob = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomInput(
                hintText: "工作名稱",
                icon: Icons.work_outline, // 修正: 加上 icon 參數
                kyboardType: TextInputType.text,
                textEditingController: noteCtrl,
              ),
              SizedBox(height: 20),
              CustomInput(
                hintText: "可獲得點數",
                icon: Icons.monetization_on, // 修正: 加上 icon 參數
                kyboardType: TextInputType.number,
                textEditingController: pointCtrl,
              ),
              SizedBox(height: 20),
              LargeButton(
                onTap: () async {
                  String? email = selectedChild;
                  String? type = selectedJob;
                  String note = noteCtrl.text;
                  int point = int.tryParse(pointCtrl.text) ?? 0;
                  EasyLoading.show(status: "新增工作...");
                  if (email != null && type != null) {
                    for (DateTime? date in selectedDate) {
                      if (date != null) {
                        await Provider.of<JobProvider>(
                          context,
                          listen: false,
                        ).createJob(
                          email: email,
                          type: type,
                          note: note,
                          date: date,
                          point: point,
                        );
                      }
                    }
                  }
                  EasyLoading.dismiss();
                  showToast("新增工作完成！");
                  Navigator.of(context).pop();
                },
                title: "新增",
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
