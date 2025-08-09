// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/helpers/show_alert.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/parent/work_add_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

class MemberModifyPage extends StatefulWidget {
  const MemberModifyPage({super.key}); // 修正: 加上 const 和 super.key
  @override
  State<StatefulWidget> createState() => _MemberModifyPageState();
}

class _MemberModifyPageState extends State<MemberModifyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('編輯帳號')),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
  final passwordOrigCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final passwordConfirmCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();
  String? svgCode; // 修正: 設為可空
  UserModel? currentUser; // 修正: 設為可空

  @override
  void initState() {
    super.initState();
    // 修正: 移除在 initState 中直接初始化，改在 build 方法中處理
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<AuthProvider>(context, listen: true).user;
    if (svgCode == null || svgCode!.isEmpty) {
      svgCode = currentUser!.avatarSvg;
      emailCtrl.text = currentUser!.email;
      userNameCtrl.text = currentUser!.name;
    }
    return Form(
      key: _formKey,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 5),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        generateAvatar();
                        setState(() {});
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        child: SvgPicture.string(svgCode ?? ""), // 修正: 加上空值檢查
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  "使用者名稱",
                  style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
                ),
              ),
              CustomInput(
                hintText: "使用者名稱",
                icon: Icons.person_outline,
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
                  "帳號（不可修改）",
                  style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
                ),
              ),
              CustomInput(
                hintText: "帳號（不可修改）",
                icon: Icons.email_outlined,
                kyboardType: TextInputType.emailAddress,
                textEditingController: emailCtrl,
                readOnly: true,
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
                  "舊密碼",
                  style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
                ),
              ),
              CustomInput(
                hintText: "舊密碼",
                icon: Icons.lock_outline,
                kyboardType: TextInputType.text,
                textEditingController: passwordOrigCtrl,
                isPassword: _obscurePassword,
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
                  "新密碼",
                  style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
                ),
              ),
              CustomInput(
                hintText: "新密碼",
                icon: Icons.lock_outline,
                kyboardType: TextInputType.text,
                textEditingController: passwordCtrl,
                isPassword: _obscurePassword,
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
                  "再次確認新密碼",
                  style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
                ),
              ),
              CustomInput(
                hintText: "再次確認新密碼",
                icon: Icons.lock_outline,
                kyboardType: TextInputType.text,
                textEditingController: passwordConfirmCtrl,
                isPassword: _obscurePassword,
              ),
              SizedBox(height: 50),
              LargeButton(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // 修正: 使用 ?. 進行空值檢查
                    _formKey.currentState?.save(); // 修正: 使用 ?. 進行空值檢查
                    print(emailCtrl.text);
                    await EasyLoading.show(status: "修改帳號中...");
                    try {
                      if (passwordOrigCtrl.text.isNotEmpty) {
                        if (passwordCtrl.text != passwordConfirmCtrl.text) {
                          showToast("密碼不匹配！");
                          return;
                        }
                        String email = emailCtrl.text;
                        String orig_password = passwordOrigCtrl.text;
                        String new_password = passwordCtrl.text;
                        UserCredential user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email,
                              password: orig_password,
                            );
                        await user.user!.updatePassword(
                          new_password,
                        ); // 修正: 加上 !
                      }
                      await Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).modifyAccount(
                        email: emailCtrl.text,
                        userName: userNameCtrl.text,
                        birthday: currentUser?.birthday ?? "", // 修正: 加上空值檢查
                        svgCode: svgCode ?? "",
                      ); // 修正: 加上空值檢查
                      showToast("帳號修改成功！");
                      Navigator.of(context).pop();
                    } catch (e) {
                      print(e);
                      // 修正: 檢查 e 是否為 FirebaseException 或其他錯誤類型
                      if (e is Exception) {
                        showErrorToast("帳號修改失敗！\n$e");
                      } else {
                        showErrorToast("帳號修改失敗！\n未知錯誤");
                      }
                    } finally {
                      await EasyLoading.dismiss();
                    }
                  }
                },
                title: "修改",
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void generateAvatar() {
    setState(() {
      // 修正: 呼叫 setState 才會更新 UI
      svgCode = randomAvatarString(
        DateTime.now().millisecondsSinceEpoch.toRadixString(16),
      );
    });
  }
}
