// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/parent/member_create_page.dart';
import 'package:homebank/pages/parent/member_modify_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  AccountPage({Key key}) : super(key: key);
  UserModel currentUser;
  List<UserModel> children;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<AuthProvider>(context, listen: true).user;
    children = Provider.of<AuthProvider>(context, listen: true).children;
    return Scaffold(
      appBar: AppBar(
        title: Text('帳號管理'),
      ),
      body: SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      UserModel child = children[index];
                      return ListTile(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              navegateFadein(
                                  context, MemberModifyPage(user: child)));
                          setState(
                            () {},
                          );
                        },
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: SvgPicture.string(child.avatarSvg),
                        ),
                        title: Text(child.name),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: LargeButton(
                    onTap: () async {
                      await Navigator.push(
                          context, navegateFadein(context, MemberCreatePage()));
                      setState(
                        () {},
                      );
                    },
                    title: "新增成員",
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
