import 'package:flutter/material.dart';
//me
import 'package:homebank/pages/auth/login_email_page.dart';
import 'package:homebank/pages/auth/register_page.dart';
import 'package:homebank/pages/auth/reset_password.dart';
import 'package:homebank/pages/home_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'email': (_) => LoginEmailPage(),
  'register': (_) => RegisterPage(),
  'reset': (_) => ResetPassword(),
  'home': (_) => HomePage(),
};
