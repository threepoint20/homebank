// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/pages/parent/work_add_page.dart';
import 'package:homebank/pages/parent/work_detail_page.dart';
import 'package:homebank/widgets/large_button.dart';

class WorkPage extends StatelessWidget {
  // 修正: 將 Key key 參數改為 super.key
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('工作項目')),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                crossAxisCount: 2,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        navegateFadein(context, const WorkDetailPage(type: 0)),
                      ); // 修正: 加上 const
                    },
                    child: Image.asset("assets/images/category_1.png"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        navegateFadein(context, const WorkDetailPage(type: 1)),
                      ); // 修正: 加上 const
                    },
                    child: Image.asset("assets/images/category_2.png"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        navegateFadein(context, const WorkDetailPage(type: 2)),
                      ); // 修正: 加上 const
                    },
                    child: Image.asset("assets/images/category_3.png"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        navegateFadein(context, const WorkDetailPage(type: 3)),
                      ); // 修正: 加上 const
                    },
                    child: Image.asset("assets/images/category_4.png"),
                  ),
                ],
                childAspectRatio: 1,
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(30),
              child: LargeButton(
                onTap: () {
                  Navigator.push(
                    context,
                    navegateFadein(context, const WorkAddPage()),
                  ); // 修正: 加上 const
                },
                title: "新增工作",
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
