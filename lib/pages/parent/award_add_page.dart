// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/point.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class AwardAddPage extends StatefulWidget {
  const AwardAddPage({super.key});

  @override
  State<AwardAddPage> createState() => _AwardAddPageState();
}

class _AwardAddPageState extends State<AwardAddPage> {
  final TextEditingController pointCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();
  String? selectedChild;
  final TextEditingController selectedDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

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
    selectedDateController.text = getDateString([selectedDate]);
    return Scaffold(
      appBar: AppBar(title: Text('新增獎勵')),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/img_piggy_add_award.png", height: 100),
              SizedBox(height: 20),
              // StatefulBuilder 被移除
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
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        selectedDateController.text = getDateString([picked]);
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
                        setState(() {
                          selectedChild = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomInput(
                hintText: "獎勵名稱",
                icon: Icons.card_giftcard,
                kyboardType: TextInputType.text,
                textEditingController: noteCtrl,
              ),
              SizedBox(height: 20),
              CustomInput(
                hintText: "兌換需要點數",
                icon: Icons.monetization_on,
                kyboardType: TextInputType.number,
                textEditingController: pointCtrl,
              ),
              SizedBox(height: 20),
              LargeButton(
                onTap: () async {
                  await _showConfimationDialog(context);
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

  Future<void> _showConfimationDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 20.0,
          bottom: 10.0,
        ),
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
            SizedBox(height: 15.0),
            Text(
              '是否要兌換獎勵？\n確認後將直接扣除點數！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5.0),
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
                      EasyLoading.show(status: "扣除點數中...");
                      int point = int.tryParse(pointCtrl.text) ?? 0;
                      await Provider.of<PointProvider>(
                        context,
                        listen: false,
                      ).changePoint(
                        email: selectedChild!,
                        type: "兌換獎勵",
                        note: noteCtrl.text,
                        point: -point,
                      );
                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                      showToast("扣除點數完成！");
                      Navigator.of(context).pop();
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
    );
  }
}
