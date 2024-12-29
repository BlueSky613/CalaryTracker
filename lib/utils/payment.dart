import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:ketodiet/api/api.dart';
import 'package:ketodiet/screens/homemain/homemain.dart';
// import 'package:ketodiet/screens/subscription/memberships.dart';

Future<void> makePayment(BuildContext context, Map<String, dynamic> membership,String duration, String price) async {
  try {
    //STEP 1: Create Payment Intent
    dynamic paymentIntent =
        await createPaymentIntent((double.parse(price) * 100).toInt().toString(), 'USD');

    //STEP 2: Initialize Payment Sheet
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent![
                    'client_secret'], //Gotten from payment intent
                style: ThemeMode.light,
                merchantDisplayName: 'Ikay'))
        .then((value) {});
    //STEP 3: Display Payment sheet
    displayPaymentSheet(context, membership, duration, price);
  } catch (err) {
    throw Exception(err);
  }
}

createPaymentIntent(String amount, String currency) async {
  try {
    //Request body
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
    };

    //Make post request to Stripe
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    return json.decode(response.body);
  } catch (err) {
    throw Exception(err.toString());
  }
}

displayPaymentSheet(BuildContext context, Map<String, dynamic> membership,
    String duration, String price) async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) async {
      String? deviceID = await getDeviceID(context);
      dynamic res = await Api().storeSubscriptionResult({
        "device_id": deviceID?.replaceAll('.', '_'),
        "months_of_subscription": duration,
        "price" : price
      });
      print(res);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMain(pageResponse: membership, subScribed: res['duration']),
          ));

      // showDialog(
      //     context: context,
      //     builder: (_) => const AlertDialog(
      //           content: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(
      //                 Icons.check_circle,
      //                 color: Colors.green,
      //                 size: 100.0,
      //               ),
      //               SizedBox(height: 10.0),
      //               Text("Payment Successful!"),
      //             ],
      //           ),
      //         ));

      // paymentIntent = null;
    }).onError((error, stackTrace) {
      throw Exception(error);
    });
  } on StripeException catch (e) {
    print('Error is:---> $e');
    const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              Text("Payment Failed"),
            ],
          ),
        ],
      ),
    );
  } catch (e) {
    print('$e');
  }
}

Future<String?> getDeviceID(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  if (Theme.of(context).platform == TargetPlatform.android) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('AndroidDeviceInfo>>>>>>${androidInfo.id}');
    deviceId = androidInfo.id; // Unique ID for Android devices
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor; // Unique ID for iOS devices
  }

  return deviceId;
}
