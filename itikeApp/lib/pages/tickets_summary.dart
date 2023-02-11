import 'package:flutter/material.dart';
import 'package:itike/models/api_response.dart';
import 'package:itike/models/destination.dart';
import 'package:itike/models/user.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/pages/destination_page.dart';
import 'package:itike/pages/ticket_success_page.dart';
import 'package:itike/services/ticket_service.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/widgets/button.dart';
import 'package:itike/widgets/small_text.dart';
import 'package:intl/intl.dart';

import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../widgets/big_text.dart';

class TicketSummary extends StatefulWidget {
  final Destination startpoint;
  final Destination endpoint;
  final String date;
  final String time;
  final int price;
  final int destId;

  const TicketSummary(
      {Key? key,
      required this.startpoint,
      required this.endpoint,
      required this.date,
      required this.time,
      required this.price,
      required this.destId})
      : super(key: key);

  @override
  State<TicketSummary> createState() => _TicketSummaryState();
}

class _TicketSummaryState extends State<TicketSummary> {
  User? user;
  bool _loading = true;
  bool _tickloading = false;

  // getting the user
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        _loading = false;
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

  // creating the ticket
  void _createTicket() async {
    ApiResponse response =
        await createTicket(widget.destId, widget.date, widget.time);

    if (response.error == null) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return TicketSuccessPage();
          },
        ),
        (context) => false,
      );
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false)
          });
    } else {
      setState(() {
        _tickloading = !_tickloading;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  String checkAMandPM(String time) {
    final DateFormat formatter = DateFormat('hh:mm');
    DateTime pass = DateFormat('hh:mm').parse(time);
    if (pass.hour >= 12) {
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

  String convertdate(String date) {
    final DateFormat formatter = DateFormat('MM-dd');
    DateTime pass = DateFormat("y-MM-dd").parse(date);
    final String dateformat = formatter.format(pass);
    return dateformat;
  }

  String convertTimeForSub(DateTime time) {
    if (time.hour < 10) {
      return "0${time.hour}:00:00";
    }
    return "${time.hour}:00:00";
  }

  String convertDateForSub(DateTime date) {
    final DateFormat formatter = DateFormat('y-MM-dd');
    final String dateformat = formatter.format(date);
    return dateformat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        body: _loading
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 200),
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.buttonBgColor)),
                ),
              )
            : Column(children: [
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
                    BigText(text: "Ticket Summary", size: 22),
                  ]),
                ),
                SizedBox(height: 30),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
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
                                width: 78,
                                height: 71,
                                image: AssetImage("assets/images/logo.png")),
                            SizedBox(
                              height: 15,
                            ),
                            SmallText(
                              text: "Ticket Info",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: "FROM",
                                  fontWeight: FontWeight.w600,
                                  size: 13,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(226, 230, 238, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.textColor50,
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SmallText(
                                      text: "${widget.startpoint.startPoint}",
                                      color: AppColors.textColor50,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: "TO",
                                  fontWeight: FontWeight.w600,
                                  size: 13,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(226, 230, 238, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      Icons.location_on_sharp,
                                      color: AppColors.textColor50,
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SmallText(
                                      text: "${widget.endpoint.endPoint}",
                                      color: AppColors.textColor50,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: "DATE & TIME",
                                  fontWeight: FontWeight.w600,
                                  size: 13,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 150,
                                  child: Row(children: [
                                    SmallText(
                                      text: "${convertdate(widget.date)}",
                                      size: 16,
                                      color: AppColors.textColor50,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    SmallText(
                                      text: "|",
                                      size: 16,
                                      color: AppColors.textColor50,
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    SmallText(
                                      text:
                                          "${converttime(widget.time)} ${checkAMandPM(widget.time)}",
                                      size: 16,
                                      color: AppColors.textColor50,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: "PRICE",
                                  fontWeight: FontWeight.w600,
                                  size: 13,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 150,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(226, 230, 238, 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(children: [
                                    SmallText(
                                      text: "RWF",
                                      color: AppColors.textColor50,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    SmallText(
                                      text: "${widget.price}",
                                      color: AppColors.textColor50,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                _tickloading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.buttonBgColor)),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _tickloading = !_tickloading;
                            _createTicket();
                          });
                        },
                        child: Button(
                          text: "Save ticket",
                          width: 370,
                        ),
                      )
              ]));
  }
}
