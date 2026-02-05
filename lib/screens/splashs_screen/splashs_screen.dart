import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ketodiet/ads_constant/adsconstant.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:ketodiet/api/api.dart';

class SplashsScreen extends StatefulWidget {
  String? imgUrl;
  SplashsScreen({this.imgUrl, Key? key}) : super(key: key);

  @override
  State<SplashsScreen> createState() => _SplashsScreenState();
}

class _SplashsScreenState extends State<SplashsScreen> {
  final AdsConstant interstitialAd = AdsConstant();

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 10);
    return Timer(duration, showAd);
  }

  void showAd() {
    interstitialAd.loadAppOpenAd(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MyContainer(
          height: double.infinity,
          width: double.infinity,
          image: widget.imgUrl != null
              ? DecorationImage(
                  image: NetworkImage(widget.imgUrl!), fit: BoxFit.cover)
              : const DecorationImage(
                  image: AssetImage('assets/images/splashback.png'),
                  fit: BoxFit.contain),
          child: Center(
              child: MyRegularText(
            isHeading: false,
            label: '',
            style: GoogleFonts.barlow(
              textStyle: const TextStyle(
                color: greenColor1,
                fontSize: 45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ))),
    );
  }
}
