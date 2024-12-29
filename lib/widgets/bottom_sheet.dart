import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:ketodiet/api/api.dart';
import 'package:ketodiet/model/diet_response.dart';
import 'package:ketodiet/model/hive/userdata/breakfastmodel/breakfastmodel.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';
import 'package:ketodiet/screens/homemain/homemain.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/widgets/circularprogress.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mybutton.dart';
import 'package:ketodiet/utils/payment.dart';

class MyBottomSheet extends StatefulWidget {
  final DataBean? foodData;
  String? name;
  UserDataModel? userdata;
  String? time;
  MyBottomSheet({Key? key, this.foodData, this.name, this.userdata, this.time})
      : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  DateTime? dateTime;
  late final Box userBox;

  //UserDataModel? userAllList;
  List<dynamic> categoryList = [];
  List<BreakFastModel> breakfastList = [];
  List<BreakFastModel> lunchList = [];
  List<BreakFastModel> dinnerList = [];
  List<BreakFastModel> snacksList = [];
  int currentIndex = -1;
  DateTime? date;
  int calGoal = 0;

  @override
  void initState() {
    // print('time ishere>>${widget.time} >>> ${widget.currentIndex}');
    getGoal();
    super.initState();
    userBox = Hive.box('userdata');
    if (userBox.isNotEmpty) {
      getUserData();
      getBreakfastData();
    }
    print(" userBox isOpen  ${userBox.isOpen}:::::::::::${userBox.length}");
    // print("breakfastBox isOpen  ${breakfastBox.isOpen}:::::::::::${breakfastBox.length} :: ${widget.name}");
  }

  getUserData() {
    List newUserData = userBox.values.toList();
    // userAllList.addAll(newUserData);
    //print('userAllList:::${userAllList.length}');
  }

  getBreakfastData() {
    breakfastList.clear();
    lunchList.clear();
    dinnerList.clear();
    snacksList.clear();

    breakfastList.addAll(widget.userdata?.breakfastList ?? []);
    lunchList.addAll(widget.userdata?.lunchList ?? []);
    dinnerList.addAll(widget.userdata?.dinnerList ?? []);
    snacksList.addAll(widget.userdata?.snacksList ?? []);

    print('breakfastList:::${breakfastList.length}');
    print('lunchList:::${lunchList.length}');
    print('carbsList:::${dinnerList.length}');
    print('fatList:::${snacksList.length}');
  }

  getGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      calGoal = prefs.getInt('caloriesGoal')!;
    });
    print('calGoal$calGoal>>');
  }

  addBreakfastData() async {
    String? deviceID = await getDeviceID(context);
    BreakFastModel additems = BreakFastModel(
      category: widget.name,
      //timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      //timestamp: widget.time!.toString(),
      calories: widget.foodData!.calories!.toString(),
      protein: widget.foodData!.macronutrients!.protein!.toString(),
      carbs: widget.foodData!.macronutrients!.carbohydrates!.toString(),
      fat: widget.foodData!.macronutrients!.fat!.toString(),
      foodName: widget.foodData!.name!,
      foodDes: widget.foodData!.servingSize!,
      foodImage: widget.foodData!.image!,
      date: widget.time!,
      time: DateFormat(' HH:mm a').format(DateTime.now()).toString(),
    );
    await Api().postUserHistory({
      "device_id": deviceID!.replaceAll('.', '_'),
      "date": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      "history": [
        additems.calories,
        additems.protein,
        additems.carbs,
        additems.fat
      ].join(','),
      "isAdd": "true"
    });
    print("wwwwwwwwwwwwwwwwwwwww>>>>>>>>>>>>>>>>>>>${additems.calories}");
    print(
        "time>>>>>>>>>${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}");
    //breakfastBox.put(DateTime.now().millisecondsSinceEpoch.toString(), additems);
    //  breakfastBox.put(widget.time!.toString(), additems);
    if (widget.name == 'Breakfast') {
      breakfastList.add(additems);
    } else if (widget.name == 'Lunch') {
      lunchList.add(additems);
    } else if (widget.name == 'Dinner') {
      dinnerList.add(additems);
    } else {
      snacksList.add(additems);
    }
  }

  addItemData() {
    print('date is....${widget.time}');
    print('breakfastList:@::${breakfastList.length}');
    print('lunchList:@::${lunchList.length}');
    print('carbsList:@::${dinnerList.length}');
    print('fatList:@::${snacksList.length}');
    UserDataModel addItemData = UserDataModel(
      lunchList: lunchList,
      snacksList: snacksList,
      dinnerList: dinnerList,
      breakfastList: breakfastList,
      caloriesGoal: calGoal.toString(),
      timestamp: widget.time,
    );
    setState(() {
      if (userBox.isNotEmpty) {
        print("my date:::::${widget.time}");
        if (widget.userdata!.timestamp! == widget.time!) {
          print('old index update');

          userBox.put(widget.time, addItemData);
        }
      } else {
        print('new index create >>>>>>>${widget.time!}');
        // userBox.put(DateTime.now().millisecondsSinceEpoch.toString(), addItemData);
        userBox.put(widget.time, addItemData);
      }
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeMain(
            from: 1,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: MyContainer(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.height / 6,
              color: greyColor,
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.foodData!.image!,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyRegularText(
                  isHeading: true,
                  label: widget.foodData!.name!,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  maxlines: 3,
                  align: TextAlign.start,
                ),
                MySpacer.minispacer,
                MyRegularText(
                  isHeading: false,
                  label: widget.foodData!.servingSize!,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  maxlines: 10,
                  align: TextAlign.start,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 16, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircularProgress(
                    from: 1,
                    color: redColor,
                    lightColor: lightredColor,
                    percentage: widget.foodData!.calories!.toDouble(),
                    text: 'Calories'),
                CircularProgress(
                    from: 1,
                    color: greenColor,
                    lightColor: lightgreenColor,
                    percentage:
                        double.parse(widget.foodData!.macronutrients!.protein!),
                    text: 'Protein'),
                CircularProgress(
                    from: 1,
                    color: blueColor1,
                    lightColor: lightblueColor,
                    percentage: double.parse(
                        widget.foodData!.macronutrients!.carbohydrates!),
                    text: 'Carbs'),
                CircularProgress(
                    from: 1,
                    color: yellowColor,
                    lightColor: lightyellowColor,
                    percentage:
                        double.parse(widget.foodData!.macronutrients!.fat!),
                    text: 'Fat'),
              ],
            ),
          ),
          const MyContainer(
            height: 2,
            width: double.infinity,
            color: greyColor1,
          ),
          MySpacer.mediumspacer,
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const MyRegularText(
                  isHeading: true,
                  label: 'Date & Time',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // DateTime? newDateTime =
                        /*await showRoundedDatePicker(
                          context: context,
                          height: 300,
                          styleDatePicker:
                          MaterialRoundedDatePickerStyle(
                              backgroundHeader: Colors.black12,
                              paddingDateYearHeader:
                              const EdgeInsets.all(10),
                              decorationDateSelected:
                              const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle),
                              textStyleMonthYearHeader:
                              const TextStyle(
                                  color: textColor),
                              textStyleDayHeader:
                              const TextStyle(
                                  color: textColor),
                              textStyleCurrentDayOnCalendar:
                              const TextStyle(
                                  color: Colors.orange),
                              textStyleDayButton:
                              const TextStyle(
                                  color: Colors.red),
                              textStyleYearButton:
                              const TextStyle(
                                  color: whiteColor),
                              textStyleButtonPositive:
                              const TextStyle(
                                  color: whiteColor),
                              textStyleButtonNegative:
                              const TextStyle(
                                  color: whiteColor),
                              backgroundPicker: Colors.white54),
                          background: Colors.white30,
                          initialDate: DateTime.now(),
                          firstDate:DatePickerCustomState.currentMonthList.first,
                          lastDate: DateTime.now(),
                          borderRadius: 20,
                        );*/
                        /*   if (widget.time != null) {
                          setState(() {
                            dateTime = widget.time;
                          });
                          print('dateTime>>>>$dateTime');
                        }*/
                      },
                      child: MyContainer(
                        color: lightColor,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MyRegularText(
                            isHeading: false,
                            // label: DateFormat('MMM d, yyyy').format(widget.time!).toString(),
                            label: widget.time! ?? '',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    MySpacer.width10,
                    MyContainer(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: MyRegularText(
                          isHeading: false,
                          label: DateFormat(' HH:mm a')
                              .format(DateTime.now())
                              .toString(),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          maxlines: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: MyButton(
              onTap: () async {
                await addBreakfastData();
                await addItemData();
              },
              btntext: 'Add Item',
            ),
          ),
        ],
      ),
    );
  }
}
