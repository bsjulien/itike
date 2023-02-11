import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itike/models/ticket.dart';
import 'package:itike/pages/account_info_page.dart';
import 'package:itike/pages/auth/login_page.dart';
import 'package:itike/services/destination_service.dart';
import 'package:itike/services/ticket_service.dart';
import 'package:itike/services/user_service.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/small_text.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/api_response.dart';
import '../utils/app_constants.dart';
import '../widgets/big_text.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<dynamic> _ticketInfoList = [];
  bool _loading = true;
  late Ticket ticketInfo;

  CalendarFormat format = CalendarFormat.week;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  //getting all the tickets

  Future<void> retrieveTicketsInfo() async {
    ApiResponse response = await getTickets(convertDateForSub(selectedDay));
    if (response.error == null) {
      setState(() {
        _ticketInfoList = response.data as List<dynamic>;
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

  @override
  void initState() {
    retrieveTicketsInfo();
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

  String convertDateForSub(DateTime date) {
    final DateFormat formatter = DateFormat('y-MM-dd');
    final String dateformat = formatter.format(date);
    return dateformat;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return retrieveTicketsInfo();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: Column(
          children: [
            Column(children: [
              // This is the header
              Container(
                margin: EdgeInsets.only(top: 55, right: 20, left: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: "Booked Tickets",
                        size: 22,
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

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 15),
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
                      selectedDay = selectDay;
                      focusedDay = focusDay;

                      retrieveTicketsInfo();
                    });
                    print(focusedDay);
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
                height: 10,
              ),
            ]),
            // Rest of the content

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  _ticketInfoList.length != 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _ticketInfoList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, int index) {
                            ticketInfo = _ticketInfoList[index];
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 25),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 130,
                              decoration: BoxDecoration(
                                color: AppColors.boxColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: -20,
                                    blurRadius: 50,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SmallText(
                                          text: "${ticketInfo.startpoint}"
                                              .toUpperCase(),
                                          size: 14,
                                          color: AppColors.mainColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: 174,
                                            height: 26,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/startEnd.png"),
                                            )),
                                          ),
                                        ),
                                        SmallText(
                                          text: "${ticketInfo.endpoint}"
                                              .toUpperCase(),
                                          size: 14,
                                          color: AppColors.destColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SmallText(
                                              text: "DATE",
                                              color: AppColors.textColor50,
                                              size: 12,
                                            ),
                                            SizedBox(
                                              height: 9,
                                            ),
                                            SmallText(
                                              text: convertdate(ticketInfo.date
                                                      .toString())
                                                  .toUpperCase(),
                                              size: 13,
                                              color: AppColors.mainColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SmallText(
                                              text: "TIME",
                                              color: AppColors.textColor50,
                                              size: 12,
                                            ),
                                            SizedBox(
                                              height: 9,
                                            ),
                                            SmallText(
                                              text:
                                                  "${converttime(ticketInfo.time.toString())} ${checkAMandPM(ticketInfo.time.toString())}"
                                                      .toUpperCase(),
                                              size: 13,
                                              color: AppColors.mainColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SmallText(
                                              text: "PRICE",
                                              color: AppColors.textColor50,
                                              size: 12,
                                            ),
                                            SizedBox(
                                              height: 9,
                                            ),
                                            SmallText(
                                              text: "${ticketInfo.price} RWF"
                                                  .toUpperCase(),
                                              size: 13,
                                              color: AppColors.mainColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                            );
                          })
                      : Container(
                          margin: EdgeInsets.only(top: 40),
                          child: SmallText(
                              text: "There are no tickets booked at this day"),
                        ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
