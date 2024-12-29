import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ketodiet/ads_constant/adsconstant.dart';
import 'package:ketodiet/api/api.dart';
import 'package:ketodiet/model/alldetailsmodel.dart';
import 'package:ketodiet/model/hive/userdata/breakfastmodel/breakfastmodel.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';
import 'package:ketodiet/screens/abstract_main_logic/abstract_calculation.dart';
import 'package:ketodiet/screens/homemain/tab_screen/additem_screen.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/constant.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/widgets/circularprogress.dart';
import 'package:ketodiet/widgets/linearprogress.dart';
import 'package:ketodiet/widgets/my_custom_calander.dart';
import 'package:ketodiet/widgets/myappbar.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ketodiet/utils/payment.dart';

class HomeScreen extends StatefulWidget {
  int? from;

  HomeScreen({this.from, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with CalCulation {
  final AdsConstant interstitialAd = AdsConstant();
  late final Box userBox;
  UserDataModel? userAllList;
  static List<AllDetailsModel> allDetailsList = [];
  List<BreakFastModel> breakfastList = [];
  List<BreakFastModel> lunchList = [];
  List<BreakFastModel> dinnerList = [];
  List<BreakFastModel> snacksList = [];
  int selectedIndex = 0;
  bool btnClick = false;
  DateTime? date;
  DateTime currentTime = DateTime.now();
  String? selectedTime;
  late DateTime lastDayOfMonth;
  int counter = 0;
  double calGoal = 0;
  double remainingLunchGoal = 0;
  double remainingDinnerGoal = 0;
  double remainingSnacksGoal = 0;
  double value = 0;
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalFat = 0;

  @override
  void initState() {
    getFormateDate();
    getGoal();
    getDietData();
    getRecipesData();
    allDetailsList = Constant.allDetails();
    userBox = Hive.box('userdata');
    //breakfastBox = Hive.box('breakfastData');
    print(
        "isOpen  ${userBox.isOpen}:::::::::::${userBox.length} userBOXXXXXXX");
    if (userBox.isNotEmpty) {
      getUserData();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFormateDate() {
    setState(() {
      selectedTime = DateFormat('dd-MM-yyyy').format(currentTime);
      print('selectedTime>>>>>>$selectedTime');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: MyAppBar.myAppBar(
          context, 'Today', false, () {}, () {}, primaryColor),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            DatePickerCustom(selectedTime: (DateTime time) {}),
            MySpacer.spacer30,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgress(
                            from: 0,
                            radius: 82.0,
                            color: redColor,
                            lightColor: lightredColor,
                            percentage: (getProgressData(item: 'Calories')) <
                                    2200
                                ? ((getProgressData(item: 'Calories') / 2200))
                                : 1.0,
                          ),
                          Positioned(
                              child: CircularProgress(
                            from: 0,
                            radius: 64.0,
                            color: greenColor,
                            lightColor: lightgreenColor,
                            percentage: (getProgressData(item: 'Protein')) < 65
                                ? ((getProgressData(item: 'Protein') / 65))
                                : 1.0,
                          )),
                          Positioned(
                            child: CircularProgress(
                              from: 0,
                              radius: 50.0,
                              color: blueColor1,
                              lightColor: lightblueColor,
                              percentage: (getProgressData(item: 'Carbs')) < 325
                                  ? ((getProgressData(item: 'Carbs') / 325))
                                  : 1.0,
                            ),
                          ),
                          Positioned(
                              child: CircularProgress(
                            from: 0,
                            radius: 36.0,
                            color: yellowColor,
                            lightColor: lightyellowColor,
                            percentage: (getProgressData(item: 'Fat')) < 90
                                ? ((getProgressData(item: 'Fat') / 90))
                                : 1.0,
                          )),
                        ],
                      )),
                  MySpacer.width20,
                  Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          LinearProgress(
                              from: 0,
                              text: 'Calories',
                              total: '2,200',
                              percentage: (getProgressData(item: 'Calories')) <
                                      2200
                                  ? ((getProgressData(item: 'Calories') / 2200))
                                  : 1.0,
                              subtotal:
                                  getProgressData(item: 'Calories').toString(),
                              color: redColor),
                          MySpacer.mediumspacer,
                          LinearProgress(
                              from: 0,
                              text: 'Protein',
                              total: '65',
                              percentage: (getProgressData(item: 'Protein')) <
                                      65
                                  ? ((getProgressData(item: 'Protein') / 65))
                                  : 1.0,
                              subtotal:
                                  getProgressData(item: 'Protein').toString(),
                              color: greenColor),
                          MySpacer.mediumspacer,
                          LinearProgress(
                              from: 0,
                              text: 'Carbs',
                              total: '325',
                              percentage: (getProgressData(item: 'Carbs')) < 325
                                  ? ((getProgressData(item: 'Carbs') / 325))
                                  : 1.0,
                              subtotal:
                                  getProgressData(item: 'Carbs').toString(),
                              color: blueColor1),
                          MySpacer.mediumspacer,
                          LinearProgress(
                              from: 0,
                              text: 'Fat',
                              total: '90',
                              percentage: (getProgressData(item: 'Fat')) < 90
                                  ? ((getProgressData(item: 'Fat') / 90))
                                  : 1.0,
                              subtotal: getProgressData(item: 'Fat').toString(),
                              color: yellowColor),
                        ],
                      )),
                ],
              ),
            ),
            MySpacer.spacer40,
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: allDetailsList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 26, left: 20, right: 20),
                    child: MyContainer(
                      color: whiteColor,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        allDetailsList[index].images.toString(),
                                        width: 40,
                                        height: 40,
                                      ),
                                      MySpacer.width10,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          MyRegularText(
                                            label: allDetailsList[index]
                                                .name
                                                .toString(),
                                            isHeading: true,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17,
                                          ),
                                          // MyRegularText(label: 'Goal: $calGoal calories',fontWeight: FontWeight.w500,fontSize: 15,color: Colors.grey,),
                                          MyRegularText(
                                            label:
                                                "Goal: ${allDetailsList[index].name.toString() == 'Breakfast' ? userAllList != null ? (userAllList?.caloriesGoal) : 0.0 : allDetailsList[index].name.toString() == 'Lunch' ? (userAllList != null ? remainingLunchGoal : '0.0') : allDetailsList[index].name.toString() == 'Dinner' ? (userAllList != null ? remainingDinnerGoal : '0.0') : (userAllList != null ? remainingSnacksGoal : '0.0')} calories",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            isHeading: false,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (userBox.isEmpty && calGoal == 0) {
                                        showToast(
                                          backgroundColor: blueColor,
                                          'Please choose your Daily Goal first from setting.!!',
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          position: StyledToastPosition.center,
                                        );
                                      } else {
                                        userBox.isEmpty
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddItemScreen(
                                                    name: allDetailsList[index]
                                                        .name
                                                        .toString(),
                                                    time: selectedTime,
                                                  ),
                                                ))
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddItemScreen(
                                                    name: allDetailsList[index]
                                                        .name
                                                        .toString(),
                                                    userdata: userAllList,
                                                    time: selectedTime,
                                                  ),
                                                ));
                                      }
                                    },
                                    child: MyContainer(
                                      height: 26,
                                      width: 26,
                                      borderRadius: BorderRadius.circular(30),
                                      // color: Colors.black,
                                      border: Border.all(
                                          color: textColor, width: 2.4),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: MyContainer(
                                height: 1.6,
                                width: double.infinity,
                                color: greyColor1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const MyRegularText(
                                        label: 'Calories',
                                        isHeading: false,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                      // MyRegularText(label: totalCalories.toString(),fontWeight: FontWeight.w500,fontSize: 17,),
                                      MyRegularText(
                                        label: totalCalorie(
                                                item: 'Calories',
                                                category: allDetailsList[index]
                                                    .name
                                                    .toString())
                                            .toStringAsFixed(2),
                                        isHeading: false,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const MyRegularText(
                                        label: 'Protein',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        isHeading: false,
                                        color: Colors.grey,
                                      ),
                                      MyRegularText(
                                        label: totalCalorie(
                                                item: 'Protein',
                                                category: allDetailsList[index]
                                                    .name
                                                    .toString())
                                            .toStringAsFixed(2),
                                        isHeading: false,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const MyRegularText(
                                        label: 'Carbs',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        isHeading: false,
                                        color: Colors.grey,
                                      ),
                                      MyRegularText(
                                        label: totalCalorie(
                                                item: 'Carbs',
                                                category: allDetailsList[index]
                                                    .name
                                                    .toString())
                                            .toString(),
                                        isHeading: false,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const MyRegularText(
                                        label: 'Fat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.grey,
                                        isHeading: false,
                                      ),
                                      MyRegularText(
                                        label: totalCalorie(
                                                item: 'Fat',
                                                category: allDetailsList[index]
                                                    .name
                                                    .toString())
                                            .toString(),
                                        isHeading: false,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: MyContainer(
                                height: 1.6,
                                width: double.infinity,
                                color: greyColor1,
                              ),
                            ),
                            ListView.separated(
                              separatorBuilder: (context, index) {
                                return MySpacer.spacer;
                              },
                              padding: EdgeInsets.zero,
                              itemCount: categoryList(
                                      categoryIndex: index,
                                      mainList: userAllList ?? UserDataModel())
                                  .length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index1) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: MyContainer(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              12,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              12,
                                          color: greyColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                categoryList(
                                                        categoryIndex: index,
                                                        mainList:
                                                            userAllList!)[index1]
                                                    .foodImage!,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                                      // MySpacer.width2,
                                      Flexible(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyRegularText(
                                              label: categoryList(
                                                      categoryIndex: index,
                                                      mainList:
                                                          userAllList!)[index1]
                                                  .foodName!,
                                              isHeading: true,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17,
                                              align: TextAlign.start,
                                            ),
                                            MyRegularText(
                                              label: categoryList(
                                                      categoryIndex: index,
                                                      mainList:
                                                          userAllList!)[index1]
                                                  .foodDes!,
                                              isHeading: false,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.grey,
                                              align: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                      MySpacer.width2,
                                      Flexible(
                                          flex: 1,
                                          child: InkResponse(
                                            onTap: () async {
                                              String? deviceID =
                                                  await getDeviceID(context);
                                              await Api().postUserHistory({
                                                "device_id": deviceID!
                                                    .replaceAll('.', '_'),
                                                "date": DateFormat('yyyy-MM-dd')
                                                    .format(DateTime.now())
                                                    .toString(),
                                                "history": [
                                                  categoryList(
                                                          categoryIndex: index,
                                                          mainList:
                                                              userAllList!)[index1]
                                                      .calories,
                                                  categoryList(
                                                          categoryIndex: index,
                                                          mainList:
                                                              userAllList!)[index1]
                                                      .protein,
                                                  categoryList(
                                                          categoryIndex: index,
                                                          mainList:
                                                              userAllList!)[index1]
                                                      .carbs,
                                                  categoryList(
                                                          categoryIndex: index,
                                                          mainList:
                                                              userAllList!)[index1]
                                                      .fat
                                                ].join(','),
                                                "isAdd": "false"
                                              });
                                              setState(() {
                                                print(categoryList(
                                                        categoryIndex: index,
                                                        mainList:
                                                            userAllList!)[index1]
                                                    .calories);
                                                categoryList(
                                                        categoryIndex: index,
                                                        mainList: userAllList!)
                                                    .removeAt(index1);
                                              });
                                              await updateDataOnHive(
                                                time: selectedTime!,
                                                mainList: userAllList!,
                                                hive: userBox,
                                              ).whenComplete(() => {});
                                            },
                                            child: const Icon(
                                              Icons.cancel_outlined,
                                              color: orangeColor,
                                              size: 22,
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getDietData() async {
    // await Api().loadDietJson(context);
    await Api().fetchFoodList();
    print('Api loadDietJson calling');
  }

  Future<void> getRecipesData() async {
    // await Api().loadDietRecipes(context);
    await Api().fetchRecipeList();
    await Api().fetchRecipeIdeas();
    print('Api  loadDietRecipes  calling');
  }

  getGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      calGoal = prefs.getInt('caloriesGoal')?.toDouble() ?? 0.0;
    });
    print('calGoal$calGoal>>');
  }

  totalCalorie({String? item, String? category}) {
    totalCalories = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFat = 0;
    if (breakfastList.isNotEmpty && category == 'Breakfast') {
      value = Constant.totalItemsCalories(list: breakfastList, item: item);
      if (item == 'Calories') {
        remainingLunchGoal = calGoal -
            Constant.totalItemsCalories(list: breakfastList, item: item);
        if (remainingLunchGoal.isNegative) {
          remainingLunchGoal = 0;
        } else {
          remainingLunchGoal;
        }
      }
    } else if (lunchList.isNotEmpty && category == 'Lunch') {
      value = Constant.totalItemsCalories(list: lunchList, item: item);
      if (item == 'Calories') {
        remainingDinnerGoal = remainingLunchGoal -
            Constant.totalItemsCalories(list: lunchList, item: item);
        if (remainingDinnerGoal.isNegative) {
          remainingDinnerGoal = 0;
        } else {
          remainingDinnerGoal;
        }
      }
    } else if (dinnerList.isNotEmpty && category == 'Dinner') {
      value = Constant.totalItemsCalories(list: dinnerList, item: item);
      if (item == 'Calories') {
        remainingSnacksGoal = remainingDinnerGoal -
            Constant.totalItemsCalories(list: dinnerList, item: item);
        if (remainingSnacksGoal.isNegative) {
          remainingSnacksGoal = 0;
        } else {
          remainingSnacksGoal;
        }
      }
    } else {
      value = Constant.totalItemsCalories(list: snacksList, item: item);
    }
    return value;
  }

  getProgressData({String? item}) {
    totalCalories = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFat = 0;
    if (item == 'Calories') {
      for (int i = 0; i < allDetailsList.length; i++) {
        totalCalories +=
            totalCalorie(item: 'Calories', category: allDetailsList[i].name);
      }
    } else if (item == 'Protein') {
      for (int i = 0; i < allDetailsList.length; i++) {
        totalProtein +=
            totalCalorie(item: 'Protein', category: allDetailsList[i].name);
      }
    } else if (item == 'Carbs') {
      for (int i = 0; i < allDetailsList.length; i++) {
        totalCarbs +=
            totalCalorie(item: 'Carbs', category: allDetailsList[i].name);
      }
    } else {
      for (int i = 0; i < allDetailsList.length; i++) {
        totalFat += totalCalorie(item: 'Fat', category: allDetailsList[i].name);
      }
    }
    return item == 'Calories'
        ? (totalCalories.round())
        : item == 'Protein'
            ? (totalProtein.round())
            : item == 'Carbs'
                ? (totalCarbs.round())
                : (totalFat.round());
  }

  showUserData() {
    breakfastList.clear();
    lunchList.clear();
    dinnerList.clear();
    snacksList.clear();

    breakfastList.addAll(userAllList!.breakfastList!);
    lunchList.addAll(userAllList!.lunchList!);
    dinnerList.addAll(userAllList!.dinnerList!);
    snacksList.addAll(userAllList!.snacksList!);
    totalCalorie();
    print('breakfastList:::${breakfastList.length}');
    print('lunchList:::${lunchList.length}');
    print('carbsList:::${dinnerList.length}');
    print('fatList:::${snacksList.length}');
  }

  getUserData() async {
    print('ok......');
    dynamic newUserData = userBox.get(selectedTime);
    //print('newUserData??${newUserData.first.timestamp}');

    userAllList = newUserData;

    log("breakfastList::: >> ${userAllList?.breakfastList}");
    log("dinnerList::: >> ${userAllList?.dinnerList}");
    log("snacksList::: >> ${userAllList?.snacksList}");
    log("lunchList::: >> ${userAllList?.lunchList}");

    await currentDay();
    showUserData();
  }

  addItemData() async {
    print('add new item here>>>');
    int latestIndex = userBox.values.toList().indexWhere((element) =>
        (DateFormat('dd-MM-yyyy').parseStrict(element.timestamp!)).isBefore(
            DateFormat('dd-MM-yyyy').parseStrict(selectedTime.toString())));

    log("latestIndex::: >> $latestIndex");

    UserDataModel previousData = userBox.getAt(latestIndex);
    UserDataModel newData = UserDataModel(
        timestamp: selectedTime.toString(),
        breakfastList: previousData.breakfastList,
        caloriesGoal: previousData.caloriesGoal,
        dinnerList: previousData.dinnerList,
        lunchList: previousData.lunchList,
        snacksList: previousData.snacksList);
    print(
        'check it::${newData.breakfastList!.length} :::${selectedTime.toString()}');
    await userBox
        .put(selectedTime.toString(), newData)
        .whenComplete(() => setState(() {
              btnClick = false;
              getUserData();
              /* Box boxDAta = Hive.box('userdata');
              userAllList.clear();
              userAllList.addAll(boxDAta.values.map((e) => e));*/
            }));

    //getUserData();
  }

  Future<void> currentDay() async {
    if (!userBox.containsKey(selectedTime)) {
      log("DATA COPEDDDDDD ON ", error: true);
      await addItemData();
    }
  }
}
