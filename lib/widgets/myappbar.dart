import 'package:flutter/material.dart';
import 'package:ketodiet/utils/colors_utils.dart';
import 'package:ketodiet/widgets/myregulartext.dart';

class MyAppBar{
  static AppBar myAppBar (BuildContext context,String title,bool isCross,GestureTapCallback? onTap1,GestureTapCallback? onTap2,Color? backgroundColor){
    return AppBar(
      backgroundColor: backgroundColor?? transparent,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: MyRegularText(
          isHeading: true,
          label: title,
            color: textColor,
            fontSize: 24,
            align: TextAlign.start,
          fontWeight: FontWeight.w600,
        ),
      ),
      /*actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: isCross?
              *//*GestureDetector(
                  onTap: onTap1,
                  child: Icon(Icons.close,size: 25,color: textColor,))*//*
          SizedBox()
              :Row(
            children: [
              GestureDetector(
                onTap:onTap1,
                child: SizedBox(
                    height: 28,
                    width: 28,
                    child: SvgPicture.asset('assets/images/svg/statistic.svg',fit: BoxFit.scaleDown,color: textColor,)),
              ),
              MySpacer.width16,
              GestureDetector(
                onTap:onTap2,
                child: SizedBox(
                    height: 26,
                    width: 26,
                    child: SvgPicture.asset('assets/images/svg/setting.svg',fit: BoxFit.scaleDown,color: textColor,)),
              ),
            ],
          ),
        )
      ],*/
      toolbarHeight: MediaQuery.of(context).size.height / 13,
      elevation: 0.0,
    );
  }
}