import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ketodiet/model/dietrecipes_response.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/widgets/bottom_sheet.dart';
import 'package:ketodiet/widgets/myappbar.dart';
import 'package:ketodiet/widgets/mybutton.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ketodiet/model/diet_response.dart' as diet_classes;

class RecipeIdeasScreen extends StatelessWidget {
  dynamic recipe;
  RecipeIdeasScreen({this.recipe, Key? key}) : super(key: key);

  bottomSheet(BuildContext context, String name, FoodDataBean? dataBean) async {
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
            topEnd: Radius.circular(30),
            topStart: Radius.circular(30),
          ),
        ),
        builder: (context) => MyBottomSheet(
            foodData: diet_classes.DataBean.fromMap({
              'name': dataBean?.Title,
              'image': dataBean?.image,
              'preference': 'veg',
              'calories': int.parse(dataBean?.totalCalories ?? '0'),
              'serving_size': dataBean?.Ingredients,
              'macronutrients': {
                'protein': dataBean?.protein,
                'carbohydrates': dataBean?.carb,
                'fat': dataBean?.fat
              }
            }),
            name: name,
            userdata: userAllList,
            time: selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    String imageURL = recipe?['recipe_pic']?.length > 0
        ? (recipe?['recipe_pic']?[0])
        : 'http://diet.backend.marketmajesty.net/upload/recipe.jpg';
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: MyAppBar.myAppBar(context, 'Recipe Ideas', true, () {
          Navigator.pop(context);
        }, () {}, primaryColor),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(imageURL, fit: BoxFit.cover))),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Title:',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              MySpacer.minispacer,
              MyRegularText(
                isHeading: false,
                label: recipe?['name'] ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                maxlines: 10,
                align: TextAlign.start,
              ),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Ingredients:',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              MySpacer.mediumspacer,
              MyRegularText(
                isHeading: false,
                label: recipe?['ingredients']?.replaceAll(r'\n', '\n') ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                maxlines: 10,
                align: TextAlign.start,
              ),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Description:',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              MySpacer.mediumspacer,
              MyRegularText(
                isHeading: false,
                label: recipe?['description']?.replaceAll(r'\n', '\n') ?? '',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                maxlines: 10,
                align: TextAlign.start,
              ),
              MySpacer.minispacer,
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
                child: MyButton(
                  onTap: () {
                    bottomSheet(context, recipe?['meal_type'],
                        FoodDataBean.fromMap(recipe));
                  },
                  btntext:
                      'ADD TO ${(recipe?['meal_type'] ?? '').toUpperCase()}',
                ),
              ),
              MySpacer.minispacer,
            ],
          ),
        )));
  }
}
