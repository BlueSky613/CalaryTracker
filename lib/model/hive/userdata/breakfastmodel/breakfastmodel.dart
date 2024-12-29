import 'package:hive/hive.dart';

part 'breakfastmodel.g.dart';

@HiveType(typeId: 1)
class BreakFastModel extends HiveObject {
  @HiveField(1)
  String? foodImage;

  @HiveField(2)
  String? foodName;

  @HiveField(3)
  String? foodDes;

  @HiveField(4)
  String? calories;

  @HiveField(5)
  String? protein;

  @HiveField(6)
  String? carbs;

  @HiveField(7)
  String? fat;

  @HiveField(8)
  String? date;

  @HiveField(9)
  String? time;

  @HiveField(10)
  String? category;

  factory BreakFastModel.genrateHiveWithKey(Map<String, dynamic> json) =>
      BreakFastModel(
        foodImage: json["foodImage"],
        foodName: json["foodName"],
        foodDes: json["foodDes"],
        calories: json["calories"],
        protein: json["protein"],
        carbs: json["carbs"],
        fat: json["fat"],
        date: json["date"],
        time: json["time"],
        category: json["category"],
      );

  BreakFastModel(
      {this.foodImage,
      this.foodName,
      this.foodDes,
      this.calories,
      this.protein,
      this.carbs,
      this.fat,
      this.date,
      this.time,
      this.category});
}
