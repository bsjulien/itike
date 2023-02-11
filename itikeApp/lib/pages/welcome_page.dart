import 'package:flutter/material.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/big_text.dart';
import 'package:itike/widgets/button.dart';
import 'package:itike/widgets/small_text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      width: double.maxFinite,
      height: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 139,
          height: 128,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage("assets/images/logo.png"))),
        ),
        SizedBox(
          height: 60,
        ),
        BigText(text: "Welcome!".toUpperCase()),
        SizedBox(
          height: 15,
        ),
        SmallText(text: "Book your bus ticket in no time."),
        SizedBox(
          height: 60,
        ),
        Button(text: "Account setup"),
      ]),
    );
  }
}
