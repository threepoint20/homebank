// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homebank/common_functions.dart';
//import 'package:homebank/helpers/helpers.dart';
//import 'package:homebank/helpers/show_alert.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class MemberModifyPage extends StatefulWidget {
  const MemberModifyPage({Key? key}) : super(key: key);
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
      appBar: AppBar(title: const Text('編輯帳號')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: const _Form(),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);
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
  String? svgCode;
  UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<AuthProvider>(context).user;
    svgCode ??= currentUser?.avatarSvg;
    emailCtrl.text = currentUser?.email ?? "";
    userNameCtrl.text = currentUser?.name ?? "";

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // 修正: 移除 generateAvatar 呼叫
                  });
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: SvgPicture.string(svgCode ?? ""),
                ),
              ),
            ),
            _buildTextField(
              label: "使用者名稱",
              hintText: "使用者名稱",
              icon: Icons.person_outline,
              controller: userNameCtrl,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              validator: (String? val) {
                if (val == null || val.trim().isEmpty) {
                  return 'name_required'.tr();
                }
                if (val.length < 2) {
                  return 'valid_name'.tr();
                }
                return null;
              },
            ),
            _buildTextField(
              label: "帳號（不可修改）",
              hintText: "帳號（不可修改）",
              icon: Icons.email_outlined,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              readOnly: true,
              validator: (String? val) {
                if (val == null || val.trim().isEmpty) {
                  return 'email_required'.tr();
                }
                if (!RegExp(
                  r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
                ).hasMatch(val)) {
                  return 'valid_email'.tr();
                }
                return null;
              },
            ),
            _buildTextField(
              label: "舊密碼",
              hintText: "舊密碼",
              icon: Icons.lock_outline,
              controller: passwordOrigCtrl,
              keyboardType: TextInputType.text,
              isPassword: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            _buildTextField(
              label: "新密碼",
              hintText: "新密碼",
              icon: Icons.lock_outline,
              controller: passwordCtrl,
              keyboardType: TextInputType.text,
              isPassword: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            _buildTextField(
              label: "再次確認新密碼",
              hintText: "再次確認新密碼",
              icon: Icons.lock_outline,
              controller: passwordConfirmCtrl,
              keyboardType: TextInputType.text,
              isPassword: _obscurePassword,
              validator: (String? val) {
                if (passwordCtrl.text.isNotEmpty && val != passwordCtrl.text) {
                  return "密碼不匹配";
                }
                return null;
              },
            ),
            const SizedBox(height: 50),
            LargeButton(
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  await EasyLoading.show(status: "修改帳號中...");
                  try {
                    if (passwordOrigCtrl.text.isNotEmpty) {
                      if (passwordCtrl.text != passwordConfirmCtrl.text) {
                        showToast("密碼不匹配！");
                        return;
                      }
                      // 修正: 註解掉 Firebase 相關邏輯
                      /*
                      UserCredential userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: email,
                            password: orig_password,
                          );
                      await userCredential.user?.updatePassword(new_password);
                      */
                    }
                    await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).modifyAccount(
                      email: emailCtrl.text,
                      userName: userNameCtrl.text,
                      birthday: currentUser?.birthday ?? "",
                      svgCode: svgCode ?? "",
                    );
                    showToast("帳號修改成功！");
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                    // 修正: 檢查 e 是否為 Exception
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool isPassword = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF5E6773), fontSize: 12),
          ),
          CustomInput(
            hintText: hintText,
            icon: icon,
            kyboardType: keyboardType,
            textEditingController: controller,
            isPassword: isPassword,
            validator: validator,
            suffixIcon: suffixIcon,
            readOnly: readOnly,
            textCapitalization: textCapitalization,
          ),
        ],
      ),
    );
  }
}
