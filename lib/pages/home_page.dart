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
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: true).user;

    // 修正: 移除這段永遠為真的判斷，因為 user.name 的預設值為空
    // if (user.name.isEmpty) {
    //   return const Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

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
        return const ManagementPage();
      case 1:
        return const WorkPage();
      case 2:
        return const TransferPage();
      case 3:
        return const DetailPage();
      case 4:
        return const AwardPage();
      default:
        return const DetailPage();
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
        return const MyManagementPage();
      case 1:
        return const MyWorksPage();
      case 2:
        return const MyHomePage();
      case 3:
        return const MyDetailPage();
      case 4:
        return const MyAwardPage();
      default:
        return const MyHomePage();
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
