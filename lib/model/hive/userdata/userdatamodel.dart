
import 'package:hive/hive.dart';
import 'package:ketodiet/model/hive/userdata/breakfastmodel/breakfastmodel.dart';
part 'userdatamodel.g.dart';

@HiveType(typeId: 0)
class UserDataModel extends HiveObject{


  @HiveField(0)
  String? timestamp;

  @HiveField(1)
  List<BreakFastModel>? breakfastList;

  @HiveField(2)
  List<BreakFastModel>? lunchList;

  @HiveField(3)
  List<BreakFastModel>? dinnerList;

  @HiveField(4)
  List<BreakFastModel>? snacksList;


  @HiveField(5)
  String? caloriesGoal;

  UserDataModel(
      {this.timestamp,
      this.breakfastList,
      this.lunchList,
      this.dinnerList,
      this.snacksList,
      this.caloriesGoal});
}