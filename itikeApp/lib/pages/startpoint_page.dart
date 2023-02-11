import 'package:flutter/material.dart';
import 'package:itike/models/api_response.dart';
import 'package:itike/models/destination.dart';
import 'package:itike/pages/destination_page.dart';
import 'package:itike/services/destination_service.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/button.dart';

import '../utils/app_constants.dart';
import '../widgets/big_text.dart';
import '../widgets/small_text.dart';
import 'auth/login_page.dart';

class StartPointPage extends StatefulWidget {
  const StartPointPage({Key? key}) : super(key: key);

  @override
  State<StartPointPage> createState() => _StartPointPageState();
}

class _StartPointPageState extends State<StartPointPage> {
  List<dynamic> _startPointsList = [];
  bool _loading = true;
  late Destination startpoint;

  //getting all the startpoints

  Future<void> retrieveStartpoints() async {
    ApiResponse response = await getStartpoints();
    if (response.error == null) {
      setState(() {
        _startPointsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  late int tappedIndex;
  @override
  void initState() {
    retrieveStartpoints();
    super.initState();
    tappedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 60, right: 20, left: 20),
            child: BigText(
              text: "Start point",
              size: 22,
            ),
          ),
          SizedBox(height: 30),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 53,
            decoration: BoxDecoration(
              color: AppColors.boxColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallText(
                    text: "Select location",
                    size: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    child: Image(
                        image:
                            AssetImage("assets/images/chevron_big_down.png")),
                  )
                ]),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 400,
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
            child: _loading
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.buttonBgColor)),
                    ),
                  )
                : MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, right: 4, bottom: 10),
                      child: RawScrollbar(
                        thumbColor: AppColors.mainColor.withOpacity(.6),
                        thickness: 5,
                        radius: Radius.circular(10),
                        isAlwaysShown: true,
                        child: ListView.separated(
                            padding:
                                EdgeInsets.only(top: 0, bottom: 2, right: 8),
                            separatorBuilder: (context, index) => Divider(
                                  color: AppColors.mainColor.withOpacity(.1),
                                  height: 1,
                                  thickness: 1.2,
                                ),
                            itemCount: _startPointsList.length,
                            itemBuilder: ((context, int index) {
                              startpoint = _startPointsList[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tappedIndex = index;
                                  });
                                },
                                child: Container(
                                  color: tappedIndex == index
                                      ? AppColors.mainColor
                                      : AppColors.boxColor,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: SmallText(
                                    text: "${startpoint.startPoint}",
                                    size: 17,
                                    fontWeight: FontWeight.w600,
                                    color: tappedIndex == index
                                        ? AppColors.boxColor
                                        : AppColors.textColor70,
                                  ),
                                ),
                              );
                            })),
                      ),
                    ),
                  ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              if (tappedIndex < 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('First select at least one location')));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DestinationPage(
                              startpoint: _startPointsList[tappedIndex],
                            )));
              }
            },
            child: Center(
              child: Button(
                text: "Next",
                width: 370,
              ),
            ),
          )
        ],
      ),
    );
  }
}
