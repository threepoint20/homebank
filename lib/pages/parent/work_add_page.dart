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

class WorkAddPage extends StatelessWidget {
  WorkAddPage({Key key}) : super(key: key);
  TextEditingController pointCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  String selectedChild = "";
  String selectedJob = "";
  TextEditingController selectedDateController = TextEditingController();
  List<DateTime> selectedDate = [DateTime.now()];

  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        Provider.of<AuthProvider>(context, listen: true).user;
    List<UserModel> children =
        Provider.of<AuthProvider>(context, listen: true).children;
    if (selectedChild.isEmpty && children.isNotEmpty) {
      selectedChild = children.first.email;
    }
    if (selectedJob.isEmpty) {
      selectedJob = WORK_TYPES.first;
    }
    selectedDateController.text = getDateString(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('新增工作'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/img_piggy_add_task.png", height: 100),
              SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setState) {
                  return Container(
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
                        final config =
                            CalendarDatePicker2WithActionButtonsConfig(
                          calendarType: CalendarDatePicker2Type.multi,
                          selectedDayHighlightColor: Colors.purple[800],
                          closeDialogOnCancelTapped: true,
                        );
                        List<DateTime> picked =
                            await showCalendarDatePicker2Dialog(
                          context: context,
                          config: config,
                          dialogSize: const Size(325, 400),
                          borderRadius: BorderRadius.circular(15),
                          initialValue: selectedDate,
                          dialogBackgroundColor: Colors.white,
                          selectableDayPredicate: (day) => !day
                              .difference(selectedDate[0]
                                  .subtract(const Duration(days: 5)))
                              .isNegative,
                        );
                        if (picked.isNotEmpty) {
                          setState(
                            () {
                              selectedDate = picked;
                              selectedDateController.text =
                                  getDateString(picked);
                            },
                          );
                        }
                      }),
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: "日期：",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.black45),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setState) {
                  return Container(
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
                              .map((user) => DropdownMenuItem(
                                  child: Text(user.name), value: user.email))
                              .toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                selectedChild = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              StatefulBuilder(
                builder: (context, setState) {
                  return Container(
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
                              .map((e) =>
                                  DropdownMenuItem(child: Text(e), value: e))
                              .toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                selectedJob = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              CustomInput(
                hintText: "工作名稱",
                kyboardType: TextInputType.text,
                textEditingController: noteCtrl,
              ),
              SizedBox(height: 20),
              CustomInput(
                hintText: "可獲得點數",
                kyboardType: TextInputType.number,
                textEditingController: pointCtrl,
              ),
              SizedBox(height: 20),
              LargeButton(
                onTap: () async {
                  String email = selectedChild;
                  String type = selectedJob;
                  String note = noteCtrl.text;
                  selectedDate;
                  int point = int.tryParse(pointCtrl.text) ?? 0;
                  EasyLoading.show(status: "新增工作...");
                  for (DateTime date in selectedDate) {
                    await Provider.of<JobProvider>(context, listen: false)
                        .createJob(
                            email: email,
                            type: type,
                            note: note,
                            date: date,
                            point: point);
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
