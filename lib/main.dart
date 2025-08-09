import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:homebank/pages/auth/login_email_page.dart';
import 'package:homebank/providers/auth.dart';
import 'package:homebank/providers/job.dart';
import 'package:homebank/providers/point.dart';

import 'package:homebank/routes/routes.dart';

import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        // 修正: 加上 const
        Locale('zh', 'TW'),
      ],
      fallbackLocale: const Locale('zh', 'TW'), // 修正: 加上 const
      path: 'assets/translations',
      child: const MyApp(), // 修正: 加上 const
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); // 修正: 加上 const 和 super.key
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => PointProvider()),
        ChangeNotifierProvider(create: (ctx) => JobProvider()),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          print(
            "[DEBUG] currentFocus: $currentFocus, hasPrimaryFocus: ${currentFocus.hasPrimaryFocus}",
          );
          if (!currentFocus.hasPrimaryFocus) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: const Color(0xFF003783), // 修正: 加上 const
            primaryColorLight: const Color(0xFFEEF4FC), // 修正: 加上 const
            fontFamily: 'Noto Sans TC',
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: const Color(0xff003783), // 修正: 加上 const
              displayColor: const Color(0xff003783), // 修正: 加上 const
            ),
            appBarTheme: const AppBarTheme(
              // 修正: 加上 const
              backgroundColor: Color(0xFFEEF4FC),
              // This will be applied to the "back" icon
              iconTheme: IconThemeData(color: Color(0xFF313438)),
              // This will be applied to the action icon buttons that locates on the right side
              actionsIconTheme: IconThemeData(color: Color(0xFF313438)),
              centerTitle: false,
              elevation: 0,
              titleTextStyle: TextStyle(color: Color(0xFF313438), fontSize: 20),
            ),
          ),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            EasyLocalization.of(context)!.delegate, // 修正: 加上 !
          ],
          supportedLocales: EasyLocalization.of(
            context,
          )!.supportedLocales, // 修正: 加上 !
          locale: EasyLocalization.of(context)!.locale, // 修正: 加上 !
          debugShowCheckedModeBanner: false,
          title: '兒童銀行',
          routes: appRoutes,
          builder: EasyLoading.init(),
          home: AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset("assets/images/img_piggy_add_award.png"),
            nextScreen: const LoginEmailPage(), // 修正: 加上 const
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
