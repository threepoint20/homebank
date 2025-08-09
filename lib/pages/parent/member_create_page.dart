// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
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

class MemberCreatePage extends StatefulWidget {
  const MemberCreatePage({super.key}); // 修正: 加上 const 和 super.key
  @override
  State<StatefulWidget> createState() => _MemberCreatePageState();
}

class _MemberCreatePageState extends State<MemberCreatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新增成員')),
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
  final passwordCtrl = TextEditingController();
  final passwordConfirmCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  List<DateTime?> selectedDate = [DateTime.now()]; // 修正: 設為可空
  String? svgCode; // 修正: 設為可空

  @override
  void initState() {
    super.initState();
    generateAvatar();
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).user;
    return Form(
      key: _formKey,
      child: Container(
        child: ListView(
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
                // 修正: 設為可空
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
              hintText: "帳號（請輸入Email）",
              icon: Icons.email_outlined,
              kyboardType: TextInputType.emailAddress,
              textEditingController: emailCtrl,
              validator: (String? val) {
                // 修正: 設為可空
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
              hintText: "密碼",
              icon: Icons.lock_outline,
              kyboardType: TextInputType.text,
              textEditingController: passwordCtrl,
              isPassword: _obscurePassword,
              validator: (String? val) {
                // 修正: 設為可空
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
              hintText: "再次確認密碼",
              icon: Icons.lock_outline,
              kyboardType: TextInputType.text,
              textEditingController: passwordConfirmCtrl,
              isPassword: _obscurePassword,
              validator: (String? val) {
                // 修正: 設為可空
                if (val?.trim().isEmpty ?? true) {
                  // 修正: 進行空值檢查
                  return 'password_required'.tr();
                }
                if ((val?.length ?? 0) < 6) {
                  // 修正: 進行空值檢查
                  return 'valid_password'.tr();
                }
                if (val != passwordCtrl.text) {
                  return "密碼不匹配";
                }
                return null;
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "生日",
                style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFEEF4FC),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                controller: birthdayCtrl,
                autocorrect: false,
                style: TextStyle(color: Theme.of(context).primaryColor),
                readOnly: true,
                onTap: (() async {
                  final config = CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.single,
                    selectedDayHighlightColor: Colors.purple[800],
                    closeDialogOnCancelTapped: true,
                  );
                  List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
                    // 修正: 變數改為可空
                    context: context,
                    config: config,
                    dialogSize: const Size(325, 400),
                    borderRadius: BorderRadius.circular(15),
                    value: selectedDate, // 修正: 將 initialValue 改為 value
                    dialogBackgroundColor: Colors.white,
                  );
                  if (picked != null && picked.isNotEmpty) {
                    // 修正: 進行空值檢查
                    setState(() {
                      selectedDate = picked;
                      birthdayCtrl.text = getDateString(
                        selectedDate.whereType<DateTime>().toList(),
                      ); // 修正: 處理可空列表
                    });
                  }
                }),
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.black45),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1, color: Colors.black45),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            LargeButton(
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // 修正: 進行空值檢查
                  _formKey.currentState?.save(); // 修正: 進行空值檢查
                  print(emailCtrl.text);
                  await EasyLoading.show(status: "新增帳號中...");
                  try {
                    await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).createAccount(
                      userName: userNameCtrl.text,
                      email: emailCtrl.text,
                      password: passwordCtrl.text,
                      parent: currentUser.email,
                      birthday: birthdayCtrl.text,
                      svgCode: svgCode ?? "",
                    ); // 修正: 加上空值檢查
                    showToast("帳號新增成功！");
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                    // 修正: 檢查 e 是否為 FirebaseException 或其他錯誤類型
                    if (e is Exception) {
                      showErrorToast("帳號新增失敗！\n$e");
                    } else {
                      showErrorToast("帳號新增失敗！\n未知錯誤");
                    }
                  } finally {
                    await EasyLoading.dismiss();
                  }
                }
              },
              title: "新增",
            ),
            SizedBox(height: 50),
          ],
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
