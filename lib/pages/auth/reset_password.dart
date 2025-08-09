// Who knows? Not me,
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/helpers/show_alert.dart';
import 'package:homebank/widgets/custom_input.dart';
//me
import 'package:homebank/widgets/labels.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:homebank/widgets/logo.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key}); // 修正: 加上 const 和 super.key
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // 修正: _scaffoldKey 應為 final
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // 修正: _height 變數未被使用
    // double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("忘記密碼")),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  height: MediaQuery.of(context).size.height, // 修正: 直接使用
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      const _Form(), // 修正: 加上 const
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key}); // 修正: 加上 const 和 super.key
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController(); // 修正: 未使用

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "忘記密碼？",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "輸入您的註冊信箱以重設密碼",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomInput(
              icon: Icons.email,
              hintText: 'email_hint'.tr(),
              kyboardType: TextInputType.emailAddress,
              textEditingController: emailCtrl,
              validator: (String? val) {
                // 修正: 參數設為可空
                if (val?.trim().isEmpty ?? true) {
                  // 修正: 加上空值檢查
                  return 'email_required'.tr();
                }
                if (!RegExp(
                  r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
                ).hasMatch(val ?? "")) {
                  // 修正: 加上空值檢查
                  return 'valid_email'.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            LargeButton(
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // 修正: 加上空值檢查
                  _formKey.currentState?.save(); // 修正: 加上空值檢查
                  EasyLoading.show();
                  bool ret = await resetEmail(emailCtrl.text);
                  EasyLoading.dismiss();
                  if (ret) {
                    showToast("密碼重設郵件已送出！");
                    Navigator.of(context).pop();
                  } else {
                    showToast("密碼重設失敗，此Email尚未註冊！");
                  }
                }
              },
              title: "送出",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<bool> resetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // 修正: 捕捉 FirebaseAuthException
      print(e);
      return false;
    }
    return true;
  }
}
