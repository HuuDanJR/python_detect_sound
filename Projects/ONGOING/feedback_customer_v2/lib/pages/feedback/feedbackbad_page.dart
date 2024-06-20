import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/model/item.dart';
import 'package:feedback_customer/pages/feedback/feedback_title.dart';
import 'package:feedback_customer/pages/feedback/feedbackgood_page.dart';
import 'package:feedback_customer/pages/note.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/string_custom.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackBadPage extends StatefulWidget {
  FeedbackBadPage({super.key, this.item});
  Item? item;

  @override
  State<FeedbackBadPage> createState() => _FeedbackBadPageState();
}

class _FeedbackBadPageState extends State<FeedbackBadPage> {
  final controllerGetx = Get.put(MyGetXController());
  final service_api = ServiceAPIs();
  @override
  void dispose() {
    super.dispose();
    // controllerGetx.resetListStatus();
  }

  @override
  void initState() {
    // controllerGetx.startCountdownTimer(() {
    //   print('start API startCountdownTimer');
    //   runFeedback();
    // });
    super.initState();
  }

  // void runFeedback() {
  //   service_api
  //       .createFeedback(
  //           tag: TAG_PRODUCT,
  //           id: widget.item!.id,
  //           content: widget.item!.name,
  //           exp: controllerGetx.getListStatusName())
  //       .then((value) {
  //     if (value['status'] == true) {
  //       customSnackBarSuccess(
  //           context: context,
  //           message: value['message'] ?? "Created feedback successfully");
  //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResultPage()));
  //     }
  //   }).whenComplete(() {
  //     controllerGetx.resetListStatus();
  //     controllerGetx.cancelResetAllTimer();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double heightArea = height *0.675;
    final double width = MediaQuery.of(context).size.width;
    final double widthArea = width * 0.7;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
      child: OrientationBuilder(builder: (context, orientation) {
        return 
            Container(
                alignment: Alignment.center,
                height: height,
                padding: const EdgeInsets.symmetric(horizontal:StringFactory.padding32),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    feedBackTitle(widthArea),
                    const SizedBox(height: StringFactory.padding32),
                    Container(
                        // color:MyColor.whiteopa,
                        width: widthArea,
                        height: heightArea,
                        alignment: Alignment.center,
                        child: Obx(
                          () => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controllerGetx.list.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(StringFactory.padding24),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: MyColor.grey_tab,
                                    onTap: () {
                                      print('choose it');
                                      // controllerGetx.restartTimer(() {
                                      //   runFeedback();
                                      // });
                                      controllerGetx.changeListStatus(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal:StringFactory.padding0,vertical:StringFactory.padding24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:  MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height:orientation == Orientation.portrait ?  heightArea / 3.25 : heightArea / 4,
                                            width: widthArea/2*.75,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: StringFactory.padding28,
                                                vertical: StringFactory.padding28),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular( StringFactory.padding42),
                                              color: controllerGetx.list[index].isSelected == true
                                                  ? MyColor.yellowSelected
                                                  : MyColor.background,
                                            ),
                                            child: Padding(
                                              padding:  EdgeInsets.all(orientation == Orientation.portrait ? StringFactory.padding24:StringFactory.padding12 ),
                                              child: Image.asset(
                                                fit: BoxFit.contain,
                                                scale: 1,
                                                controllerGetx.list[index].image,
                                                filterQuality: FilterQuality.high,
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: StringFactory.padding4,
                                          ),
                                          Text(
                                            controllerGetx.list[index].name,
                                            style: const TextStyle(fontSize:  StringFactory.padding26),
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
                                            ? .85
                                            : 1.5,
                                    mainAxisSpacing: StringFactory.padding20,
                                    crossAxisSpacing: StringFactory.padding20),
                          ),
                        )),
                    //button submit
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          customPressButton(
                              width: 225.0,
                              text: 'Submit ',
                              padding: StringFactory.padding32,
                              onPress: () {
                                print('press submit');
                                // print('${widget.item!.id}');
                                // print(widget.item!.name);
                                // print('list ${controllerGetx.getListStatusName()}');
                                //create feedback here
                                // runFeedback();
                                //end create feedback
                                showDialog(context: context, builder:(context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(StringFactory.padding42),
                                    content: textCustomCenter(text: title_dialog_feedback,size: StringFactory.padding26),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        customPressButton(
                                        isBoldColor: false,
                                        width: 195.0,
                                        text: 'NO',
                                        haveArrow: false,
                                        padding: StringFactory.padding32,
                                        onPress:(){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_)=> FeedbackGoodPage()));
                                        }
                                      ),
                                      customPressButton(
                                        width: 195.0,
                                        text: 'YES',
                                        padding: StringFactory.padding32,
                                        onPress:(){
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                                            return NotePage();
                                          }));
                                        }
                                      ),
                                        ],
                                      )
                                    ],
                                  );

                                },);
                              }),
                          // const SizedBox(
                          //   height: StringFactory.padding16,
                          // ),
                          // Obx(() => Text(
                          //     'Auto submit after ${controllerGetx.valueAwait.value} s',
                          //     style:  const TextStyle(fontSize:StringFactory.padding20, fontWeight: FontWeight.normal),),
                          // ),
                        ],
                      ),
                  ],
                ));
      }),
    ));
  }
}
