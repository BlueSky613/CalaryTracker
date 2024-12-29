import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:ketodiet/ads_constant/adsconstant.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/widgets/linearprogress.dart';
import 'package:ketodiet/widgets/myappbar.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ketodiet/screens/subscription/memberships.dart';
import 'package:ketodiet/utils/payment.dart';

class SettingScreen extends StatefulWidget {
  Map<String, dynamic>? pageResponse;
  String? durationDate;
  SettingScreen({this.pageResponse, this.durationDate, Key? key})
      : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AdsConstant interstitialAd = AdsConstant();

  late Map<String, dynamic> membership;

  late final Box userBox;
  List<dynamic> goalList = [];
  bool nonveg = false;
  bool veg = true;
  int calGoal = 0;
  int proteinGoal = 0;
  int carbsGoal = 0;
  int fatGoal = 0;
  bool isCurrentDate = false;
  bool isSlider = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*  userBox = Hive.box('userdata');
    print("isOpen  ${userBox.isOpen}:::::::::::${userBox.length}");
    if(userBox.isNotEmpty){
      getGoalData();
    }*/
    membership = widget.pageResponse?['subscription']?[0]['prices'][0];
    getFoodPref();
    getGoal();
  }

  @override
  void dispose() {
    //setGoalData();
    // TODO: implement dispose
    super.dispose();
  }

  setFoodPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('vegetarian', veg);
  }

  getGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      calGoal = prefs.getInt('caloriesGoal')!;
      proteinGoal = prefs.getInt('proteinGoal')!;
      carbsGoal = prefs.getInt('carbsGoal')!;
      fatGoal = prefs.getInt('fatGoal')!;
    });
  }

  getFoodPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('vegeterian>>>>>$veg ');
    });
  }

  getGoalData() {
    List newUserData = userBox.values.toList();
    goalList.addAll(newUserData);
    print('goalList:::${goalList[0].timestamp}');
  }

  setGoalData(bool isSlider, String text) {
    UserDataModel userGoal = UserDataModel(
      lunchList: [],
      snacksList: [],
      dinnerList: [],
      breakfastList: [],
      caloriesGoal: calGoal.toString(),
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    setState(() {
      print(
          "myTimeStamp:::::${DateTime.now().millisecondsSinceEpoch.toString()}");
      if (userBox.isEmpty || isCurrentDate == false) {
        userBox.put(DateTime.now().millisecondsSinceEpoch.toString(), userGoal);
      } else if (userBox.isNotEmpty && isCurrentDate == true) {
        userBox.putAt(((userBox.length) - 1), userGoal);
      }
      print("userGoal length:::::${userBox.length.toString()}");
    });
  }

  launchZoomMeeting(String meetingUrl) async {
    if (await canLaunch(meetingUrl)) {
      await launch(meetingUrl);
    } else {
      throw 'Could not launch $meetingUrl';
    }
  }

  void handleSubscribePress(context, duration) {
    makePayment(context, widget.pageResponse!, duration,
        membership['price'].toString());
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Memberships(
          paragraph: widget.pageResponse?['paragraph'],
          paragraphTitle: widget.pageResponse?['paragraphTitle'],
          memberships: List<Map<String, dynamic>>.from(widget
              .pageResponse?['subscription'][0]?['prices']
              .map((item) => item as Map<String, dynamic>)),
          isFooter: true,
          onChangePlan: (ms) => setState(() {
            membership = ms;
            handleSubscribePress(context, membership['duration']);
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: MyAppBar.myAppBar(context, 'Settings', true, () {
        // Navigator.pop(context);
      }, () {}, primaryColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: MyContainer(
                    color: blueColor,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyRegularText(
                                isHeading: true,
                                label: 'Premium Version',
                                color: whiteColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              ),
                              MyRegularText(
                                isHeading: false,
                                label: '-Unlimted Stations',
                                color: greyColor1,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              MyRegularText(
                                isHeading: false,
                                label: widget.durationDate == 'expired'
                                    ? 'Duration is expired'
                                    : '${widget.durationDate}days remained',
                                color: greyColor1,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.height / 13,
                              height: MediaQuery.of(context).size.height / 13,
                              child: SvgPicture.asset(
                                'assets/images/svg/premiumIcon.svg',
                                color: whiteColor,
                              )),
                        ],
                      ),
                    ),
                  )),
              MySpacer.spacer,
              const MyRegularText(
                isHeading: true,
                label: 'In-App Purchases',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              MySpacer.mediumspacer,
              MyContainer(
                color: greycontainerColor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/svg/premiumIcon.svg',
                              color: textColor1,
                              height: 20,
                              width: 20,
                            ),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'Upgrade Premium',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                      MySpacer.spacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.spacer,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/svg/referesh.svg',
                              color: textColor1,
                              height: 24,
                              width: 24,
                            ),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'Restore Purchases',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Zoom Meeting',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              MySpacer.mediumspacer,
              MyContainer(
                color: greycontainerColor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyRegularText(
                        isHeading: false,
                        label: widget.pageResponse!['meetingTime'],
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                      GestureDetector(
                        onTap: () async {
                          launchZoomMeeting(
                              widget.pageResponse!['meetingLink']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: MyContainer(
                            color: textColor1,
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 6),
                              child: Row(
                                children: [
                                  MyRegularText(
                                    isHeading: false,
                                    label: 'Join',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Your Daily Goal',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              MySpacer.mediumspacer,
              MyContainer(
                color: greycontainerColor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      LinearProgress(
                        from: 1,
                        text: 'Calories',
                        total: calGoal == 0 ? '0' : calGoal.toString(),
                        subtotal: '799.57',
                        color: redColor,
                        calories: (double caloriesGoal) async {
                          setState(() {
                            calGoal = caloriesGoal.round();
                            print('caloriesGoal>>>>>$calGoal');
                          });
                        },
                        isSlide: (bool value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            isSlider = value;
                            prefs.setInt('caloriesGoal', calGoal);
                            isSlider = false;
                          });
                        },
                      ),
                      MySpacer.mediumspacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.mediumspacer,
                      LinearProgress(
                        from: 1,
                        text: 'Protein',
                        total: proteinGoal == 0 ? '0' : proteinGoal.toString(),
                        subtotal: '799.57',
                        color: greenColor,
                        protein: (double proGoal) {
                          setState(() {
                            proteinGoal = proGoal.round();
                            print('proteinGoal>>>>>$proteinGoal');
                          });
                        },
                        isSlide: (bool value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            isSlider = value;
                            prefs.setInt('proteinGoal', proteinGoal);
                            isSlider = false;
                          });
                        },
                      ),
                      MySpacer.mediumspacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.mediumspacer,
                      LinearProgress(
                        from: 1,
                        text: 'Carbs',
                        total: carbsGoal == 0 ? '0' : carbsGoal.toString(),
                        subtotal: '799.57',
                        color: blueColor1,
                        carbs: (double carbGoal) {
                          setState(() {
                            carbsGoal = carbGoal.round();
                            print('carbsGoal>>>>>$carbsGoal');
                          });
                        },
                        isSlide: (bool value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            isSlider = value;
                            prefs.setInt('carbsGoal', carbsGoal);
                            isSlider = false;
                          });
                        },
                      ),
                      MySpacer.mediumspacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.mediumspacer,
                      LinearProgress(
                        from: 1,
                        text: 'Fat',
                        total: fatGoal == 0 ? '0' : fatGoal.toString(),
                        subtotal: '799.57',
                        color: yellowColor,
                        fat: (double fGoal) {
                          setState(() {
                            fatGoal = fGoal.round();
                            print('fatGoal>>>>>$fatGoal');
                          });
                        },
                        isSlide: (bool value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            isSlider = value;
                            prefs.setInt('fatGoal', fatGoal);
                            isSlider = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              MySpacer.spacer,
              const MyRegularText(
                isHeading: true,
                label: 'Spread the Word',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              MySpacer.mediumspacer,
              MyContainer(
                color: greycontainerColor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star_border,
                              color: textColor1,
                              size: 24,
                            ),
                            // SvgPicture.asset('assets/images/svg/premiumIcon.svg'),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'Rate App',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                      MySpacer.spacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.spacer,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.ios_share,
                              color: textColor1,
                              size: 24,
                            ),
                            // SvgPicture.asset('assets/images/svg/premiumIcon.svg,color: textColor,height: 24,width: 24,'),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'Share App',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Support & Privacy',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              MySpacer.mediumspacer,
              MyContainer(
                color: greycontainerColor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              color: textColor1,
                              size: 23,
                            ),
                            // SvgPicture.asset('assets/images/svg/premiumIcon.svg'),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'E-mail us',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                      MySpacer.spacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.spacer,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.front_hand_outlined,
                              color: textColor1,
                              size: 22,
                            ),
                            //SvgPicture.asset('assets/images/svg/premiumIcon.svg,color: textColor,height: 24,width: 24,'),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'Privacy Policy',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                      MySpacer.spacer,
                      const MyContainer(
                        height: 1,
                        width: double.infinity,
                        color: greyColor1,
                      ),
                      MySpacer.spacer,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.note_add_outlined,
                              color: textColor1,
                              size: 22,
                            ),
                            //SvgPicture.asset('assets/images/svg/premiumIcon.svg,color: textColor,height: 24,width: 24,'),
                            MySpacer.width10,
                            const MyRegularText(
                              isHeading: false,
                              label: 'Terms of Use',
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 9,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
