import 'package:flutter/material.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularProgress extends StatefulWidget {
  int? from;
  Color? color;
  Color? lightColor;
  String? text;
  double? percentage;
  double? radius;
   CircularProgress({this.from,this.color,this.lightColor,this.text,this.percentage,this.radius,Key? key}) : super(key: key);

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> {

  @override
  Widget build(BuildContext context) {
    return widget.from == 0?
    CircularPercentIndicator( //circular progress indicator
      radius: widget.radius!, //radius for circle
      lineWidth: 12.0, //width of circle line
      animation: true, //animate when it shows progress indicator first
      percent: widget.percentage ??0.0, //percentage value: 0.6 for 60% (60/100 = 0.6)
      backgroundColor: widget.lightColor!, //backround of progress bar
      circularStrokeCap: CircularStrokeCap.round, //corner shape of progress bar at start/end
      progressColor: widget.color, //progress bar color
    )
       : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MyRegularText(
          isHeading: false,
          label: widget.text!,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        MySpacer.minispacer,
        CircularPercentIndicator( //circular progress indicator
          radius: 36.0, //radius for circle
          lineWidth: 8.0, //width of circle line
          animation: true, //animate when it shows progress indicator first
          percent: widget.percentage != null? widget.text == 'Calories'?widget.percentage! / 2200:widget.text == 'Protein'?widget.percentage! / 65:widget.text == 'Carbs'?widget.percentage! / 325:widget.percentage! / 90:1.0, //vercentage value: 0.6 for 60% (60/100 = 0.6)
          center: MyRegularText( isHeading: false,label: widget.percentage != null? widget.text == 'Calories'? '${widget.percentage!}'
                          :widget.text == 'Protein'? "${widget.percentage!}"
                              :widget.text == 'Carbs'? '${widget.percentage!}'
                                  : '${widget.percentage!}'
                      :'0',style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 13.0),
          ),
          backgroundColor: widget.lightColor!,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: widget.color,
        ),
      ],
    );
  }
}
