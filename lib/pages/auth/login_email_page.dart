// login_email_page.dart
// ignore_for_file: prefer_const_constructors, unused_import, unused_field, library_private_types_in_public_api, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:homebank/common_functions.dart';
import 'package:homebank/helpers/helpers.dart';
import 'package:homebank/models/user.dart';
import 'package:homebank/pages/home_page.dart';
import 'package:homebank/providers/auth.dart' as homebank_auth;
import 'package:homebank/widgets/large_button.dart';
import 'package:homebank/widgets/custom_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 30, right: 30),
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "兒童銀行",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Kid's Bank", style: TextStyle(fontSize: 20)),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                width: 220,
                child: Image.asset("assets/images/img-pig-graphic.png"),
              ),
              const _Form(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);
  @override
  __FormState createState() => __FormState();
}

enum _SupportState { unknown, supported, unsupported }

class __FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  User? currentUser;
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = <BiometricType>[];
  String _authorized = '未認證';
  bool _isAuthenticating = false;
  List<String> suggestons = [];

  @override
  void initState() {
    super.initState();
    loadSuggestons();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(
            () => _supportState = isSupported
                ? _SupportState.supported
                : _SupportState.unsupported,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomInput(
            hintText: "Email",
            icon: Icons.email_outlined,
            kyboardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
            suggestons: suggestons,
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
          const SizedBox(height: 20),
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
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, 'reset'),
              child: const Text(
                "忘記帳號密碼",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 30),
          LargeButton(
            onTap: () async {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                await EasyLoading.show(status: "登入中...");
                try {
                  final authProvider = Provider.of<homebank_auth.AuthProvider>(
                      context,
                      listen: false);
                  await authProvider.loginUser(
                      emailCtrl.text, passwordCtrl.text);
                  await saveEmail(emailCtrl.text);
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
                  print("[DEBUG] $e");
                  showToast("登入失敗！請檢查帳號或密碼！");
                } finally {
                  await EasyLoading.dismiss();
                }
              }
            },
            title: "登入",
            fontSize: 18,
          ),
          const SizedBox(height: 10),
          LargeButton(
            onTap: () {
              Navigator.pushNamed(context, 'register');
            },
            title: "註冊",
            light: true,
            fontSize: 18,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  final authProvider = Provider.of<homebank_auth.AuthProvider>(
                    context,
                    listen: false,
                  );
                  authProvider.user = UserModel(
                      name: '訪客',
                      email: 'guest@example.com',
                      parent: "parent_email");
                  Navigator.pushReplacement(
                    context,
                    navegateFadein(context, const HomePage()),
                  );
                },
                child: const Text(
                  '以訪客身份進入',
                  style: TextStyle(
                    color: Color(0xFF003783),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> loadSuggestons() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      suggestons = pref.getStringList("accounts") ?? [];
      print("[DEBUG] suggestons = $suggestons");
    });
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    suggestons = pref.getStringList("accounts") ?? [];
    if (!suggestons.contains(email)) {
      suggestons.add(email);
    }
    await pref.setStringList("accounts", suggestons);
  }
}
