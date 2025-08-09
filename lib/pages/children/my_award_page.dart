import 'package:flutter/material.dart';

class MyAwardPage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const MyAwardPage({super.key});

  @override
  State<MyAwardPage> createState() => _MyAwardPageState();
}

class _MyAwardPageState extends State<MyAwardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的徽章')),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black12),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0), //                 <--- border radius here
              ),
            ),
            /*child: ListTile(
              title: Text("3週連續完成紀錄"),
              subtitle: Text("12次・2022/10/15"),
              trailing: Image.asset("assets/images/award_3.png"),
            ),*/
          ),
        ],
      ),
    );
  }
}
