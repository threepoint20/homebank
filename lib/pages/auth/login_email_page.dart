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

// 修正: 移除重複的 import
// import 'package:firebase_auth_platform_interface/src/auth_provider.dart';

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
  const _Form({super.key});
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

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = '認證中...';
      });
      authenticated = await auth.authenticate(
        localizedReason: '自動偵測',
        options: const AuthenticationOptions(stickyAuth: true),
      );
      setState(() {
        _isAuthenticating = false;
      });
      if (authenticated) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String email = pref.getString("email") ?? "";
        String password = pref.getString("password") ?? "";
        if (email.isNotEmpty && password.isNotEmpty) {
          await EasyLoading.show(status: "登入中...");
          try {
            await Provider.of<homebank_auth.AuthProvider>(
              context,
              listen: false,
            ).autologin(email, password);
            UserModel currentUser = Provider.of<homebank_auth.AuthProvider>(
              context,
              listen: false,
            ).user;
            if (currentUser.isParent()) {
              Provider.of<homebank_auth.AuthProvider>(context, listen: false)
                  .listenToChildren(email);
              Provider.of<homebank_auth.AuthProvider>(context, listen: false)
                  .listenChildrenJobs(email);
              Provider.of<homebank_auth.AuthProvider>(context, listen: false)
                  .listenChildrenPoints(email);
            } else {
              Provider.of<homebank_auth.AuthProvider>(context, listen: false)
                  .listenToJobs(email);
              Provider.of<homebank_auth.AuthProvider>(context, listen: false)
                  .listenToPoints(email);
            }
            Navigator.pushReplacement(
              context,
              navegateFadein(context, const HomePage()),
            );
          } catch (e) {
            showToast("登入失敗！請檢查帳號或密碼！");
          } finally {
            await EasyLoading.dismiss();
          }
        } else {
          showToast("您尚未登入過，請先登入系統！");
        }
      }
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
      () => _authorized = authenticated ? 'Authorized' : 'Not Authorized',
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: '使用指紋或臉部登入',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
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
                    await Provider.of<homebank_auth.AuthProvider>(
                      context,
                      listen: false,
                    ).loginUser(emailCtrl.text, passwordCtrl.text);
                    await saveEmail(emailCtrl.text);
                    UserModel currentUser =
                        Provider.of<homebank_auth.AuthProvider>(
                      context,
                      listen: false,
                    ).user;
                    if (currentUser.isParent()) {
                      Provider.of<homebank_auth.AuthProvider>(context,
                              listen: false)
                          .listenToChildren(emailCtrl.text);
                      Provider.of<homebank_auth.AuthProvider>(context,
                              listen: false)
                          .listenChildrenJobs(emailCtrl.text);
                      Provider.of<homebank_auth.AuthProvider>(context,
                              listen: false)
                          .listenChildrenPoints(emailCtrl.text);
                    } else {
                      Provider.of<homebank_auth.AuthProvider>(context,
                              listen: false)
                          .listenToJobs(emailCtrl.text);
                      Provider.of<homebank_auth.AuthProvider>(context,
                              listen: false)
                          .listenToPoints(emailCtrl.text);
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
                  // 新增一個「訪客模式」按鈕
                  onPressed: () {
                    // 創建一個預設的 UserModel
                    UserModel guestUser = UserModel(
                        name: '訪客',
                        email: 'guest@example.com',
                        // 假設訪客是兒童帳號，以便進入對應的頁面
                        // 你也可以在這裡根據需求設定 parent 屬性
                        parent: "parent_email");

                    // 取得 AuthProvider 實例
                    final authProvider =
                        Provider.of<homebank_auth.AuthProvider>(
                      context,
                      listen: false,
                    );

                    // 手動設置用戶資料
                    authProvider.user = guestUser;

                    // 導向 HomePage
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
            const SizedBox(height: 10), // 新增間距
          ],
        ),
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
    if (suggestons.contains(email) == false) {
      suggestons.add(email);
    }
    await pref.setStringList("accounts", suggestons);
  }
}
