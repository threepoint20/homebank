import 'package:flutter/material.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/parent/transfer_confirm.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class TransferPage extends StatelessWidget {
  TransferPage({Key key}) : super(key: key);
  TextEditingController pointCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  String sourceAccount = "";
  String targetAccount = "";

  @override
  Widget build(BuildContext context) {
    UserModel currentUser =
        Provider.of<AuthProvider>(context, listen: true).user;
    List<UserModel> children =
        Provider.of<AuthProvider>(context, listen: true).children;
    if (sourceAccount.isEmpty) {
      sourceAccount = currentUser.email;
    }
    if (targetAccount.isEmpty && children.isNotEmpty) {
      targetAccount = children.first.email;
    }
    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(
            title: Text('轉帳'),
          ),
          body: Container(
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset("assets/images/img_piggy_transfer.png",
                        height: 100),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        prefix: Text("轉出帳號："),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: sourceAccount,
                          items: [
                            DropdownMenuItem(
                              value: currentUser.email,
                              child: Text(currentUser.name),
                            ),
                          ],
                          onChanged: (value) {
                            sourceAccount = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: Divider(),
                        ),
                        Text("轉給"),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 70,
                          child: Divider(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        prefix: Text("轉入帳號："),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: targetAccount,
                          items: children
                              .map((user) => DropdownMenuItem(
                                  child: Text(user.name), value: user.email))
                              .toList(),
                          onChanged: (value) {
                            setState(
                              () {
                                targetAccount = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomInput(
                    hintText: "轉入點數",
                    kyboardType: TextInputType.number,
                    textEditingController: pointCtrl,
                    validator: (String val) {
                      if (val.trim().isEmpty) {
                        return "請輸入點數";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomInput(
                    hintText: "註記",
                    kyboardType: TextInputType.text,
                    textEditingController: noteCtrl,
                  ),
                  SizedBox(height: 20),
                  LargeButton(
                    onTap: () {
                      int point = int.tryParse(pointCtrl.text) ?? 0;
                      String note = noteCtrl.text;
                      Navigator.push(
                          context,
                          navegateFadein(
                              context,
                              TransferConfirmPage(
                                  email: targetAccount,
                                  point: point,
                                  note: note)));
                    },
                    title: "下一步",
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
