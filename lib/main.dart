// main.dart
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:homebank/pages/auth/login_email_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/job.dart';
import 'package:homebank/providers/point.dart';

import 'package:homebank/routes/routes.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

const Color primaryColor = Color(0xFF003783);
const Color primaryColorLight = Color(0xFFEEF4FC);
const Color textColor = Color(0xFF313438);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // 修正：註解掉 Firebase 初始化
  // await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('zh', 'TW'),
      ],
      fallbackLocale: const Locale('zh', 'TW'),
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => PointProvider()),
        ChangeNotifierProvider(create: (context) => JobProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primaryColor: primaryColor,
            primaryColorLight: primaryColorLight,
            fontFamily: 'Noto Sans TC',
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: primaryColor,
                  displayColor: primaryColor,
                ),
            appBarTheme: const AppBarTheme(
              backgroundColor: primaryColorLight,
              iconTheme: IconThemeData(color: textColor),
              actionsIconTheme: IconThemeData(color: textColor),
              centerTitle: false,
              elevation: 0,
              titleTextStyle: TextStyle(color: textColor, fontSize: 20),
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: '兒童銀行',
          routes: appRoutes,
          builder: EasyLoading.init(),
          home: AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset("assets/images/img_piggy_add_award.png"),
            nextScreen: const LoginEmailPage(), // 修正: 重新導向到 LoginEmailPage
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            splashIconSize: 200,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
