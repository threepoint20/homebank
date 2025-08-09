// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/point.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class TransferConfirmPage extends StatelessWidget {
  final String email;
  final int point;
  final String note;
  // 修正: 使用 super.key 和 required 關鍵字
  TransferConfirmPage({
    super.key,
    required this.email,
    required this.point,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).user;
    return Scaffold(
      appBar: AppBar(title: Text('轉帳確認')),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/images/img_piggy_transfer.png",
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            Text("轉出帳號", style: TextStyle(color: Colors.black54)),
            Text(currentUser.email),
            SizedBox(height: 20),
            Text("轉入帳號", style: TextStyle(color: Colors.black54)),
            Text(email),
            SizedBox(height: 20),
            Text("轉入點數", style: TextStyle(color: Colors.black54)),
            Text("$point"),
            SizedBox(height: 20),
            Text("備註", style: TextStyle(color: Colors.black54)),
            Text(note),
            Expanded(child: Container()),
            LargeButton(
              onTap: () async {
                EasyLoading.show(status: "轉帳中");
                await Provider.of<PointProvider>(
                  context,
                  listen: false,
                ).changePoint(email: email, type: "", note: note, point: point);
                EasyLoading.dismiss();
                showToast("轉帳成功！");
                Navigator.of(context).pop();
              },
              title: "確認",
              fontSize: 16,
            ),
            SizedBox(height: 15),
            LargeButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              title: "取消",
              fontSize: 16,
              light: true,
            ),
          ],
        ),
      ),
    );
  }
}
