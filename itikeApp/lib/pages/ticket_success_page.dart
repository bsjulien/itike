import 'package:flutter/material.dart';
import 'package:itike/pages/main_page.dart';
import 'package:itike/pages/tickets_page.dart';
import 'package:itike/utils/colors.dart';
import 'package:itike/widgets/big_text.dart';
import 'package:itike/widgets/button.dart';

class TicketSuccessPage extends StatefulWidget {
  const TicketSuccessPage({Key? key}) : super(key: key);

  @override
  State<TicketSuccessPage> createState() => _TicketSuccessPageState();
}

class _TicketSuccessPageState extends State<TicketSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/checkmark.png"),
              width: 122,
              height: 122,
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              width: 200,
              child: BigText(
                text: "Ticket created successfully",
                size: 22,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainPage(
                              currentIndex: 2,
                            )));
              },
              child: Button(
                text: "View tickets",
                width: 270,
              ),
            )
          ],
        ),
      ),
    );
  }
}
