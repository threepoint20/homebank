// Who knows? Not me,
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/helpers/show_alert.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/home_page.dart';
import 'package:homebank/providers/auth.dart';
//me
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/labels.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key}); // 修正: 加上 const 和 super.key
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    // double _height = MediaQuery.of(context).size.height; // 修正: 未使用的變數
    return Scaffold(
      appBar: AppBar(title: Text("註冊")),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: const _Form(), // 修正: 加上 const
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
  bool _obscurePassword = true;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final passwordConfirmCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "使用者名稱",
              style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
            ),
          ),
          CustomInput(
            hintText: "使用者名稱", // 修正: 加上 hintText
            icon: Icons.person_outline, // 修正: 加上 icon
            kyboardType: TextInputType.text,
            textEditingController: userNameCtrl,
            textCapitalization: TextCapitalization.sentences,
            validator: (String? val) {
              // 修正: 將 val 設為可空
              if (val?.trim().isEmpty ?? true) {
                // 修正: 進行空值檢查
                return 'name_required'.tr();
              }
              if ((val?.length ?? 0) < 2) {
                // 修正: 進行空值檢查
                return 'valid_name'.tr();
              }
              return null;
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "帳號（請輸入Email）",
              style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
            ),
          ),
          CustomInput(
            hintText: "帳號（請輸入Email）", // 修正: 加上 hintText
            icon: Icons.email_outlined, // 修正: 加上 icon
            kyboardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
            validator: (String? val) {
              // 修正: 將 val 設為可空
              if (val?.trim().isEmpty ?? true) {
                // 修正: 進行空值檢查
                return 'email_required'.tr();
              }
              if (!RegExp(
                r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
              ).hasMatch(val ?? "")) {
                // 修正: 進行空值檢查
                return 'valid_email'.tr();
              }
              return null;
            },
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "密碼",
              style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
            ),
          ),
          CustomInput(
            hintText: "密碼", // 修正: 加上 hintText
            icon: Icons.lock_outline, // 修正: 加上 icon
            kyboardType: TextInputType.text,
            textEditingController: passwordCtrl,
            isPassword: _obscurePassword,
            validator: (String? val) {
              // 修正: 將 val 設為可空
              if (val?.trim().isEmpty ?? true) {
                // 修正: 進行空值檢查
                return 'password_required'.tr();
              }
              if ((val?.length ?? 0) < 6) {
                // 修正: 進行空值檢查
                return 'valid_password'.tr();
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: _obscurePassword
                  ? Icon(Icons.remove_red_eye_outlined)
                  : Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword; // 修正: 使用 ! 運算符
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "再次確認密碼",
              style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
            ),
          ),
          CustomInput(
            hintText: "再次確認密碼", // 修正: 加上 hintText
            icon: Icons.lock_outline, // 修正: 加上 icon
            kyboardType: TextInputType.text,
            textEditingController: passwordConfirmCtrl,
            isPassword: _obscurePassword,
            validator: (String? val) {
              // 修正: 將 val 設為可空
              if (val?.trim().isEmpty ?? true) {
                // 修正: 進行空值檢查
                return 'password_required'.tr();
              }
              if ((val?.length ?? 0) < 6) {
                // 修正: 進行空值檢查
                return 'valid_password'.tr();
              }
              print("val: $val, passwordCtrl.text: ${passwordCtrl.text}");
              if (val != passwordCtrl.text) {
                return "密碼不匹配";
              }
              return null;
            },
          ),
          Expanded(child: Container()),
          LargeButton(
            onTap: () async {
              if (_formKey.currentState?.validate() ?? false) {
                // 修正: 使用 ?. 進行空值檢查
                _formKey.currentState?.save(); // 修正: 使用 ?. 進行空值檢查
                print(emailCtrl.text);
                await EasyLoading.show(status: "註冊中...");
                try {
                  await Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).signUpWithEmail(
                    userName: userNameCtrl.text,
                    email: emailCtrl.text,
                    password: passwordCtrl.text,
                  );
                  Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).listenToChildren(emailCtrl.text);
                  UserModel currentUser = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).user;
                  if (currentUser.isParent()) {
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).listenChildrenJobs(emailCtrl.text);
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).listenChildrenPoints(emailCtrl.text);
                  } else {
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).listenToJobs(emailCtrl.text);
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).listenToPoints(emailCtrl.text);
                  }
                  Navigator.pushReplacement(
                    context,
                    navegateFadein(context, const HomePage()),
                  );
                } catch (e) {
                  // 修正: 檢查 e 是否為 FirebaseException 或其他錯誤類型
                  if (e is Exception) {
                    showErrorToast(e.toString());
                  } else {
                    showErrorToast("註冊失敗！");
                  }
                } finally {
                  await EasyLoading.dismiss();
                }
              }
            },
            title: 'register_label'.tr(),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
