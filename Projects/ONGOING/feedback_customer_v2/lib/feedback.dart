import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/model/item.dart';
import 'package:feedback_customer/result.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key, this.item});
  Item? item;

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final controllerGetx = Get.put(MyGetXController());
  final service_api = new ServiceAPIs();
  @override
  void dispose() {
    super.dispose();
    controllerGetx.resetListStatus();
  }

  @override
  void initState() {
    controllerGetx.startCountdownTimer(() {
      print('start API startCountdownTimer');
      runFeedback();
    });
    super.initState();
  }

  void runFeedback() {
    service_api
        .createFeedback(
            tag: TAG_PRODUCT,
            id: widget.item!.id,
            content: widget.item!.name,
            exp: controllerGetx.getListStatusName())
        .then((value) {
      if (value['status'] == true) {
        customSnackBarSuccess(
            context: context,
            message: value['message'] != null
                ? value['message']
                : "Created feedback successfully");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResultPage()));
      }
    }).whenComplete(() {
      controllerGetx.resetListStatus();
      controllerGetx.cancelResetAllTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(
        children: [
          Container(
              alignment: Alignment.center,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal:32.0),
              width: width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'asset/background.jpg',
                    ),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: width,
                    height: height / 6,
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          text: 'WHAT MAKES ',
                          style: TextStyle(
                              fontSize: 46.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'YOUR DAY?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 46.0,
                                    color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: width * 3 / 4,
                      height: height *5/6,
                      child: Obx(
                        () => GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controllerGetx.list.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: MyColor.yellow_gradient1,
                                  onTap: () {
                                    print('choose it');
                                    controllerGetx.restartTimer(() {
                                      runFeedback();
                                    });
                                    controllerGetx.changeListStatus(index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: height / 6,
                                          width: width / 4.25,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 16.0),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(42.5),
                                            color: controllerGetx.list[index]
                                                        .isSelected ==
                                                    true
                                                ? MyColor.yellowMain
                                                : Colors.white
                                                    .withOpacity(.75),
                                          ),
                                          child: Image.asset(
                                            scale: orientation ==
                                                    Orientation.portrait
                                                ? 1.0
                                                : 1.75,
                                            controllerGetx.list[index].image,
                                            filterQuality: FilterQuality.high,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          controllerGetx.list[index].name,
                                          style: TextStyle(
                                              fontSize: orientation ==
                                                      Orientation.portrait
                                                  ? 30.0
                                                  : 26.0),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      orientation == Orientation.portrait
                                          ? .9
                                          : 1.65,
                                  mainAxisSpacing: 16.0,
                                  crossAxisSpacing: 16.0),
                        ),
                      )),

                  
                ],
              )),
              //custome button submit
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customPressButton(
                            width: 225.0,
                            text: 'Submit ',
                            padding: 32.0,
                            onPress: () {
                              print('press submit');
                              print('${widget.item!.id}');
                              print(widget.item!.name);
                              print(
                                  'list ${controllerGetx.getListStatusName()}');
                    
                              //create feedback here
                              runFeedback();
                              //end create feedback
                            }),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Obx(
                          () => Text(
                            'Auto submit after ${controllerGetx.valueAwait.value} s',
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                      ],
                    ),
                  )
        ],
      );
    }));
  }
}
