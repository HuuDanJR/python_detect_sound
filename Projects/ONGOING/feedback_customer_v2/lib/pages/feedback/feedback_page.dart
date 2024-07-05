import 'package:feedback_customer/api/api_service.dart';
import 'package:feedback_customer/getx/getx_controller.dart';
import 'package:feedback_customer/model/nationality.dart';
import 'package:feedback_customer/pages/feedback/feedback_image_asset.dart';
import 'package:feedback_customer/pages/feedback/feedback_title.dart';
// import 'package:feedback_customer/pages/feedback/feedbackgood_page.dart';
import 'package:feedback_customer/pages/note.dart';
import 'package:feedback_customer/pages/result.dart';
import 'package:feedback_customer/pages/staff/staff_page.dart';
import 'package:feedback_customer/util/color_custom.dart';
import 'package:feedback_customer/util/language_service.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:feedback_customer/widget/buttom_custom.dart';
import 'package:feedback_customer/widget/loading_dialog.dart';
import 'package:feedback_customer/widget/text_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackPage extends StatefulWidget {
  final String? statusName;
  final NatinalityDatum? userData;
  const FeedbackPage({super.key, this.statusName, this.userData});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final controllerGetx = Get.put(MyGetXController());
  final service_api = ServiceAPIs();

  @override
  void initState() {
    debugPrint('INIT FeedbackBadPage ${widget.statusName} ${widget.userData!.nationality} ${widget.userData!.number} ${widget.userData!.preferredName}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double heightArea = height * 0.675;
    final double width = MediaQuery.of(context).size.width;
    final double widthArea = width * 0.7;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: OrientationBuilder(builder: (context, orientation) {
            return Container(
                alignment: Alignment.center,
                height: height,
                padding: const EdgeInsets.symmetric(
                    horizontal: StringFactory.padding32),
                width: width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'asset/background.jpeg',
                      ),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.statusName == StringFactory.statusNamGood
                        ? feedBackTitle2(widthArea, context)
                        : feedBackTitle(widthArea, context),
                    // textCustom(text: translation(context).service_title),
                    const SizedBox(height: StringFactory.padding32),
                    Container(
                        width: widthArea,
                        height: heightArea,
                        alignment: Alignment.center,
                        child: Obx(
                          () => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controllerGetx.list_feedback.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    StringFactory.padding24),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: MyColor.grey_tab,
                                    onTap: () {
                                      debugPrint(  'choose feedback bad :  ${controllerGetx.list_feedback[index].name}');
                                      controllerGetx.changeListStatusFeedback(
                                          controllerGetx.list_feedback[index].id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: StringFactory.padding0,
                                          vertical: StringFactory.padding24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: orientation ==
                                                    Orientation.portrait
                                                ? heightArea / 3.25
                                                : heightArea / 4,
                                            width: widthArea / 2 * .75,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    StringFactory.padding28,
                                                vertical:
                                                    StringFactory.padding28),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      StringFactory.padding42),
                                              color: controllerGetx
                                                          .list_feedback[index]
                                                          .isSelected ==
                                                      true
                                                  ? MyColor.yellowSelected
                                                  : MyColor.background,
                                            ),
                                            child: imageAsset(
                                                orientation: orientation,
                                                index: controllerGetx
                                                    .list_feedback[index].id),
                                          ),
                                          const SizedBox(
                                            height: StringFactory.padding4,
                                          ),
                                          Center(child: textCustomLines(lines: 3,text:getTranslation(context,controllerGetx .list_feedback[index].name),size: StringFactory.padding26 ))
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
                            text: translation(context).submit,
                            padding: StringFactory.padding32,
                            onPress: () {
                              //end create feedback
                              if (widget.statusName == StringFactory.statusNamGood) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_)=>StaffPage(
                                                    userData: widget.userData,
                                                    note: "EMPTY",
                                                    listExp: controllerGetx.getSelectedFeedbackNames(),
                                                    hasNote: false,
                                                    statusName: widget.statusName,
                                )));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.all(
                                          StringFactory.padding42),
                                      content: textCustomLines(
                                          lines: 5,
                                          text:translation(context).title_survey,
                                          size: StringFactory.padding26),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customPressButton(
                                                isBoldColor: false,
                                                width: 195.0,
                                                text: translation(context).no,
                                                haveArrow: false,
                                                padding:StringFactory.padding32,
                                                onPress: () {
                                                  debugPrint('FeedbackBad No & Send APIs');
                                                  runFeedbackAPIs(context: context,listExp: controllerGetx.getSelectedFeedbackNames(),);
                                                }),
                                            customPressButton(
                                                width: 195.0,
                                                text: translation(context).yes,
                                                padding:StringFactory.padding32,
                                                onPress: () {
                                                  debugPrint('FeedbackBad Yes');
                                                  Navigator.of(context).push(MaterialPageRoute( builder: (_) {
                                                    return NotePage(
                                                      userData: widget.userData,
                                                      statusName: widget.statusName,
                                                      hasNote: true,
                                                      listExp: controllerGetx.getSelectedFeedbackNames(),
                                                    );
                                                  }));
                                                }),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
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
  void runFeedbackAPIs({ required context,required List<String> listExp,}) async {
    showLoadingDialog(context);
    try {
      await service_api.createFeedBackV2(
              statusName: widget.statusName.toString(),
              customerNumber: '${widget.userData!.number}',
              customerName:'${widget.userData!.title} ${widget.userData!.preferredName}',
              customerCode: '',
              customerNatinality:
                  '${widget.userData!.nationality} ${widget.userData!.isoCode2}',
              note: 'empty',
              hasNote: 'false',
              service_good: listExp,
              service_bad: listExp,
              staffNameEn:"empty" ,
              staffName: "empty",
              staffCode:"empty" ,
              staffRole:"empty" ,
              tag: 'PRODUCTION')
          .then((v) {
        if (v.status = true) {
          // customSnackBar(context: context, message: v.message);
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ResultPage()));
        } else {
          // customSnackBar( context: context, message: 'Can not create feedback or an error orcur');
        }
      }).whenComplete(() {});
    } catch (e) {
      // customSnackBar(context: context, message: 'An error occurred: $e');
      hideLoadingDialog(context);
    }
  }
}
