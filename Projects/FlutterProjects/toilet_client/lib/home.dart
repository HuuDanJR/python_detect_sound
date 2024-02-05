import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_client/animation/inifinite_animation.dart';
import 'package:toilet_client/body_home.dart';
import 'package:toilet_client/getx/my_getx_controller.dart';
import 'package:toilet_client/utils/button_deboucer.dart';
import 'package:toilet_client/utils/dialog_checklist.dart';
import 'package:toilet_client/utils/dialog_page.dart';
import 'package:toilet_client/utils/mycolors.dart';
import 'package:toilet_client/utils/mystring.dart';
import 'package:toilet_client/utils/padding.dart';
import 'package:toilet_client/utils/showsnackbar.dart';
import 'package:toilet_client/utils/text.dart';
import 'package:toilet_client/widget/button.dart';
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
  final debouncer = Debouncer(milliseconds: 500, delay: const Duration(milliseconds: 2500));

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
                      child: const DialogPage())),
                  // DialogCheckList(),
                ],
              )),
          //part 2 : star
          Container(
              color: Colors.white,
              // color: Color.fromARGB(255, 237, 236, 236),
              height: height * 1.15 / 5,
              // height: height * .9 / 5,
              width: width,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text_custom(
                          text: 'Help us improve our service',
                          color: MyColor.black_text,
                          weight: FontWeight.w500,
                          size: TextSizeDefault.text32),
                      const SizedBox(
                        height: PaddingDefault.padding04,
                      ),
                      rowStar(
                          controllerGetx: controllerGetx,
                          onPress: () {
                            print('open dialog');
                            // controllerGetx.toggleVisible();
                            // controllerGetx.startCountdown();
                            controllerGetx.turnOnVisible();
                          }),
                      const SizedBox(
                        height: PaddingDefault.padding04,
                      ),
                      text_custom(text:"* Choose stars 🌟 to rating our service")
                    ],
                  ),
                  Positioned(
                      left: 0,
                      top: 0,
                      child: InkWell(
                        onDoubleTap: () {
                          print('open checklist');
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: DialogCheckList(),
                              );
                            },
                          );
                        },
                        child: Container(
                          color: MyColor.white.withOpacity(.9),
                          width: 250.0,
                          height: 250.0,
                        ),
                      )),
                  Positioned(
                      top: PaddingDefault.padding54,
                      right: PaddingDefault.padding16,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                            onDoubleTap: () {
                              print('call service');
                            },
                            child: buttonColorFullCustom(
                                hasIcon: true,
                                icon: InfiniteAnimation(
                                  durationInSeconds: 10,
                                  child: Icon(
                                    Icons.phone,
                                    color: MyColor.white,
                                    size: TextSizeDefault.text32,
                                  ),
                                ),
                                width: 225.0,
                                paddingVertical: TextSizeDefault.text12,
                                textSize: TextSizeDefault.text24,
                                text: "Call Service",
                                hasText: true,
                                secondText: "* Send a request to our staff",
                                color: MyColor.yellow3,
                                onPressed: () {
                                  debouncer.run(() {
                                    print('click button');
                                    //call a notification

                                    //finish call a notificaiton
                                    showSnackBar(
                                        message:"Your request has been sent to our staff, thank you!",
                                        context: context);
                                  });
                                })),
                      )),
                ],
              )),
        ],
      ),
    ));
  }
}
