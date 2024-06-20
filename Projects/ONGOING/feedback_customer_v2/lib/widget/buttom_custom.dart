import 'package:feedback_customer/util/color_custom.dart';
import 'package:flutter/material.dart';

Widget customPressButton({double? padding,onPress,double? width,required String? text, haveArrow =true,isBoldColor = true}){
  return ClipRRect(
    borderRadius: BorderRadius.circular(padding!),
    child:  Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: MyColor.yellow_bg,
          onTap: ()=>onPress(),
          child: Container( alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                width: width,
                                height: 65.0,
                                decoration: BoxDecoration(
                                    border: Border.all(color: MyColor.black_text, width: .5),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: const [0.1, 0.65, 0.95],
                                      colors: [
                                        isBoldColor==true ? MyColor.yellowAccent :  MyColor.yellow.withOpacity(.65),
                                        isBoldColor==true ? MyColor.yellow3.withOpacity(.65):MyColor.yellow.withOpacity(.35),
                                       isBoldColor==true ? MyColor.yellow2.withOpacity(.35) : MyColor.yellow.withOpacity(.25),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(padding)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        text!,
                                        style: const TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold),),
                                    const SizedBox(width: 4.0,),
                                   haveArrow ==false ? Container() : const Icon(Icons.double_arrow_rounded,color:Colors.black,size: 36.0,)
                                  ],
                                ),
                              )
        ),
      ),
  );
}