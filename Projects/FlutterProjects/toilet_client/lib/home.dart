import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_client/api/my_api_service.dart';
import 'package:toilet_client/body_home.dart';
import 'package:toilet_client/getx/my_getx_controller.dart';
import 'package:toilet_client/utils/button_deboucer.dart';
import 'package:toilet_client/utils/dialog_checklist.dart';
import 'package:toilet_client/utils/dialog_page.dart';
import 'package:toilet_client/utils/mycolors.dart';
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
  final service_api = MyAPIService();
  final debouncer =
      Debouncer(milliseconds: 500, delay: const Duration(milliseconds: 2500));

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
                  Positioned(
                      bottom: PaddingDefault.pading12,
                      right: PaddingDefault.pading12,
                      child: Align(
                        alignment: Alignment.center,
                        child: buttonColorFullCustom(
                            hasIcon: true,
                            borderRadios: PaddingDefault.padding24,
                            icon: const Icon(Icons.woman_rounded,
                                size: PaddingDefault.padding48,
                                color: MyColor.white),
                            paddingVertical: PaddingDefault.padding04,
                            textSize: TextSizeDefault.text24,
                            text: "Call Service",
                            hasText: true,
                            secondText: "* Send a request to our staff",
                            color: MyColor.yellow3,
                            onPressed: () {
                              debouncer.run(() {
                                print('click button woman');
                                service_api.sendNotification(
                                    title: 'Call Service - Woman 👩',
                                    body:
                                        "[Urgent] Please contact the cleaner immediately to check the toilet problem. Thank you.",
                                    star: 5,
                                    registrationToken: "",
                                    feedback: [
                                      "Feedback from 'Call Service' button click in 👩 woman area"
                                    ]).whenComplete(() =>
                                    debugPrint('complete send notifcation'));
                                //finish call a notificaiton
                                showSnackBar(
                                    message: "Your request has been sent to our staff, thank you!",
                                    context: context);
                                service_api.createFeedBack(
                                  driver: 'FEEDBACK FROM CALL SERVICE - WOMAN 👩 AREA',
                                  star: 5,
                                  content: 'FEEDBACK FROM CALL SERVICE - WOMAN 👩 AREA',
                                  experience: ["CALL SERVICE (WOMAN 👩)"],
                                ).then((value) => print(value));
                              });
                            }),
                      )),

                  Positioned(
                      bottom: PaddingDefault.pading12,
                      left: PaddingDefault.pading12,
                      child: Align(
                        alignment: Alignment.center,
                        child: buttonColorFullCustom(
                            hasIcon: true,
                            borderRadios: PaddingDefault.padding24,
                            icon: const Icon(Icons.man_3_rounded,
                                size: PaddingDefault.padding48,
                                color: MyColor.white),
                            paddingVertical: PaddingDefault.padding04,
                            textSize: TextSizeDefault.text24,
                            text: "Call Service",
                            hasText: true,
                            secondText: "* Send a request to our staff",
                            color: MyColor.yellow3,
                            onPressed: () {
                              debouncer.run(() {
                                debugPrint('click button');
                                service_api.sendNotification(
                                    title: 'Call Service - Man 👨',
                                    body:"[Urgent] Please contact the cleaner immediately to check the toilet problem. Thank you.",
                                    star: 5,
                                    registrationToken: "",
                                    feedback: [
                                      "Feedback from 'Call Service' button click in 👨 man area"
                                    ]).whenComplete(() =>
                                    debugPrint('complete send notifcation'));
                                //finish call a notificaiton
                                showSnackBar(
                                    message:"Your request has been sent to our staff, thank you!",
                                    context: context);
                                service_api.createFeedBack(
                                  driver: 'FEEDBACK FROM CALL SERVICE - MAN 👨 AREA',
                                  star: 5,
                                  content: 'FEEDBACK FROM CALL SERVICE - MAN 👨 AREA',
                                  experience: ["ALL SERVICE (MAN 👨)"],
                                ).then((value) => print(value));
                              });
                            }),
                      )),
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
                            debugPrint('open dialog');
                            // controllerGetx.toggleVisible();
                            // controllerGetx.startCountdown();
                            controllerGetx.turnOnVisible();
                          }),
                      const SizedBox(
                        height: PaddingDefault.padding04,
                      ),
                      text_custom(
                          text: "* Choose stars 🌟 to rating our service")
                    ],
                  ),
                  Positioned(
                      left: 0,
                      top: 0,
                      child: InkWell(
                        onDoubleTap: () {
                          debugPrint('open checklist');
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Dialog(
                                backgroundColor: MyColor.black_text,
                                shadowColor: Colors.transparent,
                                elevation: 1.0,
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
                  // Positioned(
                  //     top: PaddingDefault.padding54,
                  //     right: PaddingDefault.padding16,
                  //     child: Align(
                  //       alignment: Alignment.bottomCenter,
                  //       child: InkWell(
                  //           onDoubleTap: () {
                  //             debugPrint('call service');
                  //           },
                  //           child: buttonColorFullCustom(
                  //               hasIcon: true,
                  //               icon: const InfiniteAnimation(
                  //                 durationInSeconds: 10,
                  //                 child: Icon(
                  //                   Icons.phone,
                  //                   color: MyColor.white,
                  //                   size: TextSizeDefault.text32,
                  //                 ),
                  //               ),
                  //               width: 225.0,
                  //               paddingVertical: TextSizeDefault.text12,
                  //               textSize: TextSizeDefault.text24,
                  //               text: "Call Service",
                  //               hasText: true,
                  //               secondText: "* Send a request to our staff",
                  //               color: MyColor.yellow3,
                  //               onPressed: () {
                  //                 debouncer.run(() {
                  //                   print('click button');
                  //                   service_api.sendNotification(
                  //                     title: '[Call Service]',
                  //                     body:"[Urgent] Please contact the cleaner immediately to check the toilet problem. Thank you.",
                  //                     star: 5,
                  //                     registrationToken: "",
                  //                     feedback: ["Feedback from 'Call Service' button click "]
                  //                   ).whenComplete(() => print('complete send notifcation'));
                  //                   //finish call a notificaiton
                  //                   showSnackBar(
                  //                       message:"Your request has been sent to our staff, thank you!",
                  //                       context: context);
                  //                 });
                  //               })),
                  //     )),
                ],
              )),
        ],
      ),
    ));
  }
}
