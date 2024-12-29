import 'package:flutter/material.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';

class MyButton extends StatelessWidget{
  final GestureTapCallback? onTap;
  final String? btntext;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;



  const MyButton({
    this.onTap,
    this.borderRadius,
   required this.btntext,
    this.color,

    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap,
      child: MyContainer(
        width: double.infinity,
        color: color??blackColor,
        borderRadius: borderRadius?? BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 12),
          child: MyRegularText(
            isHeading: true,
            label: btntext.toString(),
            fontSize: 16,
            color: whiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


}