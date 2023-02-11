import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:itike/models/api_response.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/pages/dashboard_page.dart';
import 'package:itike/pages/main_page.dart';
import 'package:itike/utils/app_constants.dart';
import 'package:itike/utils/colors.dart';

import '../services/user_service.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void _loadUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => false);
      } else if (response.error == unauthorized) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: AppColors.bgColor,
      child: Center(
        child: Container(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonBgColor),
          ),
        ),
      ),
    );
  }
}
