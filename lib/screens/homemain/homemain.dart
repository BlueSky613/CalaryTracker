import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ketodiet/ads_constant/adsconstant.dart';
import 'package:ketodiet/screens/homemain/tab_screen/home_screen.dart';
// import 'package:ketodiet/screens/homemain/tab_screen/recipies_screen.dart';
import 'package:ketodiet/screens/homemain/tab_screen/setting_screen.dart';
import 'package:ketodiet/screens/homemain/tab_screen/statistic_screen.dart';
import 'package:ketodiet/utils/colors_utils.dart';

class HomeMain extends StatefulWidget {
  Map<String, dynamic>? pageResponse;
  int? from;
  String? subScribed;
  HomeMain({this.from, this.pageResponse,this.subScribed, Key? key}) : super(key: key);

  @override
  State<HomeMain> createState() => HomeMainState();
}

class HomeMainState extends State<HomeMain> {
  final AdsConstant interstitialAd = AdsConstant();
  int _selectedIndex = 0;
  int counter = 0;
  DateTime? newdate;
  bool isExpired = false;
  int? newfrom;
  static List<Widget>? _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      if (widget.subScribed != 'expired') {
        _selectedIndex = index;
        counter++;
        print('counter is $counter');
      } else {
        _selectedIndex = 2;
      }
    });
  }

  @override
  void initState() {
    // interstitialAd.loadBannerAd();
    super.initState();
    if(widget.subScribed == 'expired') _selectedIndex = 2;
    _widgetOptions = <Widget>[
      HomeScreen(from: widget.from),
      const StatisticScreen(),
      SettingScreen(
        pageResponse: widget.pageResponse,
        durationDate: widget.subScribed
      )
      // const RecipiesScreen()
    ];

    interstitialAd.createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    // if(counter == 3){
    //   counter = 0;
    //   interstitialAd.showInterstitialAd();
    //   print('counter >>>$counter');
    // }

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height / 17,
        ),
        child: Container(child: interstitialAd.getBannerAdWidget()),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      backgroundColor: primaryColor,
      body: Center(
        child: _widgetOptions!.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SizedBox(
                  height: 24,
                  width: 24,
                  child: SvgPicture.asset(
                    'assets/images/svg/home.svg',
                    fit: BoxFit.scaleDown,
                    color: _selectedIndex == 0 ? Colors.blue : textColor,
                  )),
              label: 'Dashboard',
              //  backgroundColor: primaryColor
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  height: 22,
                  width: 22,
                  child: SvgPicture.asset(
                    'assets/images/svg/recipie.svg',
                    fit: BoxFit.scaleDown,
                    color: _selectedIndex == 1 ? Colors.blue : textColor,
                  )),
              label: 'Recipies',
            ),
            // BottomNavigationBarItem(
            //   icon: SizedBox(
            //       height: 22,
            //       width: 22,
            //       child: SvgPicture.asset(
            //         'assets/images/svg/statistic.svg',
            //         fit: BoxFit.scaleDown,
            //         color: _selectedIndex == 2 ? Colors.blue : textColor,
            //       )),
            //   label: 'Balances',
            // ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  height: 22,
                  width: 22,
                  child: SvgPicture.asset(
                    'assets/images/svg/category.svg',
                    fit: BoxFit.scaleDown,
                    color: _selectedIndex == 2 ? Colors.blue : textColor,
                  )),
              label: 'Settings',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          backgroundColor: whiteColor,
          unselectedItemColor: textColor,
          unselectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          selectedLabelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          iconSize: 24,
          onTap: _onItemTapped,
          elevation: 0),
    );
  }
}
