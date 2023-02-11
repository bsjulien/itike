import 'package:flutter/material.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/app_constants.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/big_text.dart';
import 'package:itike/widgets/small_text.dart';

import '../models/api_response.dart';
import '../models/user.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  User? user;
  bool _usrloading = true;

  // getting the user
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        _usrloading = _usrloading ? !_usrloading : _usrloading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 60, right: 18, left: 18),
            child: Row(children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back,
                      color: AppColors.mainColor, size: 30)),
              SizedBox(
                width: 12,
              ),
              BigText(text: "Account info", size: 22),
            ]),
          ),
          SizedBox(height: 30),
          _usrloading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.buttonBgColor)),
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      EdgeInsets.only(top: 25, bottom: 30, left: 25, right: 25),
                  decoration: BoxDecoration(
                    color: AppColors.boxColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainColor.withOpacity(0.2),
                        spreadRadius: -20,
                        blurRadius: 50,
                        offset: Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(children: [
                            Image(
                                width: 61,
                                height: 61,
                                image: AssetImage(
                                    "assets/images/user_circle.png")),
                            SizedBox(
                              height: 15,
                            ),
                            SmallText(
                              text: "User profile",
                              size: 18,
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.w600,
                            )
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmallText(
                              text: "NAME",
                              fontWeight: FontWeight.w600,
                              size: 13,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(226, 230, 238, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SmallText(
                                text: "${user!.name}",
                                color: AppColors.textColor50,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmallText(
                              text: "EMAIL",
                              fontWeight: FontWeight.w600,
                              size: 13,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(226, 230, 238, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SmallText(
                                text: "${user!.email}",
                                color: AppColors.textColor50,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmallText(
                              text: "LANGUAGE",
                              fontWeight: FontWeight.w600,
                              size: 13,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              width: double.maxFinite,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(226, 230, 238, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SmallText(
                                text: "English",
                                color: AppColors.textColor50,
                              ),
                            ),
                          ],
                        ),
                      ])),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.boxColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.mainColor.withOpacity(0.2),
                  spreadRadius: -20,
                  blurRadius: 50,
                  offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                logout().then((value) => {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LoginPage();
                          },
                        ),
                        (context) => false,
                      )
                    });
              },
              child: Row(children: [
                Icon(
                  Icons.logout_outlined,
                  color: AppColors.textColor70,
                  size: 23,
                ),
                SizedBox(
                  width: 10,
                ),
                SmallText(
                  text: "SIGNOUT",
                  fontWeight: FontWeight.w600,
                  size: 13,
                ),
              ]),
            ),
          )
        ]));
  }
}
