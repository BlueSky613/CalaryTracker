import 'package:flutter/material.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/utils/myspacer.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearProgress extends StatefulWidget {
  String? text;
  String? total;
  String? subtotal;
  Color? color;
  int? from;
  double? percentage;
  ValueChanged<double>? calories;
  ValueChanged<double>? protein;
  ValueChanged<double>? carbs;
  ValueChanged<double>? fat;
  ValueChanged<bool>? isSlide;

  LinearProgress(
      {this.from, this.text, this.total, this.subtotal, this.color,this.calories,this.protein,this.carbs,this.fat,this.isSlide,this.percentage, Key? key})
      : super(key: key);

  @override
  State<LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<LinearProgress> {
  double? _value = 50;

@override
  void initState() {
 // setGoal();
    super.initState();
  }

  setGoal(){
  setState(() {
    if( widget.text == 'Calories'){
      _value = double.parse(widget.total!.replaceAll(",", ""));
    }else if(widget.text == 'Protein'){
      _value = double.parse(widget.total!);
    }else if(widget.text == 'Carbs'){
      _value = double.parse(widget.total!);
    }else{
      _value = double.parse(widget.total!);
    }
  });
  }
  @override
  Widget build(BuildContext context) {
    _value = double.parse(widget.total!.replaceAll(",", ""));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: widget.from == 1 ? 18.0 : 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyContainer(
                    height: 10,
                    width: 10,
                    color: widget.color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  MySpacer.width6,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: MyRegularText(
                      isHeading: false,
                      label: widget.text.toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              widget.from == 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyRegularText(
                          isHeading: false,
                          label: widget.subtotal.toString(),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        MyRegularText(
                          isHeading: false,
                          label: '/${widget.total}',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    )
                  : MyRegularText(
                isHeading: false,
                      label: '${widget.total}',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
            ],
          ),
        ),
        widget.from == 1
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: widget.color,
                    inactiveTrackColor: inactiveColor,
                    trackShape: const RectangularSliderTrackShape(),
                    trackHeight: 3.0,
                    thumbColor: whiteColor,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayColor: Colors.grey.withAlpha(32),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 14.0),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Slider(
                      min: 0,
                      max: widget.text == 'Calories'? 2200
                          :widget.text == 'Protein'? 65
                          :widget.text == 'Carbs'? 325
                          : 90,
                      value: _value??0,
                      onChanged: (value) {
                        setState(() {
                          widget.isSlide!(true);
                          widget.text == 'Calories'?   _value = value
                              :widget.text == 'Protein'?   _value = value
                              :widget.text == 'Carbs'?   _value = value
                              :   _value = value;
                          print('value>>??>>$_value');
                          widget.text == 'Calories'? widget.calories!(_value!)
                              :widget.text == 'Protein'? widget.protein!(_value!)
                              :widget.text == 'Carbs'? widget.carbs!(_value!)
                              : widget.fat!(_value!);
                        });
                      },
                    ),
                  ),
                ),
              )
            : LinearPercentIndicator(
                padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width / 2.31,
                animation: true,
                lineHeight: 11.0,
                animationDuration: 2000,
                barRadius: const Radius.circular(20),
                percent: widget.percentage ?? 0,
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: widget.color,
              ),
      ],
    );
  }
}
