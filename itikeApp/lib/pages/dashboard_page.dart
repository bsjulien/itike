import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itike/models/api_response.dart';
import 'package:itike/models/destination.dart';
import 'package:itike/models/ticket.dart';
import 'package:itike/models/user.dart';
import 'package:itike/pages/account_info_page.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/pages/tickets_summary.dart';
import 'package:itike/services/destination_service.dart';
import 'package:itike/services/ticket_service.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/app_constants.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/small_text.dart';
import 'package:intl/intl.dart';

import '../widgets/big_text.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> _destinationsList = [];
  User? user;
  bool _loading = true;
  bool _usrloading = true;
  DateTime timeNow = DateTime.now();
  bool _booked = false;
  late int destId;
  late String date;
  late String time;

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

  //getting all the destinations
  Future<void> retrieveDest() async {
    ApiResponse response = await gethomeDest();
    if (response.error == null) {
      setState(() {
        _destinationsList = response.data as List<dynamic>;
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

  String checktime(String? endtime) {
    String? starttime = "05:00:00";
    DateTime now = DateTime.now();
    int diff = 0;
    now = now.subtract(Duration(minutes: now.minute, seconds: now.second));
    now = now.add(const Duration(hours: 1));

    dynamic formattedtime = DateFormat.Hm().format(now);
    dynamic formatt = DateFormat.Hm().format(DateTime.now());

    if (DateFormat.Hm()
            .parse(formatt)
            .isAfter(DateFormat.Hm().parse(endtime.toString())) &&
        DateFormat.Hm().parse(formatt).hour != 0) {
      return "tomorrow";
    } else if (DateFormat.Hm().parse(formatt).hour >= 0 &&
        DateFormat.Hm()
            .parse(formatt)
            .isBefore(DateFormat.Hm().parse(starttime.toString()))) {
      return DateFormat.Hm()
              .format(DateFormat.Hm().parse(starttime.toString())) +
          " " +
          checkAMandPM(DateFormat.Hm().parse(starttime.toString()));
    } else {
      return formattedtime.toString() +
          " " +
          checkAMandPM(DateFormat.Hm().parse(formattedtime));
    }
  }

  String checkAMandPM(DateTime time) {
    if (time.hour >= 12) {
      return "PM";
    } else {
      return "AM";
    }
  }

  //converting time
  String converttime(String time) {
    final DateFormat formatter = DateFormat('HH:mm');
    DateTime pass = DateFormat('HH:mm').parse(time);
    final String dateformat = formatter.format(pass);
    return dateformat;
  }

  String convertTimeForSub(DateTime time) {
    if (time.hour < 10) {
      return "0${time.hour}:00:00";
    }
    return "${time.hour}:00:00";
  }

  String convertDateForSub() {
    final DateFormat formatter = DateFormat('y-MM-dd');
    final String dateformat = formatter.format(DateTime.now());
    return dateformat;
  }

  @override
  void initState() {
    getUser();
    retrieveDest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return retrieveDest();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // This is the header
                  Container(
                    margin: EdgeInsets.only(top: 55, right: 20, left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                text: "Welcome",
                                size: 22,
                              ),
                              _usrloading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.buttonBgColor)),
                                    )
                                  : SmallText(text: "${user!.name}")
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AccountInfoPage()));
                            },
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 40,
                              color: AppColors.mainColor,
                            ),
                          )
                        ]),
                  ),
                  SizedBox(height: 30),

                  // Rest of the content
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/Bookedtickets.png"))),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SmallText(
                                text: "Kigali's upcoming tickets",
                                fontWeight: FontWeight.w600,
                                size: 16,
                                color: AppColors.mainColor,
                              ),
                              SmallText(
                                text: "Book fast before the tickets sold out.",
                                size: 10,
                                fontWeight: FontWeight.w500,
                              )
                            ],
                          ),
                        ),
                        // SmallText(
                        //   text: "More",
                        //   color: AppColors.linkColor,
                        //   size: 12,
                        // )
                      ],
                    ),
                  ),

                  Column(children: [
                    _loading
                        ? Container(
                            margin: EdgeInsets.symmetric(vertical: 150),
                            child: Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.buttonBgColor)),
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _destinationsList.length,
                            itemBuilder: (context, int index) {
                              Destination destination =
                                  _destinationsList[index];

                              return Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 25),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.boxColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColors.mainColor.withOpacity(0.2),
                                      spreadRadius: -20,
                                      blurRadius: 50,
                                      offset: Offset(
                                          0, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SmallText(
                                          text: "Start point",
                                          color: AppColors.textColor50,
                                          size: 13,
                                        ),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        SmallText(
                                          text: "${destination.startPoint}"
                                              .toUpperCase(),
                                          size: 14,
                                          color: AppColors.mainColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        checktime(destination.endTime) ==
                                                "tomorrow"
                                            ? SmallText(
                                                text: "TOMORROW",
                                                size: 13,
                                                color: AppColors.mainColor,
                                                fontWeight: FontWeight.w600,
                                              )
                                            : Row(children: [
                                                Icon(
                                                  Icons.access_time,
                                                  color: AppColors.mainColor,
                                                  size: 11,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                SmallText(
                                                  text: checktime(
                                                      destination.endTime),
                                                  size: 13,
                                                  color: AppColors.mainColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ]),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 3),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.5,
                                                color: AppColors.buttonBgColor),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child:
                                              checktime(destination.endTime) ==
                                                      "tomorrow"
                                                  ? SmallText(
                                                      text: "CLOSED"
                                                          .toUpperCase(),
                                                      color:
                                                          AppColors.destColor,
                                                      size: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        String startjson =
                                                            '{"start_point": "${destination.startPoint}"}';
                                                        String endjson =
                                                            '{"end_point": "${destination.endPoint}"}';
                                                        Map<String, dynamic>
                                                            startpoint =
                                                            jsonDecode(
                                                                startjson);
                                                        Map<String, dynamic>
                                                            endpoint =
                                                            jsonDecode(endjson);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TicketSummary(
                                                                          startpoint:
                                                                              Destination.fromJson(startpoint),
                                                                          endpoint:
                                                                              Destination.fromJson(endpoint),
                                                                          date:
                                                                              convertDateForSub(),
                                                                          time:
                                                                              converttime(checktime(destination.endTime)),
                                                                          price: destination
                                                                              .price!
                                                                              .toInt(),
                                                                          destId: destination
                                                                              .id!
                                                                              .toInt(),
                                                                        )));
                                                      },
                                                      child: SmallText(
                                                        text: "BOOK NOW"
                                                            .toUpperCase(),
                                                        color:
                                                            AppColors.destColor,
                                                        size: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SmallText(
                                          text: "Destination",
                                          color: AppColors.textColor50,
                                          size: 14,
                                        ),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        SmallText(
                                          text: "${destination.endPoint}"
                                              .toUpperCase(),
                                          size: 14,
                                          color: AppColors.mainColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
