// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/job.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkAddPage extends StatefulWidget {
  const WorkAddPage({Key? key}) : super(key: key);

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
    // 移除 currentUser 變數
    final List<UserModel> children = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).children;
    selectedChild ??= children.isNotEmpty ? children.first.email : null;
    selectedJob ??= WORK_TYPES.isNotEmpty ? WORK_TYPES.first : null;
    selectedDateController.text = getDateString(
      selectedDate.whereType<DateTime>().toList(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('新增工作')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/img_piggy_add_task.png", height: 100),
              const SizedBox(height: 20),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: selectedDateController,
                autocorrect: false,
                style: TextStyle(color: Theme.of(context).primaryColor),
                readOnly: true,
                onTap: () async {
                  final config = CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.multi,
                    selectedDayHighlightColor: Colors.purple[800],
                    closeDialogOnCancelTapped: true,
                  );
                  final List<DateTime?>? picked =
                      await showCalendarDatePicker2Dialog(
                    context: context,
                    config: config,
                    dialogSize: const Size(325, 400),
                    borderRadius: BorderRadius.circular(15),
                    value: selectedDate,
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
                },
                decoration: const InputDecoration(
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
              const SizedBox(height: 20),
              InputDecorator(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  prefixText: "指派對象：",
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    value: selectedChild,
                    items: children
                        .map(
                          (user) => DropdownMenuItem(
                            value: user.email,
                            child: Text(user.name),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedChild = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InputDecorator(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  prefixText: "工作類別：",
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    value: selectedJob,
                    items: WORK_TYPES
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedJob = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomInput(
                hintText: "工作名稱",
                icon: Icons.work_outline,
                kyboardType: TextInputType.text,
                textEditingController: noteCtrl,
              ),
              const SizedBox(height: 20),
              CustomInput(
                hintText: "可獲得點數",
                icon: Icons.monetization_on,
                kyboardType: TextInputType.number,
                textEditingController: pointCtrl,
              ),
              const SizedBox(height: 20),
              LargeButton(
                onTap: () async {
                  final String? email = selectedChild;
                  final String? type = selectedJob;
                  final String note = noteCtrl.text;
                  final int point = int.tryParse(pointCtrl.text) ?? 0;

                  if (email == null || type == null) {
                    showToast("請選擇指派對象和工作類別");
                    return;
                  }

                  if (point <= 0) {
                    showToast("點數必須大於 0");
                    return;
                  }

                  EasyLoading.show(status: "新增工作...");
                  try {
                    for (final DateTime? date in selectedDate) {
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
                    showToast("新增工作完成！");
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                    showErrorToast("新增工作失敗！\n$e");
                  } finally {
                    await EasyLoading.dismiss();
                  }
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
