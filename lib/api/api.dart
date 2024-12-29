import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:ketodiet/model/diet_response.dart';
import 'package:ketodiet/model/dietrecipes_response.dart';
import 'package:ketodiet/utils/constant.dart';
import 'package:ketodiet/utils/sessionmanager.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<void> loadDietJson(BuildContext context) async {
    DietResponse? dietResponse = DietResponse();
    String response = await DefaultAssetBundle.of(context)
        .loadString("assets/json/diet.json");
    print('response>>>>$response');
    dietResponse = DietResponse.fromMap(json.decode(response));
    if (dietResponse!.foods!.isNotEmpty) {
      print('Api response getting>>>${dietResponse.foods!.length}');
      SessionManager manager = SessionManager();
      manager.setDietResponse(dietResponse);
    } else {
      print('Null data');
    }
  }

  Future<void> loadDietRecipes(BuildContext context) async {
    DietrecipesResponse dietResponse = DietrecipesResponse();
    String response = await DefaultAssetBundle.of(context)
        .loadString("assets/json/DietRecipe.json");
    print('response>>> recipes>$response');
    dietResponse = DietrecipesResponse.fromMap(json.decode(response))!;
    if (dietResponse.recipes!.isNotEmpty) {
      print(
          'Api recipes response getting>>>${dietResponse.recipes![0].Veg!.Breakfast!.length}');
      SessionManager manager = SessionManager();
      manager.setDietRecipesResponse(dietResponse);
    } else {
      print('Null data');
    }
  }

  Future<Map<String, dynamic>?> fetchBarcodeData(String code) async {
    final response = await http.get(
      Uri.parse(
          '${Constant.barcodeLookupURL}/$code?fields=product_name,image_url,nutriments,serving_size'),
    );
    print('RESPONSE!!!>>>${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<void> fetchFoodList() async {
    final response = await http.get(
      Uri.parse('${Constant.apiURL}/Foods/list'),
    );
    if (response.statusCode == 200) {
      print('FoodListResponse>>>>>>${response.body}');
      DietResponse? dietResponse = DietResponse();
      dietResponse = DietResponse.fromMap({
        "foods": [
          {
            "veg": json.decode(response.body),
            "nonveg": json.decode(response.body)
          }
        ]
      });
      print('FoodListResponse>>>>>>$dietResponse');

      if (dietResponse!.foods!.isNotEmpty) {
        print('Api response getting>>>${dietResponse.foods!.length}');
        SessionManager manager = SessionManager();
        manager.setDietResponse(dietResponse);
      } else {
        print('Null data');
      }
    }
  }

  Future<void> fetchRecipeList() async {
    final response = await http.get(
      Uri.parse('${Constant.apiURL}/Recipes/list'),
    );
    if (response.statusCode == 200) {
      print('RecipeListResponse>>>>>>${response.body}');
      DietrecipesResponse dietResponse = DietrecipesResponse();
      dietResponse = DietrecipesResponse.fromMap({
        "recipes": [
          {
            "Veg": json.decode(response.body),
            "NonVeg": json.decode(response.body)
          }
        ]
      })!;
      if (dietResponse.recipes!.isNotEmpty) {
        print(
            'Api recipes response getting>>>${dietResponse.recipes![0].Veg!.Breakfast!.length}');
        SessionManager manager = SessionManager();
        manager.setDietRecipesResponse(dietResponse);
      } else {
        print('Null data');
      }
    }
  }

  Future<List<dynamic>?> fetchFirstPage() async {
    final response = await http.get(
      Uri.parse('${Constant.apiURL}/FrontPage'),
    );
    print('RESPONSE!!!>>>${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> storeSubscriptionResult(dynamic body) async {
    final response =
        await http.post(Uri.parse('${Constant.apiURL}/subscribe'), body: body);
    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<List<dynamic>?> getUserHistory(String deviceId, String startDate, String endDate ) async {
    final response = await http.get(
      Uri.parse('${Constant.apiURL}/history?device_id=$deviceId&startDate=$startDate&endDate=$endDate'),
    );
    print('RESPONSE!!!>>>${response.body}');
    if (response.statusCode == 201) {
      return json.decode(response.body)['info'];
    } else {
      return null;
    }
  }

  Future<dynamic> postUserHistory(dynamic body) async {
    final response =
        await http.post(Uri.parse('${Constant.apiURL}/history'), body: body);
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<dynamic> getZoomMeetingData() async {
    final response =
        await http.get(Uri.parse('${Constant.apiURL}/ZoomMetting'));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future<dynamic> getSplashImg() async {
    final response = await http.get(Uri.parse('${Constant.apiURL}/Splash'));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future<String> fetchSubscriptionStatus(String? deviceID) async {
    RegExp regExp = RegExp(r'^-?[0-9]+(\.[0-9]+)?$');
    final response = await http.get(
      Uri.parse('${Constant.apiURL}/subscribe/$deviceID'),
    );
    print('fetchSubscriptionStatus>>>>>>${response.body}');

    if (response.statusCode == 200) {
      dynamic decodedBody = json.decode(response.body);
      if (regExp.hasMatch(decodedBody?['subscriptionStatus'])) {
        return decodedBody?['subscriptionStatus'];
      } else {
        if (decodedBody?['subscriptionStatus'] == "expired") {
          return 'expired';
        } else {
          return 'inactive';
        }
      }
    } else {
      return 'Error';
    }
  }

  Future<void> fetchRecipeIdeas() async {
    final response = await http.get(
      Uri.parse('${Constant.apiURL}/Recipes/ideas'),
    );
    if (response.statusCode == 200) {
      print('RecipeIdeasResponse>>>>>>${response.body}');
      SessionManager manager = SessionManager();
      manager.setRecipeIdeasResponse(response.body);
    } else {
      print('Null data');
    }
  }
}
