import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_client/body_home.dart';
import 'package:toilet_client/getx/my_getx_controller.dart';
import 'package:toilet_client/utils/dialog_page.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/text.dart';
import 'package:toilet_client/widget/item_star.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final controllerGetx = Get.put(MyGetXController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    const double heightItem = 125.0;
    const double widthItem = 150.0;
    const double paddingItem = 64.0;
    const double padding08 = 8.0;

    return Scaffold(
        body: SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //part 1: body
          Container(
              // height: height * 4 / 5,
              height: height * 3.75 / 5,
              alignment: Alignment.center,
              width: width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  BodyToiletPage(),
                  Obx(() => Visibility(
                      visible: controllerGetx.visible.value,
                      child:const DialogPage()))
                ],
              )),
          //part 2 : star
          Container(
              color: MyColor.white,
              height: height * 1.15 / 5,
              // height: height * .9 / 5,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text_custom(
                      text: 'Help us improve our service',
                      color: MyColor.black_text,
                      weight: FontWeight.w500,
                      size: TextSizeDefault.text32),
                  const SizedBox(
                    height: PaddingDefault.pading08,
                  ),
                  rowStar(
                      controllerGetx: controllerGetx,
                      onPress: () {
                        print('open dialog');
                        // controllerGetx.toggleVisible();
                        // controllerGetx.startCountdown();
                        controllerGetx.turnOnVisible();
                      })
                ],
              )),
        ],
      ),
    ));
  }
}


