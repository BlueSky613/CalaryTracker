import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ketodiet/model/hive/userdata/breakfastmodel/breakfastmodel.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';
import 'package:ketodiet/screens/splashs_screen/splashs_screen.dart';
import 'package:ketodiet/api/api.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      // "pk_live_51PgFqcJVipSY2QXgUJBnk0TvPe1BqPGabYYn72HU2pbCFAyjKv1Az3sEwdILBzMtefIkNz0OO3ZN7C8kmakxcfah00JyNLSIkx";
  "pk_test_51PgFqcJVipSY2QXgmfRHAce7wq3wRMC2l4GVajBfv8inWCSQcAcc40ZywNqFnjpxFaTzXCjlQtHo8hx1ckjqFMId00gSyvhP92";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  dynamic imgUrl = [];
  imgUrl = await Api().getSplashImg();
  Hive.registerAdapter(UserDataModelAdapter());
  Hive.registerAdapter(BreakFastModelAdapter());
  await Hive.openBox('userdata');
  await Hive.openBox('breakfastData');
  runApp(MyApp(imgUrl: imgUrl[0]['imgUrl'][0]));
}

class MyApp extends StatelessWidget {
  String? imgUrl;
  MyApp({this.imgUrl,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calories Tracker',
      debugShowCheckedModeBanner: false,
      home: SplashsScreen(imgUrl: imgUrl),
    );
  }
}
