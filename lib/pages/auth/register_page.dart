// Who knows? Not me,
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/helpers/helpers.dart';
//import 'package:homebank/models/user.dart';
import 'package:homebank/pages/home_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:homebank/widgets/large_button.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("註冊")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
  final passwordCtrl = TextEditingController();
  final passwordConfirmCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          _buildTextField(
            label: "帳號（請輸入Email）",
            hintText: "帳號（請輸入Email）",
            icon: Icons.email_outlined,
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
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
          const SizedBox(height: 20),
          _buildTextField(
            label: "密碼",
            hintText: "密碼",
            icon: Icons.lock_outline,
            controller: passwordCtrl,
            keyboardType: TextInputType.text,
            isPassword: _obscurePassword,
            validator: (String? val) {
              if (val == null || val.trim().isEmpty) {
                return 'password_required'.tr();
              }
              if (val.length < 6) {
                return 'valid_password'.tr();
              }
              return null;
            },
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
          const SizedBox(height: 20),
          _buildTextField(
            label: "再次確認密碼",
            hintText: "再次確認密碼",
            icon: Icons.lock_outline,
            controller: passwordConfirmCtrl,
            keyboardType: TextInputType.text,
            isPassword: _obscurePassword,
            validator: (String? val) {
              if (val == null || val.trim().isEmpty) {
                return 'password_required'.tr();
              }
              if (val != passwordCtrl.text) {
                return "密碼不匹配";
              }
              return null;
            },
          ),
          const Spacer(),
          LargeButton(
            onTap: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                EasyLoading.show(status: "註冊中...");
                try {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .signUpWithEmail(
                    userName: userNameCtrl.text,
                    email: emailCtrl.text,
                    password: passwordCtrl.text,
                  );

                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  final currentUser = authProvider.user;

                  if (currentUser.isParent()) {
                    authProvider.listenToChildren(emailCtrl.text);
                    authProvider.listenChildrenJobs(emailCtrl.text);
                    authProvider.listenChildrenPoints(emailCtrl.text);
                  } else {
                    authProvider.listenToJobs(emailCtrl.text);
                    authProvider.listenToPoints(emailCtrl.text);
                  }

                  Navigator.pushReplacement(
                    context,
                    navegateFadein(context, const HomePage()),
                  );
                } catch (e) {
                  showErrorToast(e.toString());
                } finally {
                  EasyLoading.dismiss();
                }
              }
            },
            title: 'register_label'.tr(),
          ),
          const SizedBox(height: 50),
        ],
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
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
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
          textCapitalization: textCapitalization,
        ),
      ],
    );
  }
}
