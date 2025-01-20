import 'package:ketodiet/model/alldetailsmodel.dart';
import 'package:ketodiet/model/hive/userdata/userdatamodel.dart';

class Constant {
  static List<AllDetailsModel> allDetailsList = [];
  static int selectedDateCurrentIndex = -1;
  static double totalCalories = 0;
  static double totalProtein = 0;
  static double totalCarbs = 0;
  static double totalFat = 0;
  static double value = 0.0;
  static List<dynamic>? periodDate = [];
  static double remainingLunchGoal = 0.0;
  static double remainingDinnerGoal = 0.0;
  static double remainingSnacksGoal = 0.0;
  static double calGoal = 0.0;
  static String barcodeLookupURL =
      "https://world.openfoodfacts.net/api/v3/product";
  static String barcodeLookupApiKey = "qkh6u7fnsyauj8dv6kh3ao4wl6ji80";
  // static String apiURL = "https://diet.backend.marketmajesty.net/api";
  static String apiURL = "https://bright-annually-drake.ngrok-free.app/api";

  static allDetails() {
    allDetailsList.clear();
    allDetailsList.add(AllDetailsModel(
      id: 0,
      name: 'Breakfast',
      images: 'assets/images/svg/breakfast.svg',
    ));
    allDetailsList.add(AllDetailsModel(
      id: 0,
      name: 'Lunch',
      images: 'assets/images/svg/lunch.svg',
    ));
    allDetailsList.add(AllDetailsModel(
      id: 0,
      name: 'Dinner',
      images: 'assets/images/svg/moon.svg',
    ));
    allDetailsList.add(AllDetailsModel(
      id: 0,
      name: 'Snacks',
      images: 'assets/images/svg/snack.svg',
    ));

    return allDetailsList;
  }

  static double totalItemsCalories({list, item}) {
    totalCalories = 0;
    totalProtein = 0;
    totalCarbs = 0;
    totalFat = 0;
    for (int i = 0; i < list.length; i++) {
      if (item == 'Calories') {
        totalCalories = totalCalories + double.parse(list[i].calories!);
      } else if (item == 'Protein') {
        print('breakfast avg>>$totalProtein');
        totalProtein = totalProtein + double.parse(list[i].protein!);
      } else if (item == 'Carbs') {
        totalCarbs = totalCarbs + double.parse(list[i].carbs!);
      } else {
        totalFat = totalFat + double.parse(list[i].fat!);
      }
    }
    if (item == 'Calories') {
      return totalCalories;
    } else if (item == 'Protein') {
      return totalProtein;
    } else if (item == 'Carbs') {
      return totalCarbs;
    } else {
      return totalFat;
    }
  }

  static double totalCalorie(
      {String? item,
      List<UserDataModel>? list,
      bool? isAvg,
      UserDataModel? data}) {
    double breakfastAvg = 0.0;
    double lunchAvg = 0.0;
    double dinnerAvg = 0.0;
    double snacksAvg = 0.0;

    if (list != null) {
      if (isAvg == true) {
        for (int i = 0; i < list.length; i++) {
          print('protein>     >>>${list[i].breakfastList}');
          breakfastAvg = breakfastAvg +
              totalItemsCalories(list: list[i].breakfastList, item: item);
          lunchAvg = lunchAvg +
              totalItemsCalories(list: list[i].lunchList, item: item);
          dinnerAvg = dinnerAvg +
              totalItemsCalories(list: list[i].dinnerList, item: item);
          snacksAvg = snacksAvg +
              totalItemsCalories(list: list[i].snacksList, item: item);
        }
        value = breakfastAvg + lunchAvg + dinnerAvg + snacksAvg;
        // print('breakfastAvg>>>>>$breakfastAvg>>>$lunchAvg>>>$dinnerAvg>>>$snacksAvg');
      } else {
        breakfastAvg =
            totalItemsCalories(list: data!.breakfastList, item: item);
        lunchAvg = totalItemsCalories(list: data.lunchList, item: item);
        dinnerAvg = totalItemsCalories(list: data.dinnerList, item: item);
        snacksAvg = totalItemsCalories(list: data.snacksList, item: item);
        value = breakfastAvg + lunchAvg + dinnerAvg + snacksAvg;
        print(
            'breakfastAvg>>>>>$breakfastAvg>>>$lunchAvg>>>$dinnerAvg>>>$snacksAvg');
        print('Avg>>>>>$value');
      }
    }
    return double.parse(value.toStringAsFixed(2));
  }
}
