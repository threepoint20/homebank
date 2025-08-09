// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/children/my_award_page.dart';
import 'package:homebank/pages/children/my_detail_page.dart';
import 'package:homebank/pages/children/my_home_page.dart';
import 'package:homebank/pages/children/my_management_page.dart';
import 'package:homebank/pages/children/my_statistics_page.dart';
import 'package:homebank/pages/children/my_works_page.dart';
import 'package:homebank/pages/parent/detail_page.dart';
import 'package:homebank/pages/parent/award_page.dart';
import 'package:homebank/pages/parent/management_page.dart';
import 'package:homebank/pages/parent/transfer_page.dart';
import 'package:homebank/pages/parent/work_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // 修正: 將 Key key 參數改為 super.key
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 修正: 移除 UserModel user;，並直接在 build 方法中取得 Provider 的 user
  int currentTab = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 修正: 使用 Provider.of 取得 UserModel，並確保它不為 null
    final user = Provider.of<AuthProvider>(context, listen: true).user;
    return Scaffold(
      bottomNavigationBar: user.isParent()
          ? buildParentNavigetionBar(context)
          : buildChildrenNavigetionBar(context),
      body: user.isParent()
          ? buildParentTabs(currentTab)
          : buildChildrenTabs(currentTab),
    );
  }

  Widget buildParentTabs(int currentTab) {
    switch (currentTab) {
      case 0:
        return ManagementPage();
      case 1:
        return WorkPage();
      case 2:
        return TransferPage();
      case 3:
        return DetailPage();
      case 4:
        return AwardPage();
      default:
        return DetailPage();
    }
  }

  Widget buildParentNavigetionBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: currentTab,
      iconSize: 25,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.white,
      elevation: 1.0,
      selectedIconTheme: IconThemeData(size: 25),
      onTap: (index) {
        setState(() {
          currentTab = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/personal.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/personal.png", width: 22),
          label: '我的',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/work.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/work.png", width: 22),
          label: '工作項目',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/transfer.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/transfer.png", width: 22),
          label: '轉帳',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/detail.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/detail.png", width: 22),
          label: '查詢明細',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/award.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/award.png", width: 22),
          label: '獎勵專區',
        ),
      ],
    );
  }

  Widget buildChildrenTabs(int currentTab) {
    switch (currentTab) {
      case 0:
        return MyManagementPage();
      case 1:
        return MyWorksPage();
      case 2:
        return MyHomePage();
      case 3:
        return MyDetailPage();
      case 4:
        return MyAwardPage();
      default:
        return MyHomePage();
    }
  }

  Widget buildChildrenNavigetionBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: currentTab,
      iconSize: 25,
      unselectedItemColor: Colors.black54,
      backgroundColor: Colors.white,
      elevation: 1.0,
      selectedIconTheme: IconThemeData(size: 25),
      onTap: (index) {
        setState(() {
          currentTab = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/personal.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/personal.png", width: 22),
          label: '統計資料',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/work.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/work.png", width: 22),
          label: '工作項目',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/home.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/home.png", width: 22),
          label: '首頁',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/detail.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/detail.png", width: 22),
          label: '查詢明細',
        ),
        BottomNavigationBarItem(
          activeIcon: Image.asset(
            "assets/images/myaward.png",
            width: 22,
            color: Theme.of(context).primaryColor,
          ),
          icon: Image.asset("assets/images/myaward.png", width: 22),
          label: '我的徽章',
        ),
      ],
    );
  }
}
