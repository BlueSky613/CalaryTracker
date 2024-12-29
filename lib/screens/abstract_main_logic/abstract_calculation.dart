import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:ketodiet/model/hive/userdata/breakfastmodel/breakfastmodel.dart';

import '../../model/hive/userdata/userdatamodel.dart';

mixin class CalCulation {
  List<BreakFastModel> categoryList(
      {required int categoryIndex, required UserDataModel mainList}) {
    switch (categoryIndex) {
      case 0:
        return mainList.breakfastList ?? [];
      case 1:
        return mainList.lunchList ?? [];
      case 2:
        return mainList.dinnerList ?? [];
      default:
        return mainList.snacksList ?? [];
    }
  }

  navigateTOSelection(
      {required int categoryIndex,
      required int curruntIndex,
      required UserDataModel mainList}) {
    switch (categoryIndex) {
      case 0:
        return mainList.breakfastList ?? [];
      case 1:
        return mainList.lunchList ?? [];
      case 2:
        return mainList.dinnerList ?? [];
      default:
        return mainList.snacksList ?? [];
    }
  }

  Future updateDataOnHive(
      {required String time,
      required UserDataModel mainList,
      required Box hive}) async {
    if (isListInDataAvlablOrNotCheck(
        userAllList: mainList, selectedTime: time)) {
      await hive.delete(mainList.timestamp);
      return;
    } else {
      return await hive.put(time, mainList);
    }
    /*  await hive
        .putAt(curruntIndex, mainList[curruntIndex])
        .then((value) => value);*/
  }

  bool isListInDataAvlablOrNotCheck(
      {required UserDataModel userAllList, required String selectedTime}) {
    if (userAllList.timestamp == selectedTime &&
        isNullEmptyOrFalse(userAllList.lunchList) &&
        isNullEmptyOrFalse(userAllList.dinnerList) &&
        isNullEmptyOrFalse(userAllList.snacksList) &&
        isNullEmptyOrFalse(userAllList.breakfastList)) {
      return true;
    } else {
      return false;
    }
  }

  bool isNullEmptyOrFalse(dynamic o) {
    if (o is Map<String, dynamic> || o is List<dynamic>) {
      return o == null || o.length == 0;
    }
    return o == null || false == o || "" == o;
  }
}
