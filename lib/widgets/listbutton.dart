import 'package:flutter/material.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/widgets/mycontainer.dart';
import 'package:ketodiet/widgets/myregulartext.dart';

class ListButtton extends StatelessWidget{
  final GestureTapCallback? onTap;
  final String? btntext;
  final BorderRadiusGeometry? borderRadius;
  final Color? bgcolor;
  final Color? txtcolor;



  const ListButtton({
    this.onTap,
    this.borderRadius,
   required this.btntext,
    this.bgcolor,
    this.txtcolor,
    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:onTap,
      child: MyContainer(
        width: 100,
        margin: EdgeInsets.only(right: 10, bottom: 10),
        color: bgcolor,
        borderRadius: borderRadius?? BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10),
          child: MyRegularText(
            isHeading: true,
            label: btntext.toString(),
            fontSize: 14,
            color: txtcolor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


}