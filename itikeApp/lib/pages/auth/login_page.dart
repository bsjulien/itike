import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:itike/models/api_response.dart';
import 'package:itike/pages/auth/signup_page.dart';
import 'package:itike/pages/dashboard_page.dart';
import 'package:itike/pages/main_page.dart';
import 'package:itike/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/button.dart';
import '../../widgets/small_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response =
        await login(emailController.text, passwordController.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: true,
      body: Form(
          key: formkey,
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        child: BigText(
                          text: "Account Login",
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: emailController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Can\'t be empty';
                                  }
                                  if (!EmailValidator.validate(val)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                //autofocus: true,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none),
                                decoration: InputDecoration(
                                    labelText: "EMAIL",
                                    prefixIcon: Icon(
                                      Icons.mail_outline,
                                      color: AppColors.textColor70,
                                    ),
                                    labelStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: AppColors.textColor70,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.5,
                                            color: AppColors.textColor50)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.5,
                                            color: AppColors.mainColor))),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: passwordController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Can\'t be empty';
                                  }
                                  if (val.length < 6) {
                                    return 'Password can\'t be less than six characters';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.mainColor,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.none),
                                decoration: InputDecoration(
                                    labelText: "PASSWORD",
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: AppColors.textColor70,
                                    ),
                                    labelStyle: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: AppColors.textColor70,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.5),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.5,
                                            color: AppColors.textColor50)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.5,
                                            color: AppColors.mainColor))),
                                obscureText: true,
                              ),
                            ),
                            SizedBox(height: 50),
                            loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.buttonBgColor)),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (formkey.currentState!.validate()) {
                                        setState(() {
                                          loading = true;
                                          _loginUser();
                                        });
                                      }
                                    },
                                    child: Button(text: "Sign in")),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SmallText(
                                  text: "Don't have an account?",
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupPage()),
                                        (route) => false);
                                  },
                                  child: SmallText(
                                    text: "Signup",
                                    color: AppColors.linkColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ]),
          )),
    );
  }
}
