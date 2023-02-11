import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itike/pages/account_info_page.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/pages/auth/signup_page.dart';
import 'package:itike/pages/destination_page.dart';
import 'package:itike/pages/loading_page.dart';
import 'package:itike/pages/main_page.dart';
import 'package:itike/pages/welcome_page.dart';

import 'pages/dashboard_page.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashPage(),
    );
  }
}
