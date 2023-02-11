import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itike/models/api_response.dart';
import 'package:itike/models/destination.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/pages/tickets_page.dart';
import 'package:itike/pages/tickets_summary.dart';
import 'package:itike/services/destination_service.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/big_text.dart';
import 'package:itike/widgets/small_text.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/app_constants.dart';
import '../widgets/button.dart';

class DateTimepage extends StatefulWidget {
  final Destination startpoint;
  final Destination endpoint;
  DateTimepage({
    Key? key,
    required this.startpoint,
    required this.endpoint,
  }) : super(key: key);

  @override
  State<DateTimepage> createState() => _DateTimepageState();
}

class _DateTimepageState extends State<DateTimepage> {
  List<dynamic> _destInfoList = [];
  bool _loading = true;
  late Destination destinfo;

  //getting all the startpoints

  Future<void> retrieveDestInfo() async {
    ApiResponse response = await getDestInfo(
        widget.startpoint.startPoint.toString(),
        widget.endpoint.endPoint.toString());
    if (response.error == null) {
      setState(() {
        _destInfoList = response.data as List<dynamic>;
        destinfo = _destInfoList[0];
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

  // selecting the time
  late int tappedIndex;

  @override
  void initState() {
    retrieveDestInfo();
    super.initState();
    tappedIndex = -1;
  }

  CalendarFormat format = CalendarFormat.twoWeeks;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  // controlling date and time

  List checkDateTime(DateTime sel_day, String? endtime) {
    // print("its getting here");
    List<DateTime> list = [];
    int start = 0;
    int end = DateFormat.Hm().parse(endtime.toString()).hour;
    int startIndex;
    int endIndex;

    final DateFormat formatter = DateFormat('MM-dd');
    final String selformat = formatter.format(sel_day);
    final String nowformat = formatter.format(DateTime.now());
    if (formatter
        .parse(selformat)
        .isAtSameMomentAs(formatter.parse(nowformat))) {
      // print("its getting here");
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
        list = [];
      } else if (DateFormat.Hm().parse(formatt).hour >= 0 &&
          DateFormat.Hm()
              .parse(formatt)
              .isBefore(DateFormat.Hm().parse(starttime.toString()))) {
        start = DateFormat.Hm().parse(starttime.toString()).hour;
        for (int index = start; index <= end; index++) {
          list.add(DateFormat.Hm().parse("${index}:00"));
        }
      } else {
        start = now.hour;
        for (int index = start; index <= end; index++) {
          list.add(DateFormat.Hm().parse("${index}:00"));
        }
      }
    } else if (formatter
        .parse(selformat)
        .isBefore(formatter.parse(nowformat))) {
      list = [];
    } else {
      list = [];
      for (int index = 5; index <= end; index++) {
        list.add(DateFormat.Hm().parse("${index}:00"));
      }
    }

    return list;
  }

  String checkAMandPM(DateTime time) {
    if (time.hour >= 12) {
      return "PM";
    } else {
      return "AM";
    }
  }

  String converttime(DateTime time) {
    if (time.hour < 10) {
      return "0${time.hour}:00";
    }
    return "${time.hour}:00";
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
        body: SingleChildScrollView(
          child: _loading
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
                      BigText(text: "Pick date & time", size: 22),
                    ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: SmallText(
                            text:
                                "${widget.startpoint.startPoint}".toUpperCase(),
                            size: 14,
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            width: 197,
                            height: 34,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/images/startEnd.png"),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: SmallText(
                            text: "${widget.endpoint.endPoint}".toUpperCase(),
                            size: 14,
                            color: AppColors.destColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      SmallText(
                        text: "PRICE:",
                        size: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor70,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.busColorblue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SmallText(
                          text: "${destinfo.price} RWF".toUpperCase(),
                          color: AppColors.mainColor,
                          size: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        color: AppColors.boxColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(1990),
                      lastDay: DateTime(2050),
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        setState(() {
                          // checkDateTime(selectDay, destinfo.endTime);
                          final DateFormat formatter = DateFormat('MM-dd');
                          final String selformat = formatter.format(selectDay);
                          final String nowformat =
                              formatter.format(DateTime.now());
                          if (formatter
                              .parse(selformat)
                              .isBefore(formatter.parse(nowformat))) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Can\'t set the date before now')));
                          } else {
                            selectedDay = selectDay;
                            focusedDay = focusDay;
                          }
                          print(convertDateForSub(selectedDay));
                        });
                      },
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },

                      //To style the Calendar
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: AppColors.mainColor,
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          color: AppColors.mainColor,
                        )),
                        selectedTextStyle: TextStyle(color: Colors.white),
                        todayDecoration: BoxDecoration(
                          color: AppColors.mainColor.withOpacity(.5),
                          shape: BoxShape.circle,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        weekendDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: SmallText(
                            text: "AVAILABLE TIME:",
                            size: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 80,
                          width: double.maxFinite,
                          child: checkDateTime(selectedDay, destinfo.endTime)
                                      .length !=
                                  0
                              ? ListView.builder(
                                  itemCount: checkDateTime(
                                          selectedDay, destinfo.endTime)
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, int index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tappedIndex = index;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: 15),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: tappedIndex == index
                                                  ? AppColors.mainColor
                                                  : AppColors.boxColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: SmallText(
                                              text:
                                                  "${converttime(checkDateTime(selectedDay, destinfo.endTime)[index])} ${checkAMandPM(checkDateTime(selectedDay, destinfo.endTime)[index])}",
                                              color: tappedIndex == index
                                                  ? AppColors.boxColor
                                                  : AppColors.mainColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  })
                              : SmallText(
                                  text:
                                      "Time is up for today! You can book the next day",
                                  color: AppColors.textColor50,
                                ),
                        ),
                      ]),
                  GestureDetector(
                    onTap: () {
                      if (tappedIndex < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You must select time')));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketSummary(
                                      startpoint: widget.startpoint,
                                      endpoint: widget.endpoint,
                                      date: convertDateForSub(selectedDay),
                                      time: convertTimeForSub(checkDateTime(
                                          selectedDay,
                                          destinfo.endTime)[tappedIndex]),
                                      price: destinfo.price!.toInt(),
                                      destId: destinfo.id!.toInt(),
                                    )));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Button(
                        text: "Next",
                        width: 370,
                      ),
                    ),
                  )
                ]),
        ));
  }
}
