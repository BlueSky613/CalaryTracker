import 'package:flutter/material.dart';
import 'package:ketodiet/screens/homemain/tab_screen/calories_statistics.dart';
import 'package:ketodiet/screens/homemain/tab_screen/recipe_ideas_screen.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/utils/sessionmanager.dart';
import 'package:ketodiet/widgets/myappbar.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:ketodiet/widgets/listbutton.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  /* final List<CaloriesModel> data = [
    CaloriesModel(
      weeks: "2008",
      calories: 10000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2009",
      calories: 11000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2010",
      calories: 12000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2011",
      calories: 10000000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2012",
      calories: 8500000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2013",
      calories: 7700000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2014",
      calories: 7600000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    CaloriesModel(
      weeks: "2015",
      calories: 5500000,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
  ];*/

  late List<dynamic> ideasList = [];

  int seperatedIndex = 0;
  Color bgcolor = whiteColor;
  Color txtcolor = textColor;

  @override
  void initState() {
    super.initState();
    getRecipeIdeas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getRecipeIdeas() async {
    SessionManager manager = SessionManager();
    dynamic recipeIdeas = await manager.getRecipeIdeasResponse();
    print("SessionRcipeIdeas>>>>>>>>$recipeIdeas");
    setState(() {
      ideasList = recipeIdeas;
    });
  }

  void handleTap(index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeIdeasScreen(
            recipe: ideasList[index],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: MyAppBar.myAppBar(context, 'Recipes', true, () {
        Navigator.pop(context);
      }, () {}, primaryColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CaloriesStatistics(),
              MySpacer.spacer30,
              const MyRegularText(
                isHeading: true,
                label: 'Recipes Ideas',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              MySpacer.mediumspacer,
              SizedBox(
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ListButtton(
                          btntext: 'All',
                          bgcolor: seperatedIndex == 0 ? greyColor : whiteColor,
                          txtcolor:
                              seperatedIndex == 0 ? whiteColor : textColor,
                          onTap: () {
                            setState(() {
                              seperatedIndex = 0;
                            });
                          },
                        ),
                        ListButtton(
                          btntext: 'Breakfast',
                          bgcolor: seperatedIndex == 1 ? greyColor : whiteColor,
                          txtcolor:
                              seperatedIndex == 1 ? whiteColor : textColor,
                          onTap: () {
                            setState(() {
                              seperatedIndex = 1;
                            });
                          },
                        ),
                        ListButtton(
                          btntext: 'Lunch',
                          bgcolor: seperatedIndex == 2 ? greyColor : whiteColor,
                          txtcolor:
                              seperatedIndex == 2 ? whiteColor : textColor,
                          onTap: () {
                            setState(() {
                              seperatedIndex = 2;
                            });
                          },
                        ),
                        ListButtton(
                          btntext: 'Dinner',
                          bgcolor: seperatedIndex == 3 ? greyColor : whiteColor,
                          txtcolor:
                              seperatedIndex == 3 ? whiteColor : textColor,
                          onTap: () {
                            setState(() {
                              seperatedIndex = 3;
                            });
                          },
                        ),
                        ListButtton(
                          btntext: 'Snacks',
                          bgcolor: seperatedIndex == 4 ? greyColor : whiteColor,
                          txtcolor:
                              seperatedIndex == 4 ? whiteColor : textColor,
                          onTap: () {
                            setState(() {
                              seperatedIndex = 4;
                            });
                          },
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return MySpacer.width16;
                  },
                  padding: const EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: ideasList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String imageURL = ideasList[index]?['recipe_pic']?.length >
                            0
                        ? (ideasList[index]?['recipe_pic']?[0])
                        : 'http://diet.backend.marketmajesty.net/upload/recipe.jpg';
                    return GestureDetector(
                        onTap: () => handleTap(index),
                        child: seperatedIndex == 0
                            ? MyContainer(
                                width: MediaQuery.of(context).size.width / 1.5,
                                // height: MediaQuery.of(context).size.height / 9,
                                color: whiteColor,
                                margin: EdgeInsets.only(bottom: 10),
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                          child: Image.network(
                                            imageURL,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    MyContainer(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              11,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: MyRegularText(
                                                    isHeading: true,
                                                    label: ideasList[index]
                                                        ?['name'],
                                                    fontSize: 16,
                                                    align: TextAlign.start,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                MySpacer.width6,
                                                const Icon(
                                                  Icons.access_time_rounded,
                                                  color: textColor1,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: MyRegularText(
                                                    isHeading: false,
                                                    label: ideasList[index]
                                                        ?['meal_type'],
                                                    fontSize: 13,
                                                    color: Colors.grey,
                                                    align: TextAlign.start,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                MySpacer.width2,
                                                Flexible(
                                                  flex: 1,
                                                  child: MyRegularText(
                                                    isHeading: false,
                                                    label:
                                                        '${ideasList[index]?['preparationTime']} m',
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    align: TextAlign.start,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : seperatedIndex == 1 &&
                                    ideasList[index]?['meal_type'] ==
                                        'Breakfast'
                                ? MyContainer(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    // height: MediaQuery.of(context).size.height / 9,
                                    color: whiteColor,
                                    margin: EdgeInsets.only(bottom: 10),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8,
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(12),
                                              ),
                                              child: Image.network(
                                                imageURL,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        MyContainer(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              11,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      child: MyRegularText(
                                                        isHeading: true,
                                                        label: ideasList[index]
                                                            ?['name'],
                                                        fontSize: 16,
                                                        align: TextAlign.start,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    MySpacer.width6,
                                                    const Icon(
                                                      Icons.access_time_rounded,
                                                      color: textColor1,
                                                      size: 20,
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      child: MyRegularText(
                                                        isHeading: false,
                                                        label: ideasList[index]
                                                            ?['meal_type'],
                                                        fontSize: 13,
                                                        color: Colors.grey,
                                                        align: TextAlign.start,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    MySpacer.width2,
                                                    Flexible(
                                                      flex: 1,
                                                      child: MyRegularText(
                                                        isHeading: false,
                                                        label:
                                                            '${ideasList[index]?['preparationTime']} m',
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        align: TextAlign.start,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : seperatedIndex == 2 &&
                                        ideasList[index]?['meal_type'] ==
                                            'Lunch'
                                    ? MyContainer(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        // height: MediaQuery.of(context).size.height / 9,
                                        color: whiteColor,
                                        margin: EdgeInsets.only(bottom: 10),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    topRight:
                                                        Radius.circular(12),
                                                  ),
                                                  child: Image.network(
                                                    imageURL,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            MyContainer(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(12),
                                                bottomRight:
                                                    Radius.circular(12),
                                              ),
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  11,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child: MyRegularText(
                                                            isHeading: true,
                                                            label:
                                                                ideasList[index]
                                                                    ?['name'],
                                                            fontSize: 16,
                                                            align:
                                                                TextAlign.start,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        MySpacer.width6,
                                                        const Icon(
                                                          Icons
                                                              .access_time_rounded,
                                                          color: textColor1,
                                                          size: 20,
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          flex: 2,
                                                          child: MyRegularText(
                                                            isHeading: false,
                                                            label: ideasList[
                                                                    index]
                                                                ?['meal_type'],
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                            align:
                                                                TextAlign.start,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        MySpacer.width2,
                                                        Flexible(
                                                          flex: 1,
                                                          child: MyRegularText(
                                                            isHeading: false,
                                                            label:
                                                                '${ideasList[index]?['preparationTime']} m',
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                            align:
                                                                TextAlign.start,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : seperatedIndex == 3 &&
                                            ideasList[index]?['meal_type'] ==
                                                'Dinner'
                                        ? MyContainer(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            // height: MediaQuery.of(context).size.height / 9,
                                            color: whiteColor,
                                            margin: EdgeInsets.only(bottom: 10),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      8,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                      ),
                                                      child: Image.network(
                                                        imageURL,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                MyContainer(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12),
                                                  ),
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      11,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child:
                                                                  MyRegularText(
                                                                isHeading: true,
                                                                label: ideasList[
                                                                        index]
                                                                    ?['name'],
                                                                fontSize: 16,
                                                                align: TextAlign
                                                                    .start,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            MySpacer.width6,
                                                            const Icon(
                                                              Icons
                                                                  .access_time_rounded,
                                                              color: textColor1,
                                                              size: 20,
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              flex: 2,
                                                              child:
                                                                  MyRegularText(
                                                                isHeading:
                                                                    false,
                                                                label: ideasList[
                                                                        index]?[
                                                                    'meal_type'],
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.grey,
                                                                align: TextAlign
                                                                    .start,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            MySpacer.width2,
                                                            Flexible(
                                                              flex: 1,
                                                              child:
                                                                  MyRegularText(
                                                                isHeading:
                                                                    false,
                                                                label:
                                                                    '${ideasList[index]?['preparationTime']} m',
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                                align: TextAlign
                                                                    .start,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : seperatedIndex == 4 &&
                                                ideasList[index]
                                                        ?['meal_type'] ==
                                                    'Snacks'
                                            ? MyContainer(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                // height: MediaQuery.of(context).size.height / 9,
                                                color: whiteColor,
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              8,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    12),
                                                            topRight:
                                                                Radius.circular(
                                                                    12),
                                                          ),
                                                          child: Image.network(
                                                            imageURL,
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                    MyContainer(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(12),
                                                      ),
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              11,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  flex: 1,
                                                                  child:
                                                                      MyRegularText(
                                                                    isHeading:
                                                                        true,
                                                                    label: ideasList[
                                                                            index]
                                                                        ?[
                                                                        'name'],
                                                                    fontSize:
                                                                        16,
                                                                    align: TextAlign
                                                                        .start,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                MySpacer.width6,
                                                                const Icon(
                                                                  Icons
                                                                      .access_time_rounded,
                                                                  color:
                                                                      textColor1,
                                                                  size: 20,
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  flex: 2,
                                                                  child:
                                                                      MyRegularText(
                                                                    isHeading:
                                                                        false,
                                                                    label: ideasList[
                                                                            index]
                                                                        ?[
                                                                        'meal_type'],
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .grey,
                                                                    align: TextAlign
                                                                        .start,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                MySpacer.width2,
                                                                Flexible(
                                                                  flex: 1,
                                                                  child:
                                                                      MyRegularText(
                                                                    isHeading:
                                                                        false,
                                                                    label:
                                                                        '${ideasList[index]?['preparationTime']} m',
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .grey,
                                                                    align: TextAlign
                                                                        .start,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
