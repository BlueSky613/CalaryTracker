/*
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:ketodiet/widgets/caloriesmodel.dart';

class CaloriesChart extends StatelessWidget {
  final List<CaloriesModel>? data;

  CaloriesChart({ this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CaloriesModel, String>> series = [
      charts.Series(
          id: "Weeks",
          data: data!,
          domainFn: (CaloriesModel series, _) => series.weeks!,
          measureFn: (CaloriesModel series, _) => series.calories,
          colorFn: (CaloriesModel series, _) => series.barColor!
      )
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: charts.BarChart(series, animate: true,),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
