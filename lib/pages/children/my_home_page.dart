// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/models/job.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/auth/login_email_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // 修正: 僅在 build 方法中獲取一次 currentUser
    final UserModel currentUser = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).user;
    return Scaffold(
      appBar: AppBar(title: Text('首頁')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).primaryColorLight,
              child: Card(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/img_piggy_your_coin.png",
                        width: 90,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi! ${currentUser.name}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 3),
                          Text("你的點數", style: TextStyle(fontSize: 14)),
                          SizedBox(height: 10),
                          Text(
                            "\$${currentUser.point}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "待完成的工作",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: buildList(currentUser), // 修正: 將 currentUser 傳入
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 修正: 接收 currentUser 作為參數
  Widget buildList(UserModel currentUser) {
    Map<String, dynamic> all_jobs = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).jobs;
    print("all_jobs: $all_jobs");
    List<JobModel> _data = all_jobs[currentUser.email] ?? [];
    List<JobModel> data = _data.where((job) => job.finish == false).toList();
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return buildDetailTile(
          getShortDate(data[index].date),
          data[index].type,
          data[index].note,
          data[index].point,
        );
      },
    );
  }

  Widget buildDetailTile(String date, String type, String detail, int point) {
    return ListTile(
      title: Row(
        children: [
          Text(date, style: TextStyle(color: Colors.black87, fontSize: 14)),
          SizedBox(width: 20),
          Text(type, style: TextStyle(color: getTypeColor(type), fontSize: 14)),
        ],
      ),
      subtitle: Text(
        detail,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      trailing: SizedBox(
        width: 70,
        child: Row(
          children: [
            Image.asset("assets/images/coin.png", width: 20),
            Text("  $point點"),
          ],
        ),
      ),
    );
  }
}
