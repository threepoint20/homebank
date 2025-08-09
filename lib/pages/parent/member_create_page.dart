// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/common_functions.dart';
//import 'package:homebank/helpers/helpers.dart';
//import 'package:homebank/helpers/show_alert.dart';
import 'package:homebank/models/user.dart';
//import 'package:homebank/pages/parent/work_add_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class MemberCreatePage extends StatefulWidget {
  const MemberCreatePage({Key? key}) : super(key: key); // 修正: 保留 key 參數
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
      appBar: AppBar(title: const Text('新增成員')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: const _Form(),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key); // 修正: 保留 key 參數
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
  List<DateTime?> selectedDate = [DateTime.now()];
  String? svgCode;

  @override
  void initState() {
    super.initState();
    // 修正: 移除 generateAvatar() 呼叫
    svgCode = "default_avatar";
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = Provider.of<AuthProvider>(
      context,
      listen: true,
    ).user;
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // 修正: 移除 generateAvatar() 呼叫
                    setState(() {});
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    child: SvgPicture.string(svgCode ?? ""),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
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
              if (val?.trim().isEmpty ?? true) {
                return 'name_required'.tr();
              }
              if ((val?.length ?? 0) < 2) {
                return 'valid_name'.tr();
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
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
              if (val?.trim().isEmpty ?? true) {
                return 'email_required'.tr();
              }
              if (!RegExp(
                r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
              ).hasMatch(val ?? "")) {
                return 'valid_email'.tr();
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
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
              if (val?.trim().isEmpty ?? true) {
                return 'password_required'.tr();
              }
              if ((val?.length ?? 0) < 6) {
                return 'valid_password'.tr();
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: _obscurePassword
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
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
              if (val?.trim().isEmpty ?? true) {
                return 'password_required'.tr();
              }
              if ((val?.length ?? 0) < 6) {
                return 'valid_password'.tr();
              }
              if (val != passwordCtrl.text) {
                return "密碼不匹配";
              }
              return null;
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              "生日",
              style: TextStyle(color: Color(0xFF5E6773), fontSize: 12),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4FC),
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
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
                  context: context,
                  config: config,
                  dialogSize: const Size(325, 400),
                  borderRadius: BorderRadius.circular(15),
                  value: selectedDate,
                  dialogBackgroundColor: Colors.white,
                );
                if (picked != null && picked.isNotEmpty) {
                  setState(() {
                    selectedDate = picked;
                    birthdayCtrl.text = getDateString(
                      selectedDate.whereType<DateTime>().toList(),
                    );
                  });
                }
              }),
              decoration: const InputDecoration(
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
          const SizedBox(height: 50),
          LargeButton(
            onTap: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
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
                  );
                  showToast("帳號新增成功！");
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
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
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
