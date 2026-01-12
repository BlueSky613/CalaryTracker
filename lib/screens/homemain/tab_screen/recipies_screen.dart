import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ketodiet/model/dietrecipes_response.dart';
import 'package:ketodiet/model/diet_response.dart' as diet_classes;
import 'package:ketodiet/model/hive/userdata/breakfastmodel/breakfastmodel.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/utils/sessionmanager.dart';
import 'package:ketodiet/widgets/bottom_sheet.dart';
import 'package:ketodiet/widgets/myappbar.dart';
import 'package:ketodiet/widgets/mybutton.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipiesScreen extends StatefulWidget {
  const RecipiesScreen({Key? key}) : super(key: key);

  @override
  State<RecipiesScreen> createState() => _RecipiesScreenState();
}

class _RecipiesScreenState extends State<RecipiesScreen> {
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  FoodDataBean? breakFast;
  FoodDataBean? lunch;
  FoodDataBean? dinner;
  FoodDataBean? snacks;

  List<RecipesBean> allDataList = [];
  bool veg = true;
  var day;
  int weekday = 1;

  @override
  void initState() {
    getCurrentWeek();
    getFoodPref();
    getRecipesData();
    super.initState();
  }

  getCurrentWeek() {
    setState(() {
      DateTime now = DateTime.now();
      weekday = now.weekday;
      print('current week:>>>$weekday');
    });
  }

  getFoodPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      veg = prefs.getBool('vegetarian') ?? false;
      print('vegeterian>>>>>$veg');
    });
  }

  Future<void> getRecipesData() async {
    SessionManager manager = SessionManager();
    DietrecipesResponse? getRecipesList =
        await manager.getDietRecipesResponse();
    if (getRecipesList!.recipes!.isNotEmpty) {
      setState(() {
        day = DateFormat(DateFormat.WEEKDAY).format(DateTime.now());
      });
      print(
          'length>>>>${getRecipesList.recipes![0].Veg!.Breakfast!.length} >>>>>$day');
      print(
          'day>>>>${getRecipesList.recipes![0].Veg!.Breakfast![0].Day} >>>>>$day');

      for (int i = 0;
          i < getRecipesList.recipes![0].Veg!.Breakfast!.length;
          i++) {
        int dayOfWeek = weekday - 1;
        if (veg == true) {
          print(
              'day>>>>${getRecipesList.recipes![0].Veg!.Breakfast![0].Title} >>>>>$day');
          breakFast = (getRecipesList.recipes![0].Veg?.Breakfast ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          lunch = (getRecipesList.recipes![0].Veg?.Lunch ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          dinner = (getRecipesList.recipes![0].Veg?.Dinner ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          snacks = (getRecipesList.recipes![0].Veg?.Snacks ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          print('breakFast>>veg>>${breakFast!.Title}>>${dinner?.Title}');
        } else {
          breakFast = (getRecipesList.recipes![0].NonVeg?.Breakfast ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          lunch = (getRecipesList.recipes![0].NonVeg?.Lunch ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          dinner = (getRecipesList.recipes![0].NonVeg?.Dinner ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          snacks = (getRecipesList.recipes![0].NonVeg?.Snacks ?? [])
              .firstWhere((o) => o.Day!.startsWith(days[dayOfWeek]));
          print('breakFast>>nonveg>>${breakFast!.Title}>>${dinner?.Title}');
        }
      }
    } else {
      print('Null data');
    }
  }

  bottomSheet(String name, FoodDataBean dataBean) async {
    String selectedTime = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Box userBox = Hive.box('userdata');
    dynamic newUserData = userBox.get(selectedTime);
    //print('newUserData??${newUserData.first.timestamp}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double calGoal = prefs.getInt('caloriesGoal')?.toDouble() ?? 0.0;

    if (userBox.isEmpty && calGoal == 0) {
      showToast(
        backgroundColor: blueColor,
        'Please choose your Daily Goal first from setting.!!',
        context: context,
        animation: StyledToastAnimation.scale,
        position: StyledToastPosition.center,
      );
      return;
    }

    UserDataModel? userAllList = newUserData;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(25),
            topStart: Radius.circular(35),
          ),
        ),
        builder: (context) => MyBottomSheet(
            foodData: diet_classes.DataBean.fromMap({
              'name': dataBean.Title,
              'image': dataBean.image,
              'preference': 'veg',
              'calories': int.parse(dataBean.totalCalories ?? '0'),
              'serving_size': dataBean.Ingredients,
              'macronutrients': {
                'protein': dataBean.protein,
                'carbohydrates': dataBean.carb,
                'fat': dataBean.fat
              }
            }),
            name: name,
            userdata: userAllList,
            time: selectedTime));
  }

  // addMealData(String mealType, FoodDataBean dataBean) {
  //   BreakFastModel additems = BreakFastModel(
  //     category: mealType,
  //     calories: dataBean.totalCalories ?? '0',
  //     protein: dataBean.protein ?? '0',
  //     carbs: dataBean.carb ?? '0',
  //     fat: dataBean.fat ?? '0',
  //     foodName: dataBean.Title ?? '',
  //     foodDes: '',
  //     foodImage: dataBean.image,
  //     date: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
  //     time: DateFormat(' HH:mm a').format(DateTime.now()).toString(),
  //   );
  //   //breakfastBox.put(DateTime.now().millisecondsSinceEpoch.toString(), additems);
  //   //  breakfastBox.put(widget.time!.toString(), additems);
  //   if (mealType == 'Breakfast') {
  //     breakfastList.add(additems);
  //   } else if (mealType == 'Lunch') {
  //     lunchList.add(additems);
  //   } else if (mealType == 'Dinner') {
  //     dinnerList.add(additems);
  //   } else {
  //     snacksList.add(additems);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: MyAppBar.myAppBar(
          context, 'Recipes', false, () {}, () {}, primaryColor),
      body: day == null
          ? const Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 7.9,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 12,
                            );
                          },
                          padding: const EdgeInsets.all(0.0),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 7,
                          itemBuilder: (BuildContext context, int index) {
                            return MyContainer(
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.height / 6,
                              color: textColor1,
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: MyRegularText(
                                        isHeading: true,
                                        label: days[index],
                                        fontSize: 15,
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  MySpacer.minispacer,
                                  weekday == (index + 1)
                                      ? const Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: whiteColor,
                                        )
                                      : const Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: textColor1,
                                        ),
                                  MySpacer.minispacer,
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        MySpacer.spacer,
                        MyRegularText(
                          isHeading: true,
                          label: '$day Schedules',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          align: TextAlign.start,
                        ),
                        MySpacer.spacer,
                        MyContainer(
                          width: double.infinity,
                          color: greycontainerColor,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'BreakFast:',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.mediumspacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.Title ?? '',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      maxlines: 10,
                                      align: TextAlign.start,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Ingredients:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.Ingredients ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Instructions:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.Instructions ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Calories',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.totalCalories ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Protein',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.protein ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Carbs',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.carb ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Fat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: breakFast?.fat ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    breakFast?.Title != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 12.0),
                                            child: MyButton(
                                              onTap: () {
                                                bottomSheet(
                                                    'Breakfast', breakFast!);
                                              },
                                              btntext: 'ADD TO BREAKFAST',
                                            ),
                                          )
                                        : MySpacer.minispacer
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        MySpacer.spacer30,
                        MyContainer(
                          width: double.infinity,
                          color: greycontainerColor,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Lunch:',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.mediumspacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.Title ?? '',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      maxlines: 10,
                                      align: TextAlign.start,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Ingredients:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.Ingredients ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Instructions:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.Instructions ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Calories',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.totalCalories ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Protein',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.protein ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Carbs',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.carb ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Fat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: lunch?.fat ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    lunch?.Title != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 12.0),
                                            child: MyButton(
                                              onTap: () {
                                                bottomSheet('Lunch', lunch!);
                                              },
                                              btntext: 'ADD TO LUNCH',
                                            ),
                                          )
                                        : MySpacer.minispacer
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        MySpacer.spacer30,
                        MyContainer(
                          width: double.infinity,
                          color: greycontainerColor,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Dinner:',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.mediumspacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.Title ?? '',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      maxlines: 10,
                                      align: TextAlign.start,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Ingredients:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.Ingredients ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Instructions:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.Instructions ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Calories',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.totalCalories ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Protein',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.protein ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Carbs',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.carb ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Fat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: dinner?.fat ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    dinner?.Title != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 12.0),
                                            child: MyButton(
                                              onTap: () {
                                                bottomSheet('Dinner', dinner!);
                                              },
                                              btntext: 'ADD TO DINNER',
                                            ),
                                          )
                                        : MySpacer.minispacer
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        MySpacer.spacer30,
                        MyContainer(
                          width: double.infinity,
                          color: greycontainerColor,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Snacks:',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.mediumspacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.Title ?? '',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      maxlines: 10,
                                      align: TextAlign.start,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Ingredients:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.Ingredients ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Instructions:',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.Instructions ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Calories',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.totalCalories ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Protein',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.protein ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Carbs',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.carb ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    MySpacer.minispacer,
                                    const MyRegularText(
                                      isHeading: true,
                                      label: 'Fat',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    MySpacer.minispacer,
                                    MyRegularText(
                                      isHeading: false,
                                      label: snacks?.fat ?? '',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      align: TextAlign.start,
                                      maxlines: 30,
                                    ),
                                    snacks?.Title != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0,
                                                right: 12.0,
                                                top: 12.0),
                                            child: MyButton(
                                              onTap: () {
                                                bottomSheet('Snacks', snacks!);
                                              },
                                              btntext: 'ADD TO SNACKS',
                                            ),
                                          )
                                        : MySpacer.minispacer
                                  ],
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
                  ],
                ),
              ),
            ),
    );
  }
}
