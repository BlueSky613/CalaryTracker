import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ketodiet/screens/homemain/homemain.dart';
import 'package:ketodiet/utils/payment.dart';

class SubscriptionFooter extends StatelessWidget {
  Map<String, dynamic>? membership;
  Map<String, dynamic>? mainState;
  SubscriptionFooter({this.membership, this.mainState, Key? key}) : super(key: key);

  void handleSubscribePress(context) {
    makePayment(context, mainState!, membership?['duration'], membership!['price'].toString());
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => HomeMain(),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        decoration: const BoxDecoration(
            color: Color(0xFF002EAB),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${membership?['duration']} Plan: \$${membership?['price']}',
                        softWrap: true, // Allow text to wrap onto the next line
                        style: GoogleFonts.abrilFatface(
                            textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        )),
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF00D364), Color(0xFF006D34)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 104,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      onPressed: () => handleSubscribePress(context),
                      child: const Text(
                        'Pay',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ))
              ],
            ),
            Text(
              '*After payment account will be created and app will start',
              softWrap: true, // Allow text to wrap onto the next line
              style: GoogleFonts.redHatText(
                  textStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              )),
            )
          ],
        ));
  }
}
