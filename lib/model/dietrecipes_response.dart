class DietrecipesResponse {
  List<RecipesBean>? recipes;

  static DietrecipesResponse? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DietrecipesResponse dietrecipesResponseBean = DietrecipesResponse();
    dietrecipesResponseBean.recipes = [
      ...(map['recipes'] as List ?? []).map((o) => RecipesBean.fromMap(o)!)
    ];
    return dietrecipesResponseBean;
  }

  Map toJson() => {
        "recipes": recipes,
      };
}

class RecipesBean {
  DataBean? Veg;
  DataBean? NonVeg;

  static RecipesBean? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    RecipesBean recipesBean = RecipesBean();
    recipesBean.Veg = DataBean.fromMap(map['Veg']);
    recipesBean.NonVeg = DataBean.fromMap(map['NonVeg']);
    return recipesBean;
  }

  Map toJson() => {
        "Veg": Veg,
        "NonVeg": NonVeg,
      };
}

class DataBean {
  List<FoodDataBean>? Breakfast;
  List<FoodDataBean>? Lunch;
  List<FoodDataBean>? Dinner;
  List<FoodDataBean>? Snacks;

  static DataBean? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    DataBean nonVegBean = DataBean();
    nonVegBean.Breakfast = [
      ...(map['Breakfast'] as List ?? []).map((o) => FoodDataBean.fromMap(o)!)
    ];
    nonVegBean.Lunch = [
      ...(map['Lunch'] as List ?? []).map((o) => FoodDataBean.fromMap(o)!)
    ];
    nonVegBean.Dinner = [
      ...(map['Dinner'] as List ?? []).map((o) => FoodDataBean.fromMap(o)!)
    ];
    nonVegBean.Snacks = [
      ...(map['Snacks'] as List ?? []).map((o) => FoodDataBean.fromMap(o)!)
    ];
    return nonVegBean;
  }

  Map toJson() => {
        "Breakfast": Breakfast,
        "Lunch": Lunch,
        "Dinner": Dinner,
        "Snacks": Snacks,
      };
}

class FoodDataBean {
  String? Day;
  String? Title;
  String? Ingredients;
  String? Instructions;
  String? totalCalories;
  String? protein;
  String? carb;
  String? fat;
  String? image;

  static FoodDataBean? fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    FoodDataBean snacksBean = FoodDataBean();

    String imageURL = map['recipe_pic'] != null && map['recipe_pic']?.length > 0
        ? (map['recipe_pic']?[0])
        : 'assets/images/recipe.jpg';
    snacksBean.Day = map['Day'] ?? map['day_of_week'];
    snacksBean.Title = map['Title'] ?? map['name'];
    snacksBean.Ingredients =
        map['Ingredients'] ?? map['ingredients'].replaceAll(r'\n', '\n');
    snacksBean.Instructions =
        map['Instructions'] ?? map['description'].replaceAll(r'\n', '\n');
    snacksBean.totalCalories = map['totalCalories'].toString();
    snacksBean.protein = map['protein'].toString();
    snacksBean.carb = map['carb'].toString();
    snacksBean.fat = map['fat'].toString();
    snacksBean.image = map['image'] ?? imageURL;
    return snacksBean;
  }

  Map toJson() => {
        "Day": Day,
        "Title": Title,
        "Ingredients": Ingredients,
        "Instructions": Instructions,
        "totalCalories": totalCalories,
        "protein": protein,
        "carb": carb,
        "fat": fat,
        "image": image
      };
}
