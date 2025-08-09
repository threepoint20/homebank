// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/pages/auth/login_email_page.dart';
import 'package:homebank/pages/parent/account_page.dart';
import 'package:homebank/pages/parent/statistics_page.dart';
import 'package:homebank/widgets/large_button.dart';

class ManagementPage extends StatelessWidget {
  // 修正: 將 Key key 參數改為 super.key
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的')),
      body: Container(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  navegateFadein(context, const AccountPage()),
                );
              },
              leading: Image.asset("assets/images/personal.png", width: 20),
              title: Text("帳號管理"),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  navegateFadein(context, const StatisticsPage()),
                );
              },
              leading: Image.asset("assets/images/data.png", width: 20),
              title: Text("統計資料"),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(30),
              child: LargeButton(
                onTap: () {
                  _showSignoutConfimationDialog(context);
                },
                title: "登出",
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 修正: 將函式改為 private，並將 showDialog 語法調整
  void _showSignoutConfimationDialog(BuildContext context) {
    showDialog(
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
            const Text(
              '確認登出',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15.0),
            const Text(
              '是否確認要登出？',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
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
                SizedBox(
                  width: 50.0,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await FirebaseAuth.instance.signOut();
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginEmailPage(),
                        ),
                      );
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
